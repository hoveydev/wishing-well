import 'package:flutter/material.dart';
import 'package:wishing_well/components/demo/demos/input_demo.dart';
import 'package:wishing_well/components/multi_select/app_multi_select_field.dart';
import 'package:wishing_well/components/multi_select/multi_select_sheet.dart';
import 'package:wishing_well/components/sheet/app_selection_sheet.dart';

const _sampleItems = [
  AppMultiSelectItem(value: 'books', label: 'Books'),
  AppMultiSelectItem(value: 'electronics', label: 'Electronics'),
  AppMultiSelectItem(value: 'clothing', label: 'Clothing'),
  AppMultiSelectItem(value: 'art', label: 'Art'),
];

class AppSelectionSheetDemo extends StatefulWidget {
  const AppSelectionSheetDemo({super.key});

  @override
  State<AppSelectionSheetDemo> createState() => _AppSelectionSheetDemoState();
}

class _AppSelectionSheetDemoState extends State<AppSelectionSheetDemo> {
  String? _lastDismissed;
  List<String> _selectedCategories = [];

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
          _buildSection('MultiSelectSheet (built on AppSelectionSheet)', [
            const FeatureBulletPoint(
              text:
                  'MultiSelectSheet.show() delegates to '
                  'AppSelectionSheet.show() for consistent styling',
            ),
            const FeatureBulletPoint(
              text: 'DraggableScrollableSheet with ChecklistIcon rows',
            ),
            const FeatureBulletPoint(
              text: 'Done button returns the confirmed selection',
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _openMultiSelectSheet(context),
                child: const Text('Open MultiSelectSheet'),
              ),
            ),
            if (_selectedCategories.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Selected: ${_selectedCategories.join(', ')}',
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

  Future<void> _openMultiSelectSheet(BuildContext context) async {
    final result = await MultiSelectSheet.show(
      context: context,
      items: _sampleItems,
      selectedValues: _selectedCategories,
      title: 'Gift Categories',
    );
    if (!mounted) return;
    if (result != null) {
      setState(() => _selectedCategories = result);
    }
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
