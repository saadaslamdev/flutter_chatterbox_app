import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String id;
  final String name;
  final String description;
  final String? profilePictureURL;
  String? messages;
  final Timestamp createdAt;
  final String createdBy;

  ChatRoomModel({
    required this.id,
    required this.name,
    required this.description,
    this.profilePictureURL,
    this.messages,
    required this.createdAt,
    required this.createdBy,
  });

  factory ChatRoomModel.fromMap(Map<String, dynamic> data) {
    return ChatRoomModel(
        id: data['id'] ?? '',
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        profilePictureURL: data['profilePicture'] ?? '',
        messages: data['messages'] ?? '',
        createdAt: data['createdAt'],
        createdBy: data['createdBy'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'profilePicture': profilePictureURL,
      'messages': messages,
      'createdAt': createdAt,
      'createdBy': createdBy,
    };
  }
}
