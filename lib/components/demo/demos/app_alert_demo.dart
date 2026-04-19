import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_alert/app_alert.dart';
import 'package:wishing_well/components/app_alert/app_alert_type.dart';

class AppAlertDialog extends StatefulWidget {
  const AppAlertDialog({super.key});

  @override
  State<AppAlertDialog> createState() => _AppAlertDialogState();
}

class _AppAlertDialogState extends State<AppAlertDialog> {
  String _lastResult = '';

  Future<void> _showAlert({
    required String title,
    required String message,
    required String confirmLabel,
    required AppAlertType type,
    String? cancelLabel,
    bool isDestructive = false,
  }) async {
    final result = await AppAlert.show(
      context: context,
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      type: type,
      cancelLabel: cancelLabel,
      isDestructive: isDestructive,
    );

    if (!mounted) return;

    final outcome = switch (result) {
      true => 'Confirmed',
      false => 'Cancelled',
      _ => 'Dismissed',
    };

    setState(() => _lastResult = outcome);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Alert Component'),
      backgroundColor: Colors.orange.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_lastResult.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                color: Colors.green.withValues(alpha: 0.08),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Last result: $_lastResult',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

          _buildSection('1-Button Alerts', [
            _buildTriggerButton(
              title: 'Error Alert',
              subtitle: 'Single confirm button',
              icon: Icons.error_outline,
              color: Colors.red,
              onTap: () => _showAlert(
                title: 'Something went wrong',
                message:
                    'An error occurred while processing your request. '
                    'Please try again.',
                confirmLabel: 'OK',
                type: AppAlertType.error,
              ),
            ),
            _buildTriggerButton(
              title: 'Warning Alert',
              subtitle: 'Single confirm button',
              icon: Icons.warning_amber_outlined,
              color: Colors.orange,
              onTap: () => _showAlert(
                title: 'Heads up',
                message: 'This action may have unintended side effects.',
                confirmLabel: 'Got it',
                type: AppAlertType.warning,
              ),
            ),
            _buildTriggerButton(
              title: 'Success Alert',
              subtitle: 'Single confirm button',
              icon: Icons.check_circle_outline,
              color: Colors.green,
              onTap: () => _showAlert(
                title: 'All done!',
                message: 'Your changes have been saved successfully.',
                confirmLabel: 'Great!',
                type: AppAlertType.success,
              ),
            ),
            _buildTriggerButton(
              title: 'Info Alert',
              subtitle: 'Single confirm button',
              icon: Icons.info_outline,
              color: Colors.blue,
              onTap: () => _showAlert(
                title: 'Did you know?',
                message: 'This is an informational message for the user.',
                confirmLabel: 'Got it',
                type: AppAlertType.info,
              ),
            ),
          ]),

          _buildSection('2-Button Alerts (Confirmation)', [
            _buildTriggerButton(
              title: 'Standard Confirmation',
              subtitle: 'Cancel and Confirm buttons',
              icon: Icons.check_circle_outline,
              color: Colors.blue,
              onTap: () => _showAlert(
                title: 'Confirm Action',
                message: 'Are you sure you want to proceed with this action?',
                confirmLabel: 'Confirm',
                cancelLabel: 'Cancel',
                type: AppAlertType.info,
              ),
            ),
            _buildTriggerButton(
              title: 'Destructive Confirmation',
              subtitle: 'Cancel and Delete buttons (destructive styling)',
              icon: Icons.delete_outline,
              color: Colors.red,
              onTap: () => _showAlert(
                title: 'Delete Item?',
                message:
                    'Are you sure you want to delete this item? '
                    'This cannot be undone.',
                confirmLabel: 'Delete',
                cancelLabel: 'Cancel',
                type: AppAlertType.warning,
                isDestructive: true,
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

  Widget _buildTriggerButton({
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
