import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globatchat_app/view_models/auth_viewmodel.dart';
import 'package:globatchat_app/views/dashboard_screen.dart';
import 'package:globatchat_app/views/lets_get_started_screen.dart';
import 'package:globatchat_app/views/login_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      if (user != null) {
        openDashboardAsync();
      } else {
        openLogin();
      }
    });

    super.initState();
  }

  void openLogin() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const LoginScreen();
    }));
  }

  Future<void> openDashboardAsync() async {
    var userModel = Provider.of<AuthViewModel>(context, listen: false);
    await userModel.fetchUserData(user!);

    if (userModel.userModel!.isSurveyCompleted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const DashboardScreen();
      }));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const LetsGetStartedScreen();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SizedBox(
          width: 300,
          height: 300,
          child: Image.asset('assets/images/SplashLogo.png')),
    ));
  }
}
