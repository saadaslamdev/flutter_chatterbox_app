import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:globatchat_app/view_models/chat_viewmodel.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'view_models/auth_viewmodel.dart';
import 'views/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const GlobalChatApp(),
    ),
  );
}

class GlobalChatApp extends StatefulWidget {
  const GlobalChatApp({super.key});

  @override
  State<GlobalChatApp> createState() => _GlobalChatAppState();
}

class _GlobalChatAppState extends State<GlobalChatApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(),
        ),
        ChangeNotifierProvider<ChatViewModel>(
          create: (_) => ChatViewModel(),
        ),
      ],
      builder: DevicePreview.appBuilder,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ChatterBox',
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
      ),
    );
  }
}
