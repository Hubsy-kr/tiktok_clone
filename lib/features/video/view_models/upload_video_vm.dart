import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repo.dart';
import 'package:tiktok_clone/features/users/view_models/users_vm.dart';
import 'package:tiktok_clone/features/video/models/video_model.dart';
import 'package:tiktok_clone/features/video/repositories/videos_repository.dart';

class UploadVideoViewModel extends AsyncNotifier<void> {
  late final VideosRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(videosRepository);
  }

  Future<void> uploadVideo(File video, BuildContext context) async {
    final user = ref.read(authRepository).user;
    final userProfile = ref.read(usersProvider).value;
    if (userProfile != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(
        () async {
          final task = await _repository.uploadVideoFile(
            video,
            user!.uid,
          );
          if (task.metadata != null) {
            // 파일이 성공적으로 업로드되었다.
            await _repository.saveVideo(
              VideoModel(
                title: 'From Flutter!',
                description: 'Hell yeah!',
                fileUrl: await task.ref.getDownloadURL(),
                thumbnailUrl: '',
                creatorUid: user.uid,
                creator: userProfile.name,
                likes: 0,
                comments: 0,
                createdAt: DateTime.now().millisecondsSinceEpoch,
              ),
            );

            context.pop();
            context.pop();
          }
        },
      );
    }
  }
}

final uploadVideoViewModel = AsyncNotifierProvider<UploadVideoViewModel, void>(
  () => UploadVideoViewModel(),
);
