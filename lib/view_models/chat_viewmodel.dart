import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:globatchat_app/models/chatroom_message_model.dart';
import 'package:globatchat_app/models/chatroom_model.dart';
import 'package:globatchat_app/services/chatroom_service.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatService _chatService = ChatService();

  List<ChatRoomModel> _chatRooms = [];
  List<ChatRoomModel> get chatRooms => _chatRooms;

  ChatViewModel() {
    listenToChatRoom();
  }

  Future listenToChatRoom() async {
    await getAllChatRooms();
    // _chatService.getMessages(_chatRoomModel!.id).listen((messages) {
    //   _chatRoomModel!.messages = messages as String?;
    //   notifyListeners();
    // });
  }

  Future<(String? chatRoomID, String? error)> createChatRoom(
      Map<String, dynamic> chatRoom) async {
    try {
      var chatRoomRef =
          await _chatService.createChatRoom(ChatRoomModel.fromMap(chatRoom));
      await updateChatRoomData(chatRoomRef.id, {'id': chatRoomRef.id});
      notifyListeners();
      return (chatRoomRef.id, null);
    } catch (e) {
      print(e);
      return (null, 'Not able to create a chat room');
    }
  }

  Future<String?> sendMessage(
      String chatRoomId, Map<String, dynamic> messageData) async {
    try {
      var chatRoom = _chatRooms.where((element) => element.id == chatRoomId);
      if (chatRoom.isNotEmpty) {
        await _chatService.sendMessage(
            chatRoomId, ChatRoomMessageModel.fromMap(messageData));
        await _chatService.getMessages(chatRoomId).first;
        notifyListeners();
        return null;
      }
    } catch (e) {
      print(e);
      return 'Not able to send this message';
    }
  }

  Future<void> getAllChatRooms() async {
    try {
      List<ChatRoomModel> chatRooms = [];
      var chatRoomsData = await _chatService.getAllChatRooms();
      for (var chatRoom in chatRoomsData) {
        chatRooms.add(ChatRoomModel.fromMap(chatRoom));
      }
      _chatRooms = chatRooms;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<String?> uploadGroupImageToFirestore(
      String chatRoomId, Uint8List imageBytes) async {
    try {
      await _chatService.uploadGroupImageToFirestore(chatRoomId, imageBytes);
      return null;
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  Future<String?> getGroupImage(String chatRoomId) async {
    try {
      var downloadLink =
          await _chatService.getGroupImageDownloadURL(chatRoomId);
      Map<String, dynamic> data = {'profilePictureURL': downloadLink};
      await updateChatRoomData(chatRoomId, data);
      notifyListeners();
      return null;
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  Future<String?> updateChatRoomData(
      String chatRoomID, Map<String, dynamic> chatRoomModel) async {
    try {
      await _chatService.updateChatRoomModel(chatRoomID, chatRoomModel);
      await getAllChatRooms();
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
