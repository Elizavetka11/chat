import 'package:chat/firebase_options.dart';
import 'package:chat/pages/register_page.dart';
import 'package:chat/services/auth/auth_gate.dart';
import 'package:chat/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';
import 'services/auth/login_or_registration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
      ChangeNotifierProvider(
        create: (context) => AuthService(),
        child: const MyApp(),
      ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}

