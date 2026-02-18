import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  ChatUser({
    required this.uid,
    required this.phoneNumber,
    this.displayName,
    this.photoUrl,
    this.about,
    this.isOnline = false,
  });

  final String uid;
  final String phoneNumber;
  final String? displayName;
  final String? photoUrl;
  final String? about;
  final bool isOnline;

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'phoneNumber': phoneNumber,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'about': about,
        'isOnline': isOnline,
        'lastSeenAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      };
}

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.senderId,
    required this.type,
    this.text,
    this.mediaUrl,
  });

  final String id;
  final String senderId;
  final String type;
  final String? text;
  final String? mediaUrl;

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'type': type,
        'text': text,
        'mediaUrl': mediaUrl,
        'sentAt': FieldValue.serverTimestamp(),
        'deliveredTo': <String>[],
        'readBy': <String>[],
      };
}
