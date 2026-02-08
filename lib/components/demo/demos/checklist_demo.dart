import 'package:flutter/material.dart';
import 'package:wishing_well/components/checklist/checklist_item.dart';

class ChecklistDemo extends StatefulWidget {
  const ChecklistDemo({super.key});

  @override
  State<ChecklistDemo> createState() => _ChecklistDemoState();
}

class _ChecklistDemoState extends State<ChecklistDemo> {
  bool _minLength = false;
  bool _uppercase = false;
  bool _lowercase = false;
  bool _number = false;
  bool _specialChar = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Checklist Components'),
      backgroundColor: Colors.teal.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Static Examples
          _buildSection('Static Examples', [
            const Text(
              'Satisfied items:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const ChecklistItem(
              label: 'At least 12 characters',
              isSatisfied: true,
            ),
            const SizedBox(height: 8),
            const ChecklistItem(
              label: 'One uppercase letter',
              isSatisfied: true,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unsatisfied items:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const ChecklistItem(
              label: 'One lowercase letter',
              isSatisfied: false,
            ),
            const SizedBox(height: 8),
            const ChecklistItem(label: 'One number', isSatisfied: false),
          ]),

          // Interactive Example
          _buildSection('Interactive Password Requirements', [
            const Text(
              'Toggle the requirements below to see different states:',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Password must include:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ChecklistItem(
                      label: 'At least 12 characters',
                      isSatisfied: _minLength,
                    ),
                    const SizedBox(height: 8),
                    ChecklistItem(
                      label: 'One uppercase letter',
                      isSatisfied: _uppercase,
                    ),
                    const SizedBox(height: 8),
                    ChecklistItem(
                      label: 'One lowercase letter',
                      isSatisfied: _lowercase,
                    ),
                    const SizedBox(height: 8),
                    ChecklistItem(label: 'One number', isSatisfied: _number),
                    const SizedBox(height: 8),
                    ChecklistItem(
                      label: 'One special character',
                      isSatisfied: _specialChar,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Toggle switches to change states:'),
            const SizedBox(height: 8),
            _buildToggle(
              'Min Length (12+)',
              _minLength,
              (val) => setState(() => _minLength = val),
            ),
            _buildToggle(
              'Uppercase',
              _uppercase,
              (val) => setState(() => _uppercase = val),
            ),
            _buildToggle(
              'Lowercase',
              _lowercase,
              (val) => setState(() => _lowercase = val),
            ),
            _buildToggle(
              'Number',
              _number,
              (val) => setState(() => _number = val),
            ),
            _buildToggle(
              'Special Char',
              _specialChar,
              (val) => setState(() => _specialChar = val),
            ),
          ]),

          // Features Section
          _buildSection('Checklist Features', [
            const FeatureBulletPoint(
              text:
                  'Visual distinction between satisfied and unsatisfied items',
            ),
            const FeatureBulletPoint(text: 'Checkmark icon when satisfied'),
            const FeatureBulletPoint(
              text: 'Color-coded backgrounds and borders',
            ),
            const FeatureBulletPoint(
              text: 'Font weight changes based on state',
            ),
            const FeatureBulletPoint(
              text: 'Accessibility labels for screen readers',
            ),
          ]),

          // All States Example
          _buildSection('All States Comparison', [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'Unsatisfied',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        ChecklistItem(label: 'Not yet met', isSatisfied: false),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'Satisfied',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        ChecklistItem(
                          label: 'Requirement met',
                          isSatisfied: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ],
      ),
    ),
  );
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

Widget _buildToggle(String label, bool value, Function(bool) onChanged) => Row(
  children: [
    Expanded(child: Text(label)),
    Switch(value: value, onChanged: onChanged),
  ],
);

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
