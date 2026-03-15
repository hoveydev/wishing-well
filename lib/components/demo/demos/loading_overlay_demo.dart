import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/loading_overlay/loading_overlay.dart';
import 'package:wishing_well/utils/loading_controller.dart';

class LoadingOverlayDemo extends StatelessWidget {
  const LoadingOverlayDemo({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => LoadingController(),
    child: const _LoadingOverlayDemoContent(),
  );
}

class _LoadingOverlayDemoContent extends StatelessWidget {
  const _LoadingOverlayDemoContent();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LoadingController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading Overlay'),
        backgroundColor: Colors.blue.withValues(alpha: 0.1),
      ),
      body: LoadingOverlay(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Loading Overlay Component',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'The LoadingOverlay is a wrapper component that displays '
                'a full-screen overlay with loading, success, or error states. '
                'It wraps any child widget and shows an overlay based on the '
                'LoadingController state.',
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

  Color _getStateColor(LoadingState state) {
    switch (state) {
      case LoadingState.idle:
        return Colors.grey;
      case LoadingState.loading:
        return Colors.blue;
      case LoadingState.success:
        return Colors.green;
      case LoadingState.error:
        return Colors.red;
    }
  }

  IconData _getStateIcon(LoadingState state) {
    switch (state) {
      case LoadingState.idle:
        return Icons.visibility_off;
      case LoadingState.loading:
        return Icons.hourglass_empty;
      case LoadingState.success:
        return Icons.check_circle;
      case LoadingState.error:
        return Icons.error;
    }
  }

  String _getStateText(LoadingState state) {
    switch (state) {
      case LoadingState.idle:
        return 'No overlay visible';
      case LoadingState.loading:
        return 'Loading...';
      case LoadingState.success:
        return 'Success shown';
      case LoadingState.error:
        return 'Error shown';
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
