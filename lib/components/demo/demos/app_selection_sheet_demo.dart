import 'package:flutter/material.dart';
import 'package:wishing_well/components/demo/demos/input_demo.dart';
import 'package:wishing_well/components/sheet/app_selection_sheet.dart';

class AppSelectionSheetDemo extends StatefulWidget {
  const AppSelectionSheetDemo({super.key});

  @override
  State<AppSelectionSheetDemo> createState() => _AppSelectionSheetDemoState();
}

class _AppSelectionSheetDemoState extends State<AppSelectionSheetDemo> {
  String? _lastDismissed;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Selection Sheet'),
      backgroundColor: Colors.teal.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('AppSheetHeader', [
            const Text(
              'The standard header used at the top of every selection '
              'sheet:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Card(child: AppSheetHeader(title: 'Example Sheet Title')),
          ]),
          _buildSection('AppSelectionSheet.show()', [
            const FeatureBulletPoint(
              text: 'Consistent background color from AppColorScheme',
            ),
            const FeatureBulletPoint(text: 'Rounded top corners (radius 16)'),
            const FeatureBulletPoint(
              text: 'Supports scrollable (isScrollControlled) sheets',
            ),
            const FeatureBulletPoint(
              text: 'Used by ImageSourceMenu and MultiSelectSheet',
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _openSampleSheet(context),
                child: const Text('Open Sample Sheet'),
              ),
            ),
            if (_lastDismissed != null) ...[
              const SizedBox(height: 8),
              Text(
                'Last dismissed: $_lastDismissed',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ]),
        ],
      ),
    ),
  );

  Future<void> _openSampleSheet(BuildContext context) async {
    final result = await AppSelectionSheet.show<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppSheetHeader(title: 'Sample Sheet'),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'This sheet uses AppSheetHeader for its header and '
                'AppSelectionSheet.show() for consistent modal styling.',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.of(context).pop('dismissed via button'),
                  child: const Text('Close'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    setState(() => _lastDismissed = result ?? 'swiped away');
  }

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
