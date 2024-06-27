import 'package:flutter/material.dart';
import 'package:globatchat_app/view_models/auth_viewmodel.dart';
import 'package:globatchat_app/views/dashboard_screen.dart';
import 'package:globatchat_app/views/lets_get_started_screen.dart';
import 'package:globatchat_app/views/signup_screen.dart';
import 'package:provider/provider.dart';

import '../components/future_fullscreen_loader.dart';
import '../components/snack_bar_component.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            width: 200,
            height: 200,
            child: Image.asset('assets/images/logo.png')),
        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
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
                  controller: _passwordController,
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
                    fixedSize: WidgetStateProperty.all(const Size(200, 50)),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      FutureFullscreenLoader.show<void>(
                        context: context,
                        future: () async {
                          var (error, _) = await authViewModel.signIn(
                              _emailController.text, _passwordController.text);
                          if (error != null) {
                            throw error;
                          }
                        },
                        onComplete: (context) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (authViewModel.userModel!.isSurveyCompleted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DashboardScreen()),
                              );
                              return;
                            }
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LetsGetStartedScreen()),
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
                  child: const Text('LOGIN', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?",
                        style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const SignUpScreen();
                        }));
                      },
                      child: const Text("SIGN UP HERE!",
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFFbc2a50),
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
