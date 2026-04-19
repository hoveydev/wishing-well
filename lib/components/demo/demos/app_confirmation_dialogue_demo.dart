import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_confirmation_dialogue/app_confirmation_dialogue.dart';

class AppConfirmationDialogueDemo extends StatefulWidget {
  const AppConfirmationDialogueDemo({super.key});

  @override
  State<AppConfirmationDialogueDemo> createState() =>
      _AppConfirmationDialogueDemoState();
}

class _AppConfirmationDialogueDemoState
    extends State<AppConfirmationDialogueDemo> {
  void _showDialogue({required bool isDestructive}) async {
    final result = await AppConfirmationDialogue.show(
      context: context,
      title: isDestructive ? 'Delete Item?' : 'Confirm Action',
      message: isDestructive
          ? 'Are you sure you want to delete this item? This cannot be undone.'
          : 'Are you sure you want to proceed with this action?',
      confirmLabel: isDestructive ? 'Delete' : 'Confirm',
      cancelLabel: 'Cancel',
      isDestructive: isDestructive,
    );

    if (!mounted) return;

    final outcome = switch (result) {
      true => 'Confirmed',
      false => 'Cancelled',
      _ => 'Dismissed',
    };

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Result: $outcome')));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Confirmation Dialogue'),
      backgroundColor: Colors.purple.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('Standard Confirmation', [
            _buildTriggerButton(
              title: 'Standard Dialogue',
              subtitle: 'Cancel and Confirm actions',
              icon: Icons.check_circle_outline,
              color: Colors.blue,
              onTap: () => _showDialogue(isDestructive: false),
            ),
          ]),
          _buildSection('Destructive Confirmation', [
            _buildTriggerButton(
              title: 'Destructive Dialogue',
              subtitle: 'Cancel and Delete actions (destructive styling)',
              icon: Icons.delete_outline,
              color: Colors.red,
              onTap: () => _showDialogue(isDestructive: true),
            ),
          ]),
          _buildSection('Features', [
            const _FeatureBulletPoint(
              text: 'App-styled AlertDialog with surfaceGray background',
            ),
            const _FeatureBulletPoint(
              text:
                  'Cancel (secondary) and Confirm (primary) '
                  'AppButton actions',
            ),
            const _FeatureBulletPoint(
              text:
                  'Destructive mode renders confirm button in error/red colour',
            ),
            const _FeatureBulletPoint(
              text: 'Static show() returns Future<bool?> for easy async use',
            ),
            const _FeatureBulletPoint(
              text: 'Accessible with semantic labels and live regions',
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

class _FeatureBulletPoint extends StatelessWidget {
  const _FeatureBulletPoint({required this.text});

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
