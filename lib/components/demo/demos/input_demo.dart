import 'package:flutter/material.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/utils/app_logger.dart';

class InputDemo extends StatefulWidget {
  const InputDemo({super.key});

  @override
  State<InputDemo> createState() => _InputDemoState();
}

class _InputDemoState extends State<InputDemo> {
  final _textController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  String _textValue = '';
  String _emailValue = '';
  String _passwordValue = '';
  String _phoneValue = '';

  @override
  void dispose() {
    _textController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Input Components'),
      backgroundColor: Colors.purple.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text Input
          _buildSection('Text Input', [
            AppInput(
              placeholder: 'Enter your name',
              type: AppInputType.text,
              onChanged: (value) => setState(() => _textValue = value),
            ),
            const SizedBox(height: 8),
            Text(
              'Value: $_textValue',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ]),

          // Email Input
          _buildSection('Email Input', [
            AppInput(
              placeholder: 'Enter your email',
              type: AppInputType.email,
              onChanged: (value) => setState(() => _emailValue = value),
            ),
            const SizedBox(height: 8),
            Text(
              'Value: $_emailValue',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ]),

          // Password Input
          _buildSection('Password Input', [
            AppInput(
              placeholder: 'Enter your password',
              type: AppInputType.password,
              onChanged: (value) => setState(() => _passwordValue = value),
            ),
            const SizedBox(height: 8),
            Text(
              'Value: ${_passwordValue.isNotEmpty ? '••••••••' : ''}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ]),

          // Phone Input
          _buildSection('Phone Input', [
            AppInput(
              placeholder: 'Enter your phone number',
              type: AppInputType.phone,
              onChanged: (value) => setState(() => _phoneValue = value),
            ),
            const SizedBox(height: 8),
            Text(
              'Value: $_phoneValue',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ]),

          // Features Section
          _buildSection('Input Features', [
            const FeatureBulletPoint(
              text: 'Auto-detection of input type with appropriate icons',
            ),
            const FeatureBulletPoint(
              text: 'Password field with secure text entry',
            ),
            const FeatureBulletPoint(
              text: 'Email and password autofill support',
            ),
            const FeatureBulletPoint(
              text: 'Consistent styling with theme colors',
            ),
            const FeatureBulletPoint(
              text: 'Accessibility labels for screen readers',
            ),
          ]),

          // Interactive Example
          _buildSection('Interactive Example', [
            const Text(
              'Try filling out the form below:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            AppInput(
              placeholder: 'Full Name',
              type: AppInputType.text,
              onChanged: (value) =>
                  AppLogger.debug('Name: $value', context: 'InputDemo'),
            ),
            const SizedBox(height: 16),
            AppInput(
              placeholder: 'Email Address',
              type: AppInputType.email,
              onChanged: (value) =>
                  AppLogger.safe('Email: $value', context: 'InputDemo'),
            ),
            const SizedBox(height: 16),
            AppInput(
              placeholder: 'Password',
              type: AppInputType.password,
              onChanged: (value) =>
                  AppLogger.safe('Password: $value', context: 'InputDemo'),
            ),
            const SizedBox(height: 16),
            AppInput(
              placeholder: 'Phone Number',
              type: AppInputType.phone,
              onChanged: (value) =>
                  AppLogger.safe('Phone: $value', context: 'InputDemo'),
            ),
          ]),
        ],
      ),
    ),
  );

  Widget _buildSection(String title, List<Widget> children) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      ...children,
      const SizedBox(height: 24),
    ],
  );
}

class FeatureBulletPoint extends StatelessWidget {
  const FeatureBulletPoint({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
      ],
    ),
  );
}
