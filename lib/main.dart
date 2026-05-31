import 'package:flutter/material.dart';
import 'screens/signup.dart';

void main() {
  runApp(const SkinSenseApp());
}

class SkinSenseApp extends StatelessWidget {
  const SkinSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skin Sense',
      theme: ThemeData(
        fontFamily: 'Arial',
      ),
      home: const SignupScreen(),
    );
  }
}