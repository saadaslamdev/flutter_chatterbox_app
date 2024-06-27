import 'dart:io';

import 'package:flutter/material.dart';
import 'package:globatchat_app/components/future_fullscreen_loader.dart';
import 'package:globatchat_app/components/snack_bar_component.dart';
import 'package:globatchat_app/view_models/auth_viewmodel.dart';
import 'package:globatchat_app/views/dashboard_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LetsGetStartedScreen extends StatefulWidget {
  const LetsGetStartedScreen({super.key});

  @override
  State<LetsGetStartedScreen> createState() => _LetsGetStartedScreenState();
}

class _LetsGetStartedScreenState extends State<LetsGetStartedScreen> {
  final _dateController = TextEditingController();
  final _bioController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? selectedGender;
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void setUserDataAndNavigateToDashboard(
      AuthViewModel userModel, Map<String, dynamic> userData) {
    FutureFullscreenLoader.show<void>(
      context: context,
      future: () async {
        var (error) = await userModel.setUserModel(userData);
        if (error != null) {
          throw error;
        }
      },
      onComplete: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const DashboardScreen();
          }));
        });
      },
      onError: (context, error) {
        SnackBarComponent.showSnackBar(context, error.toString(), Colors.red);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    final userModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: () {
                  Map<String, dynamic> userData = {
                    'isSurveyCompleted':
                        userModel.userModel!.isSurveyCompleted == false
                            ? true
                            : false
                  };
                  setUserDataAndNavigateToDashboard(userModel, userData);
                },
                child: const Text('SKIP',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text('lets get started!',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                                      'Take a photo',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            blurRadius: 5,
                                            offset: const Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : ClipOval(child: Image.network(_image!.path)),
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
                              GestureDetector(
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );

                                  if (pickedDate != null) {
                                    setState(() {
                                      _dateController.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                    });
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _dateController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Date of Birth is required';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Date of Birth',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              DropdownButtonFormField<String>(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                value: selectedGender,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedGender = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select your gender';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Gender',
                                  border: OutlineInputBorder(),
                                ),
                                items: ['Male', 'Female', 'Other']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _bioController,
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  labelText: 'Enter your bio (optional)',
                                  hintText: 'Tell us about yourself',
                                  border: OutlineInputBorder(),
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
              Padding(
                padding: const EdgeInsets.all(25),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Map<String, dynamic> userData = {
                          'dateOfBirth': _dateController.text,
                          'bio': _bioController.text,
                          'gender': selectedGender,
                          'isSurveyCompleted': true
                        };
                        setUserDataAndNavigateToDashboard(userModel, userData);
                      }
                    },
                    child:
                        const Text('PROCEED', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
