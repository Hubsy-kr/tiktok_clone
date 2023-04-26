import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/video/models/video_model.dart';

class VideosRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //upload a video file
  UploadTask uploadVideoFile(File video, String uid) {
    final fileRef = _storage.ref().child(
        '/videos/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}');

    return fileRef.putFile(video);
  }

  // create a video document
  Future<void> saveVideo(VideoModel data) async {
    await _db.collection('videos').add(data.toJson());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos({
    int? lastItemCreatedAt,
  }) {
    // return _db.collection('videos').where('likes', isGreaterThan: 10).get();
    final query = _db
        .collection('videos')
        .orderBy('createdAt', descending: true)
        .limit(2);
    if (lastItemCreatedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastItemCreatedAt]).get();
    }
  }

  Future<void> likeVideo(String videoId, String userId) async {
    await _db.collection('likes').add({
      "videoId": videoId,
      "userId": userId,
    });
  }
}

final videosRepository = Provider(
  (ref) => VideosRepository(),
);
