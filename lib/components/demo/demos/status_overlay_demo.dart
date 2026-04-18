import 'package:flutter/material.dart' hide OverlayState;
import 'package:provider/provider.dart';
import 'package:wishing_well/components/status_overlay/status_overlay.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';

class StatusOverlayDemo extends StatelessWidget {
  const StatusOverlayDemo({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => StatusOverlayController(),
    child: const _StatusOverlayDemoContent(),
  );
}

class _StatusOverlayDemoContent extends StatelessWidget {
  const _StatusOverlayDemoContent();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<StatusOverlayController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Overlay'),
        backgroundColor: Colors.blue.withValues(alpha: 0.1),
      ),
      body: StatusOverlay(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Status Overlay Component',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'The StatusOverlay is a wrapper component that displays '
                'a full-screen overlay with loading, success, or error states. '
                'It wraps any child widget and shows an overlay based on the '
                'StatusOverlayController state.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),
              _buildSection('Current State', [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getStateColor(
                      controller.state,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _getStateColor(controller.state)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getStateIcon(controller.state),
                        color: _getStateColor(controller.state),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _getStateText(controller.state),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getStateColor(controller.state),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 24),
              _buildSection('Trigger States', [
                const Text(
                  'Use these buttons to trigger different overlay states. '
                  'The overlay will appear over this content.',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 16),
                _DemoButton(
                  label: 'Show Loading',
                  onPressed: () => controller.show(),
                ),
                const SizedBox(height: 12),
                _DemoButton(
                  label: 'Show Success',
                  onPressed: () => controller.showSuccess(
                    'Operation completed successfully!',
                    name: 'John',
                  ),
                ),
                const SizedBox(height: 12),
                _DemoButton(
                  label: 'Show Error',
                  onPressed: () => controller.showError(
                    'Something went wrong. Please try again.',
                  ),
                ),
                const SizedBox(height: 12),
                _DemoButton(
                  label: 'Show Warning',
                  onPressed: () => controller.showWarning(
                    'A duplicate was found. Continue anyway?',
                    primaryActionLabel: 'Continue',
                    secondaryActionLabel: 'Cancel',
                  ),
                ),
                const SizedBox(height: 12),
                _DemoButton(
                  label: 'Hide Overlay',
                  onPressed: () => controller.hide(),
                ),
              ]),
              const SizedBox(height: 24),
              _buildSection('With Callbacks', [
                const Text(
                  'You can provide callbacks that fire when the user '
                  'acknowledges success or error states.',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 16),
                _DemoButton(
                  label: 'Success with Callback',
                  onPressed: () => controller.showSuccess(
                    'Data saved successfully!',
                    name: 'Jane',
                    onOk: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User acknowledged the success!'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                _DemoButton(
                  label: 'Error with Callback',
                  onPressed: () => controller.showError(
                    'Failed to connect to server.',
                    onOk: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User acknowledged the error!'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                _DemoButton(
                  label: 'Warning with Callbacks',
                  onPressed: () => controller.showWarning(
                    'This action may create duplicates. Continue?',
                    primaryActionLabel: 'Continue',
                    secondaryActionLabel: 'Cancel',
                    onPrimaryAction: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User chose to continue!'),
                        ),
                      );
                    },
                    onSecondaryAction: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User cancelled the warning.'),
                        ),
                      );
                    },
                  ),
                ),
              ]),
              const SizedBox(height: 24),
              _buildSection('Sample Content', [
                const Text(
                  'This is sample content that appears beneath the overlay. '
                  'When the overlay is visible, it will be covered and '
                  'user interaction with this content will be disabled.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(child: Icon(Icons.person)),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Sample Item',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'This is some description text',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing '
                          'elit. Sed do eiusmod tempor incididunt ut labore et '
                          'dolore magna aliqua.',
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      ...children,
      const SizedBox(height: 16),
    ],
  );

  Color _getStateColor(OverlayState state) {
    switch (state) {
      case OverlayState.idle:
        return Colors.grey;
      case OverlayState.loading:
        return Colors.blue;
      case OverlayState.success:
        return Colors.green;
      case OverlayState.error:
        return Colors.red;
      case OverlayState.warning:
        return Colors.orange;
    }
  }

  IconData _getStateIcon(OverlayState state) {
    switch (state) {
      case OverlayState.idle:
        return Icons.visibility_off;
      case OverlayState.loading:
        return Icons.hourglass_empty;
      case OverlayState.success:
        return Icons.check_circle;
      case OverlayState.error:
        return Icons.error;
      case OverlayState.warning:
        return Icons.warning_amber_outlined;
    }
  }

  String _getStateText(OverlayState state) {
    switch (state) {
      case OverlayState.idle:
        return 'No overlay visible';
      case OverlayState.loading:
        return 'Loading...';
      case OverlayState.success:
        return 'Success shown';
      case OverlayState.error:
        return 'Error shown';
      case OverlayState.warning:
        return 'Warning shown';
    }
  }
}

class _DemoButton extends StatelessWidget {
  const _DemoButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(onPressed: onPressed, child: Text(label)),
  );
}
