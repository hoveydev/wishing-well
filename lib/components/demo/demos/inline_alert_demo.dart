import 'package:flutter/material.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_type.dart';

class InlineAlertDemo extends StatelessWidget {
  const InlineAlertDemo({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Inline Alert Components'),
      backgroundColor: Colors.amber.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // All Alert Types
          _buildSection('Alert Types', [
            _buildAlertCard(
              'Info Alert',
              Colors.blue,
              const AppInlineAlert(
                message: 'This is an informational message.',
                type: AppInlineAlertType.info,
              ),
            ),
            _buildAlertCard(
              'Success Alert',
              Colors.green,
              const AppInlineAlert(
                message: 'Your changes have been saved successfully!',
                type: AppInlineAlertType.success,
              ),
            ),
            _buildAlertCard(
              'Warning Alert',
              Colors.orange,
              const AppInlineAlert(
                message: 'Please review your input before proceeding.',
                type: AppInlineAlertType.warning,
              ),
            ),
            _buildAlertCard(
              'Error Alert',
              Colors.red,
              const AppInlineAlert(
                message: 'An error occurred while processing your request.',
                type: AppInlineAlertType.error,
              ),
            ),
          ]),

          // Features Section
          _buildSection('Inline Alert Features', [
            const FeatureBulletPoint(
              text: 'Different types with unique icons and colors',
            ),
            const FeatureBulletPoint(text: 'Compact, inline design'),
            const FeatureBulletPoint(
              text: 'Semantic colors for each alert type',
            ),
            const FeatureBulletPoint(
              text: 'Accessibility-friendly with proper labels',
            ),
            const FeatureBulletPoint(
              text: 'Live region announcements for screen readers',
            ),
          ]),

          // Use Case Examples
          _buildSection('Use Case Examples', [
            const Text(
              'Form Validation:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            _buildAlertCard(
              'Validation Error',
              Colors.red,
              const AppInlineAlert(
                message: 'Please enter a valid email address.',
                type: AppInlineAlertType.error,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Success Message:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            _buildAlertCard(
              'Operation Success',
              Colors.green,
              const AppInlineAlert(
                message: 'Profile updated successfully!',
                type: AppInlineAlertType.success,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Informational Notice:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            _buildAlertCard(
              'Information',
              Colors.blue,
              const AppInlineAlert(
                message: 'Your session will expire in 5 minutes.',
                type: AppInlineAlertType.info,
              ),
            ),
          ]),

          // Long Messages
          _buildSection('Long Message Example', [
            _buildAlertCard(
              'Long Informational Message',
              Colors.blue,
              const AppInlineAlert(
                message:
                    'This is a longer informational message that '
                    'demonstrates how inline alerts '
                    'handle multi-line text content while maintaining their '
                    'compact design and readability.',
                type: AppInlineAlertType.info,
              ),
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

  Widget _buildAlertCard(String title, Color color, Widget alert) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.label, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: alert,
          ),
        ],
      ),
    ),
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
