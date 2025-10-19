import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/button.dart';
import 'package:wishing_well/components/input/input.dart';
import 'package:wishing_well/components/input/input_type.dart';
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
                  Text("Logo Placeholder"),
                  Text("WishingWell"),
                  Text("Your personal well for thoughtful giving"),
                  Spacer(),
                  Input(placeholder: "Email", type: InputType.text, controller: TextEditingController()),
                  const SizedBox(height: 8),
                  Input(placeholder: "Password", type: InputType.text, controller: TextEditingController()),
                  Spacer(),
                  Button(label: "Forgot Password?", onPressed: () {}, type: ButtonType.tertiary),
                  const SizedBox(height: 8),
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
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
