import 'package:flutter/material.dart';
import 'package:wishing_well/components/demo/demos/button_demo.dart';
import 'package:wishing_well/components/demo/demos/input_demo.dart';
import 'package:wishing_well/components/demo/demos/wishers_demo.dart';
import 'package:wishing_well/components/demo/demos/checklist_demo.dart';
import 'package:wishing_well/components/demo/demos/inline_alert_demo.dart';
import 'package:wishing_well/components/demo/demos/spacer_demo.dart';
import 'package:wishing_well/components/demo/demos/throbber_demo.dart';
import 'package:wishing_well/components/demo/demos/app_bar_demo.dart';
import 'package:wishing_well/components/demo/demos/logo_demo.dart';
import 'package:wishing_well/components/demo/demos/screen_demo.dart';
import 'package:wishing_well/components/demo/demos/touch_feedback_demo.dart';

class DemoHome extends StatelessWidget {
  const DemoHome({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Component Demo App'),
      backgroundColor: Colors.red.withValues(alpha: 0.1),
      actions: [
        Icon(Icons.developer_mode, color: Colors.red[700]),
        const SizedBox(width: 8),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          '🚨 DEVELOPER DEMO ONLY 🚨',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'This app is for component testing and development only.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        // Component Categories
        _buildCategory(context, 'Buttons', Icons.touch_app, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ButtonDemo()),
          );
        }),

        _buildCategory(context, 'Inputs', Icons.text_fields, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const InputDemo()),
          );
        }),

        _buildCategory(context, 'Wishers', Icons.people, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WishersDemo()),
          );
        }),

        _buildCategory(context, 'Checklist', Icons.checklist, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChecklistDemo()),
          );
        }),

        _buildCategory(context, 'Inline Alerts', Icons.info_outline, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const InlineAlertDemo()),
          );
        }),

        _buildCategory(context, 'Spacers', Icons.space_bar, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SpacerDemo()),
          );
        }),

        _buildCategory(context, 'Throbbers', Icons.hourglass_empty, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ThrobberDemo()),
          );
        }),

        _buildCategory(context, 'App Bar', Icons.menu, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AppBarDemo()),
          );
        }),

        _buildCategory(context, 'Logo', Icons.image, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LogoDemo()),
          );
        }),

        _buildCategory(context, 'Screen', Icons.phone_android, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ScreenDemo()),
          );
        }),

        _buildCategory(context, 'Touch Feedback', Icons.pan_tool, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TouchFeedbackDemo()),
          );
        }),
      ],
    ),
  );
}

Widget _buildCategory(
  BuildContext context,
  String title,
  IconData icon,
  VoidCallback onTap,
) => Card(
  margin: const EdgeInsets.only(bottom: 8),
  child: ListTile(
    leading: Icon(icon, size: 32),
    title: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    ),
    trailing: const Icon(Icons.arrow_forward_ios),
    onTap: onTap,
  ),
);
