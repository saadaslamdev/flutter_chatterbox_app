import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomMessageModel {
  final String chatRoomId;
  final String senderId;
  final String senderName;
  final String message;
  final Timestamp timestamp;

  ChatRoomMessageModel({
    required this.chatRoomId,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
  });

  factory ChatRoomMessageModel.fromMap(Map<String, dynamic> data) {
    return ChatRoomMessageModel(
      chatRoomId: data['chatRoomId'],
      senderId: data['senderId'],
      senderName: data['senderName'],
      message: data['message'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
