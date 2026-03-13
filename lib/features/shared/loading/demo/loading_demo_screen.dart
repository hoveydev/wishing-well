import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/utils/loading_controller.dart';

class LoadingDemoScreen extends StatelessWidget {
  const LoadingDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.loading)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Loading Controller Demo',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 48),
            _DemoButton(
              label: 'Show Loading',
              onPressed: () {
                context.read<LoadingController>().show();
              },
            ),
            const SizedBox(height: 16),
            _DemoButton(
              label: 'Show Success',
              onPressed: () {
                context.read<LoadingController>().showSuccess(
                  'Wisher created successfully!',
                  onOk: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Success acknowledged')),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            _DemoButton(
              label: 'Show Error',
              onPressed: () {
                context.read<LoadingController>().showError(
                  'Something went wrong. Please try again.',
                  onOk: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error acknowledged')),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            _DemoButton(
              label: 'Show Success (No Callback)',
              onPressed: () {
                context.read<LoadingController>().showSuccess(
                  'Operation completed!',
                );
              },
            ),
            const SizedBox(height: 16),
            _DemoButton(
              label: 'Show Error (No Callback)',
              onPressed: () {
                context.read<LoadingController>().showError(
                  'An error occurred.',
                );
              },
            ),
            const SizedBox(height: 16),
            _DemoButton(
              label: 'Hide Overlay',
              onPressed: () {
                context.read<LoadingController>().hide();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoButton extends StatelessWidget {
  const _DemoButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) =>
      ElevatedButton(onPressed: onPressed, child: Text(label));
}
