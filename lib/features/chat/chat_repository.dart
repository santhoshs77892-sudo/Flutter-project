import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../core/backend/backend_service.dart';
import '../../core/backend/firebase_collections.dart';
import '../common/models.dart';

class ChatRepository {
  ChatRepository(this._backend);

  final BackendService _backend;
  final Uuid _uuid = const Uuid();

  Stream<QuerySnapshot<Map<String, dynamic>>> messages(String conversationId) {
    return _backend.firestore
        .collection(FirebaseCollections.conversations)
        .doc(conversationId)
        .collection(FirebaseCollections.messages)
        .orderBy('sentAt', descending: true)
        .snapshots();
  }

  Future<void> sendTextMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    final messageId = _uuid.v4();
    final message = ChatMessage(
      id: messageId,
      senderId: senderId,
      type: 'text',
      text: text,
    );

    final conversationRef = _backend.firestore
        .collection(FirebaseCollections.conversations)
        .doc(conversationId);

    final messageRef = conversationRef
        .collection(FirebaseCollections.messages)
        .doc(messageId);

    final batch = _backend.firestore.batch();

    batch.set(messageRef, message.toJson());
    batch.set(
      conversationRef,
      {
        'lastMessage': text,
        'lastMessageType': 'text',
        'lastMessageAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }
}
