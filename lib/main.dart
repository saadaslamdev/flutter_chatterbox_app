import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const GlobalChatApp());
}

class GlobalChatApp extends StatefulWidget {
  const GlobalChatApp({super.key});

  @override
  State<GlobalChatApp> createState() => _GlobalChatAppState();
}

class _GlobalChatAppState extends State<GlobalChatApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Global Chat',
      theme: ThemeData(
          fontFamily: 'Poppins',
          brightness: Brightness.dark,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFbc2a50),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
          ),
          useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
