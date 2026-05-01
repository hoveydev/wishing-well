import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wishing_well/components/date_picker/app_date_picker_field.dart';

class AppDatePickerFieldDemo extends StatefulWidget {
  const AppDatePickerFieldDemo({super.key});

  @override
  State<AppDatePickerFieldDemo> createState() => _AppDatePickerFieldDemoState();
}

class _AppDatePickerFieldDemoState extends State<AppDatePickerFieldDemo> {
  DateTime? _birthday;
  DateTime? _eventDate;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Date Picker Field'),
      backgroundColor: Colors.blue.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('Birthday', [
            AppDatePickerField(
              placeholder: 'Add birthday',
              value: _birthday,
              onChanged: (date) => setState(() => _birthday = date),
            ),
            const SizedBox(height: 8),
            Text(
              _birthday != null
                  ? 'Selected: ${DateFormat.yMMMMd().format(_birthday!)}'
                  : 'No date selected',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ]),
          _buildSection('Custom Date Range', [
            AppDatePickerField(
              placeholder: 'Select an event date',
              value: _eventDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(DateTime.now().year + 5),
              onChanged: (date) => setState(() => _eventDate = date),
            ),
            const SizedBox(height: 8),
            Text(
              _eventDate != null
                  ? 'Selected: ${DateFormat.yMMMMd().format(_eventDate!)}'
                  : 'Range: today → 5 years out',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ]),
          _buildSection('Features', [
            const _FeatureBulletPoint(
              text: 'Tappable row opens a custom bottom-sheet date picker',
            ),
            const _FeatureBulletPoint(
              text:
                  'Calendar icon on the left, clear (×) button when a date '
                  'is set',
            ),
            const _FeatureBulletPoint(
              text: 'Accepts optional firstDate / lastDate to constrain range',
            ),
            const _FeatureBulletPoint(
              text: 'Defaults to 1900–today (suitable for birthdays)',
            ),
            const _FeatureBulletPoint(
              text: 'Callback-based: onChanged(DateTime?) with null to clear',
            ),
            const _FeatureBulletPoint(
              text: 'Accessibility: Semantics label reflects current value',
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
