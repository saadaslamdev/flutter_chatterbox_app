import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:globatchat_app/view_models/auth_viewmodel.dart';
import 'package:globatchat_app/views/dashboard_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../components/future_fullscreen_loader.dart';
import '../components/snack_bar_component.dart';
import '../view_models/chat_viewmodel.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _groupNameTextController = TextEditingController();
  final _groupDescriptionTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var chatViewModel = Provider.of<ChatViewModel>(context);
    var authViewModel = Provider.of<AuthViewModel>(context);
    var formKey = GlobalKey<FormState>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create a Group Chat'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context)
              .elevatedButtonTheme
              .style!
              .backgroundColor
              ?.resolve({WidgetState.pressed}),
          child: const Icon(Icons.done),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              Map<String, dynamic> userData = {
                'name': _groupNameTextController.text,
                'description': _groupDescriptionTextController.text,
                'createdAt': Timestamp.now(),
                'createdBy': authViewModel.userModel!.id,
              };

              FutureFullscreenLoader.show<void>(
                context: context,
                future: () async {
                  var (chatRoomID, error) =
                      await chatViewModel.createChatRoom(userData);

                  if (error != null) {
                    print('error');
                    throw error;
                  }

                  if (_image != null) {
                    var (error2) =
                        await chatViewModel.uploadGroupImageToFirestore(
                            chatRoomID!, _image!.readAsBytesSync());

                    if (error2 != null) {
                      print('error2 $error2');
                      throw error2;
                    }
                  }
                },
                onComplete: (context) {
                  Navigator.pop(context, 'refresh');
                },
                onError: (context, error) {
                  print(error);
                  SnackBarComponent.showSnackBar(
                      context, error.toString(), Colors.red);
                },
              );
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        _pickImage(ImageSource.gallery);
                      },
                      child: Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              _image != null ? const Color(0xFFbc2a50) : null,
                          gradient: _image == null
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFFbc2a50),
                                    Color(0xFF7a1f3d),
                                    Color(0xFFe94e77),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: _image == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.camera_alt,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Add a photo',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.5),
                                          blurRadius: 5,
                                          offset: const Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : ClipOval(
                                child: kIsWeb
                                    ? Image.network(_image!.path,
                                        fit: BoxFit.cover)
                                    : Image.file(_image!, fit: BoxFit.cover)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _groupNameTextController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Group name is required';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Group Name',
                              ),
                            ),
                            const SizedBox(height: 25),
                            TextFormField(
                              controller: _groupDescriptionTextController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Group Description (optional)',
                                alignLabelWithHint: true,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )));
  }
}
