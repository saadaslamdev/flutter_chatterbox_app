import 'package:flutter/material.dart';
import 'package:globatchat_app/views/splash_screen.dart';
import 'package:provider/provider.dart';

import '../view_models/auth_viewmodel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<AuthViewModel>(
          builder: (context, auth, _) {
            if (auth.userModel == null) {
              return const CircularProgressIndicator();
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(auth.userModel!.name),
                  Text(auth.userModel!.email),
                  Text(auth.userModel!.id),
                  ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(200, 50)),
                    ),
                    onPressed: () async {
                      await auth.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SplashScreen(),
                        ),
                      );
                    },
                    child:
                        const Text('SIGNOUT', style: TextStyle(fontSize: 20)),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
