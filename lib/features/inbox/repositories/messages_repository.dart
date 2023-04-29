import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/message_model.dart';

class MessagesRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessage(MessageModel message) async {
    await _db
        .collection('chat_rooms')
        .doc('hBGeyzW1SmKwXqbdGbcm')
        .collection('texts')
        .add(message.toJson());
  }
}

final messagesRepository = Provider((ref) => MessagesRepository());
