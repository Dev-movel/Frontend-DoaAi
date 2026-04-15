import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'screens/signup_screen.dart';

void main() {
  runApp(const DoaUTFApp());
}

class DoaUTFApp extends StatelessWidget {
  const DoaUTFApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoaUTF',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      home: const SignUpScreen(),
    );
  }
}
