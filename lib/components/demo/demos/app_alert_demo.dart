import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_alert/app_alert.dart';
import 'package:wishing_well/components/app_alert/app_alert_type.dart';

class AppAlertDialog extends StatefulWidget {
  const AppAlertDialog({super.key});

  @override
  State<AppAlertDialog> createState() => _AppAlertDialogState();
}

class _AppAlertDialogState extends State<AppAlertDialog> {
  void _showAlert({
    required String title,
    required String message,
    required String confirmLabel,
    required AppAlertType type,
  }) {
    showDialog(
      context: context,
      builder: (context) => AppAlert(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        type: type,
        onConfirm: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('${type.name} confirmed')));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Alert Components'),
      backgroundColor: Colors.orange.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Error Alerts
          _buildSection('Error Alerts', [
            _buildAlertButton(
              title: 'Error Alert',
              subtitle: 'Shows an error dialog',
              icon: Icons.error_outline,
              color: Colors.red,
              onTap: () => _showAlert(
                title: 'Error',
                message:
                    'An error occurred while processing '
                    'your request. Please try again.',
                confirmLabel: 'OK',
                type: AppAlertType.error,
              ),
            ),
          ]),

          // Warning Alerts
          _buildSection('Warning Alerts', [
            _buildAlertButton(
              title: 'Warning Alert',
              subtitle: 'Shows a warning dialog',
              icon: Icons.warning_amber_outlined,
              color: Colors.orange,
              onTap: () => _showAlert(
                title: 'Warning',
                message:
                    'This action cannot be undone. '
                    'Are you sure you want to proceed?',
                confirmLabel: 'Proceed',
                type: AppAlertType.warning,
              ),
            ),
          ]),

          // Success Alerts
          _buildSection('Success Alerts', [
            _buildAlertButton(
              title: 'Success Alert',
              subtitle: 'Shows a success dialog',
              icon: Icons.check_circle_outline,
              color: Colors.green,
              onTap: () => _showAlert(
                title: 'Success',
                message: 'Your changes have been saved successfully.',
                confirmLabel: 'Great!',
                type: AppAlertType.success,
              ),
            ),
          ]),

          // Info Alerts
          _buildSection('Info Alerts', [
            _buildAlertButton(
              title: 'Info Alert',
              subtitle: 'Shows an information dialog',
              icon: Icons.info_outline,
              color: Colors.blue,
              onTap: () => _showAlert(
                title: 'Information',
                message: 'This is an informational message for the user.',
                confirmLabel: 'Got it',
                type: AppAlertType.info,
              ),
            ),
          ]),

          // Features Section
          _buildSection('Alert Features', [
            const FeatureBulletPoint(
              text: 'Four alert types: error, warning, success, and info',
            ),
            const FeatureBulletPoint(
              text: 'Color-coded icons for visual distinction',
            ),
            const FeatureBulletPoint(
              text: 'Accessible with semantic labels for screen readers',
            ),
            const FeatureBulletPoint(
              text: 'Live region support for announcements',
            ),
            const FeatureBulletPoint(
              text: 'Customizable title, message, and confirm button label',
            ),
            const FeatureBulletPoint(
              text: 'Automatic dialog dismissal on confirmation',
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

  Widget _buildAlertButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) => Card(
    child: ListTile(
      leading: Icon(icon, color: color, size: 32),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
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
