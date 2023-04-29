import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';
import 'package:tiktok_clone/features/inbox/repositories/messages_repository.dart';

class MessagesViewModel extends AsyncNotifier<void> {
  late final MessagesRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(messagesRepository);
  }

  Future<void> sendMessage(String text) async {
    final userId = ref.read(authRepository).user!.uid;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final message = MessageModel(
        text: text,
        userId: userId,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      _repository.sendMessage(message);
    });
  }
}

final messagesProvider = AsyncNotifierProvider<MessagesViewModel, void>(
  () => MessagesViewModel(),
);

final chatProvider = StreamProvider.autoDispose<List<MessageModel>>(
  (ref) {
    final db = FirebaseFirestore.instance;
    return db
        .collection('chat_rooms')
        .doc('hBGeyzW1SmKwXqbdGbcm')
        .collection('texts')
        .orderBy('createdAt')
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (doc) => MessageModel.fromJson(
                  doc.data(),
                ),
              )
              .toList()
              .reversed
              .toList(),
        );
  },
);
