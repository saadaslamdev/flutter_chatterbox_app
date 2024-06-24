import 'package:flutter/material.dart';
import 'package:globatchat_app/components/snack_bar_component.dart';
import 'package:globatchat_app/view_models/auth_viewmodel.dart';
import 'package:globatchat_app/views/login_screen.dart';
import 'package:provider/provider.dart';

import '../components/future_fullscreen_loader.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Future<void> createUser() async {
  //   try {
  //     UserCredential userCredential =
  //         await _auth.createUserWithEmailAndPassword(
  //             email: emailController.text, password: passwordController.text);

  //     await userCredential.user!.updateProfile(
  //       displayName: emailController.text,
  //     );

  //     if (mounted) {
  //       Navigator.pop(context);
  //     }

  //     SnackBarMessage.showSnackBar(
  //         context, 'Account created successfully', Colors.green);
  //   } catch (e) {
  //     print(e);
  //     SnackBarMessage.showSnackBar(context, e.toString(), Colors.red);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset('assets/images/logo.png')),
                TextFormField(
                  controller: usernameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: 'Username', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: 'Password', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(200, 50)),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      FutureFullscreenLoader.show<void>(
                        context: context,
                        future: () async {
                          var (error, _) = await Provider.of<AuthViewModel>(
                                  context,
                                  listen: false)
                              .signUp(
                                  emailController.text,
                                  passwordController.text,
                                  usernameController.text);
                          if (error != null) {
                            throw error;
                          }
                        },
                        onComplete: (context) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                            SnackBarComponent.showSnackBar(
                              context,
                              'Account created successfully',
                              Colors.green,
                            );
                          });
                        },
                        onError: (context, error) {
                          SnackBarComponent.showSnackBar(
                              context, error.toString(), Colors.red);
                        },
                      );
                    }
                  },
                  child: const Text('SIGN UP', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        )));
  }
}
