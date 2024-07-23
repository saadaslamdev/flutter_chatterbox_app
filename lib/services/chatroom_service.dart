import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:globatchat_app/models/chatroom_message_model.dart';
import 'package:globatchat_app/models/chatroom_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Stream<List<ChatRoomMessageModel>> getMessages(String chatRoomId) {
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatRoomMessageModel.fromMap(doc.data()))
            .toList());
  }

  Future<void> sendMessage(
      String chatRoomId, ChatRoomMessageModel message) async {
    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(message.toMap());
  }

  Future<DocumentReference> createChatRoom(ChatRoomModel chatRoom) async {
    var docRef = await _firestore.collection('chatRooms').add(chatRoom.toMap());
    return docRef;
  }

  Future<void> updateChatRoomModel(String id, Map<String, dynamic> data) async {
    await _firestore
        .collection('chatRooms')
        .doc(id)
        .set(data, SetOptions(merge: true));
  }

  Future<List<Map<String, dynamic>>> getAllChatRooms() async {
    List<Map<String, dynamic>> chatRooms = [];
    await _firestore.collection('chatRooms').get().then((dataSnapshot) {
      for (var doc in dataSnapshot.docs) {
        chatRooms.add(doc.data());
      }
    });
    return chatRooms;
  }

  Future<void> uploadGroupImageToFirestore(
      String chatRoomId, Uint8List imageBytes) async {
    final storageRef =
        firebaseStorage.ref().child('chatRooms/$chatRoomId/GroupImage.jpg');

    await storageRef.putData(imageBytes);
  }

  Future<String> getGroupImageDownloadURL(String chatRoomId) async {
    final storageRef =
        firebaseStorage.ref().child('chatRooms/$chatRoomId/GroupImage.jpg');

    String downloadURL = await storageRef.getDownloadURL();
    return downloadURL;
  }
}
