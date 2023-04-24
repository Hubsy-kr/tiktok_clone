import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const onVideoCreated = functions.firestore
    .document("videos/{videoId}")
    .onCreate(async (snapshot, context)=>{
        const spawn = require('child-process-promise').spawn;
        const video = snapshot.data();
        await spawn("ffmpeg",[
            "-i",
            video.fileUrl,  // 새로운 영상이 upload되면 ffmpeg가 다운로드
            "-ss",
            "00:00:01.000", // 1초 시간대의
            "-vframes",
            "1",            // 첫 프레임을 가지고 감
            "-vf",
            "scale=150:-1", // 너비는 150, 높이는 거기에 맞춰서(-1) 설정
            `/tmp/${snapshot.id}.jpg`
        ]);
        const storage = admin.storage();
        const [file, _] = await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
            destination:`thumbnails/${snapshot.id}.jpg`
        });
        await file.makePublic();
        await snapshot.ref.update({thumbnailUrl: file.publicUrl()});

        // 과부하를 줄이기위해 역정규화, noSql에서 흔히쓰이는 전략
        const db = admin.firestore();
        await db
            .collection("users")
            .doc(video.creatorUid)
            .collection("/videos")
            .doc(snapshot.id)
            .set({
            thumbnailUrl: file.publicUrl(),
            videoId: snapshot.id,
        })
    });