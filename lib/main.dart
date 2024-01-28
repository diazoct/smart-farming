import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_aja/screens/welcome_screen.dart';
import 'package:test_aja/theme/theme.dart';
import 'package:test_aja/timer_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyBSvaTp1fk2giMrGbiyyyvsyin49DUtrVA',
              appId: '1:731469557712:android:427e1c8ae9fb1bac1f93d5',
              messagingSenderId: '731469557712',
              projectId: 'testaja-b89a4'))
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimerModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: const WelcomeScreen(),
      ),
    );
  }
}
