import 'package:flutter/material.dart';
import 'package:wishing_well/components/demo/demos/input_demo.dart';
import 'package:wishing_well/components/multi_select/app_multi_select_field.dart';

const _holidayItems = [
  AppMultiSelectItem(value: 'christmas', label: 'Christmas'),
  AppMultiSelectItem(value: 'hanukkah', label: 'Hanukkah'),
  AppMultiSelectItem(value: 'kwanzaa', label: 'Kwanzaa'),
  AppMultiSelectItem(value: 'diwali', label: 'Diwali'),
  AppMultiSelectItem(value: 'eid', label: 'Eid'),
  AppMultiSelectItem(value: 'valentines_day', label: "Valentine's Day"),
  AppMultiSelectItem(value: 'mothers_day', label: "Mother's Day"),
  AppMultiSelectItem(value: 'fathers_day', label: "Father's Day"),
  AppMultiSelectItem(value: 'easter', label: 'Easter'),
  AppMultiSelectItem(value: 'new_years', label: "New Year's"),
];

const _interestItems = [
  AppMultiSelectItem(value: 'books', label: 'Books'),
  AppMultiSelectItem(value: 'electronics', label: 'Electronics'),
  AppMultiSelectItem(value: 'clothing', label: 'Clothing'),
  AppMultiSelectItem(value: 'jewelry', label: 'Jewelry'),
  AppMultiSelectItem(value: 'art', label: 'Art'),
  AppMultiSelectItem(value: 'home_and_garden', label: 'Home & Garden'),
  AppMultiSelectItem(value: 'sports', label: 'Sports'),
  AppMultiSelectItem(value: 'beauty', label: 'Beauty'),
  AppMultiSelectItem(value: 'food_and_drink', label: 'Food & Drink'),
  AppMultiSelectItem(value: 'travel', label: 'Travel'),
  AppMultiSelectItem(value: 'games_and_toys', label: 'Games & Toys'),
];

class AppMultiSelectFieldDemo extends StatefulWidget {
  const AppMultiSelectFieldDemo({super.key});

  @override
  State<AppMultiSelectFieldDemo> createState() =>
      _AppMultiSelectFieldDemoState();
}

class _AppMultiSelectFieldDemoState extends State<AppMultiSelectFieldDemo> {
  List<String> _occasions = [];
  List<String> _interests = [];
  List<String> _fruits = [];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Multi-Select Field'),
      backgroundColor: Colors.green.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('Gift Occasions', [
            AppMultiSelectField(
              title: 'Gift Occasions',
              placeholder: 'Select gift occasions',
              items: _holidayItems,
              selectedValues: _occasions,
              onChanged: (values) => setState(() => _occasions = values),
            ),
            const SizedBox(height: 8),
            Text(
              _occasions.isEmpty
                  ? 'None selected'
                  : 'Selected: ${_occasions.join(', ')}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ]),
          _buildSection('Gift Interests', [
            AppMultiSelectField(
              title: 'Gift Interests',
              placeholder: 'Select gift interests',
              items: _interestItems,
              selectedValues: _interests,
              onChanged: (values) => setState(() => _interests = values),
            ),
            const SizedBox(height: 8),
            Text(
              _interests.isEmpty
                  ? 'None selected'
                  : 'Selected: ${_interests.join(', ')}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ]),
          _buildSection('Small List', [
            AppMultiSelectField(
              title: 'Favourite Fruits',
              placeholder: 'Pick your favourites',
              items: const [
                AppMultiSelectItem(value: 'apple', label: 'Apple'),
                AppMultiSelectItem(value: 'banana', label: 'Banana'),
                AppMultiSelectItem(value: 'mango', label: 'Mango'),
                AppMultiSelectItem(value: 'strawberry', label: 'Strawberry'),
              ],
              selectedValues: _fruits,
              onChanged: (values) => setState(() => _fruits = values),
            ),
          ]),
          _buildSection('Features', [
            const FeatureBulletPoint(
              text:
                  'Tappable row opens a draggable bottom sheet with '
                  'checkboxes',
            ),
            const FeatureBulletPoint(
              text: 'Selected items shown as deletable chips below the field',
            ),
            const FeatureBulletPoint(
              text: 'Bottom sheet has a "Done" button to confirm selection',
            ),
            const FeatureBulletPoint(
              text:
                  'Chips can be individually removed without reopening '
                  'the sheet',
            ),
            const FeatureBulletPoint(
              text: 'Callback-based: onChanged(List<String>)',
            ),
            const FeatureBulletPoint(
              text: 'Works with any list of AppMultiSelectItem',
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
