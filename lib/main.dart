import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/button.dart';
import 'components/button/button_type.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Button(
                    label: 'Sign in',
                    onPressed: () {},
                    type: ButtonType.primary,
                  ),
                  const SizedBox(height: 8),
                  Button(
                    label: 'Create an Account',
                    onPressed: () {},
                    type: ButtonType.secondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
