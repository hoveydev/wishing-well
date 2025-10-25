import 'package:flutter/material.dart';
import 'package:wishing_well/screens/login_screen.dart';
import 'package:wishing_well/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: LoginScreen(), // change screen for testing until routing is set up
    );
  }
}
