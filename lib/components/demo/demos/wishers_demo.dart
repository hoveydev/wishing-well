import 'package:flutter/material.dart';
import 'package:wishing_well/components/wishers/wishers_list.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/utils/app_logger.dart';
import 'package:wishing_well/theme/app_spacer_size.dart';

class WishersDemo extends StatelessWidget {
  const WishersDemo({super.key});

  // Sample wishers for demo
  static final List<Wisher> _demoWishers = [
    Wisher(
      id: '1',
      userId: 'demo-user',
      firstName: 'Alice',
      lastName: 'Johnson',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Wisher(
      id: '2',
      userId: 'demo-user',
      firstName: 'Bob',
      lastName: 'Smith',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Wisher(
      id: '3',
      userId: 'demo-user',
      firstName: 'Charlie',
      lastName: 'Brown',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Wisher(
      id: '4',
      userId: 'demo-user',
      firstName: 'Diana',
      lastName: 'Ross',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Wishers Components'),
      backgroundColor: Colors.green.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacerSize.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wishers List Section
          _buildSection('Wishers List', [
            Container(
              padding: const EdgeInsets.all(AppSpacerSize.large),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              child: WishersList(
                wishers: _demoWishers,
                onAddWisherTap: _handleAddWisher,
                onWisherTap: (wisher) => _handleWisherTap(wisher),
              ),
            ),
          ]),

          // Features Section
          _buildSection('Wishers Features', [
            const FeatureBulletPoint(
              text: 'Horizontal scrolling list of wishers',
            ),
            const FeatureBulletPoint(
              text: 'Add new wisher button with dotted border',
            ),
            const FeatureBulletPoint(
              text: 'Touch feedback on all interactive elements',
            ),
            const FeatureBulletPoint(text: 'Circle avatars with initials'),
            const FeatureBulletPoint(
              text: 'View All and Add navigation options',
            ),
          ]),

          // Individual Components
          _buildSection('Individual Components', [
            const Text(
              'Add Wisher Item:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: AppSpacerSize.small),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Add Wisher Item\n(See full list above)',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacerSize.large),
            const Text(
              'Wisher Item:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: AppSpacerSize.small),
            _buildWisherItemExample(_demoWishers.first),
          ]),

          // Interactive Example
          _buildSection('Interactive Example', [
            const Text(
              'Tap on any wisher or the Add button to see interactions:',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: AppSpacerSize.large),
            Container(
              padding: const EdgeInsets.all(AppSpacerSize.large),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              child: WishersList(
                wishers: _demoWishers,
                onAddWisherTap: _handleAddWisher,
                onWisherTap: (wisher) => _handleWisherTap(wisher),
              ),
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
      const SizedBox(height: AppSpacerSize.medium),
      ...children,
      const SizedBox(height: AppSpacerSize.xxlarge),
    ],
  );

  Widget _buildWisherItemExample(Wisher wisher) => Container(
    padding: const EdgeInsets.all(AppSpacerSize.medium),
    decoration: BoxDecoration(
      color: Colors.grey.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue,
          child: Text(
            wisher.initial,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        const SizedBox(width: AppSpacerSize.medium),
        Text(wisher.firstName, style: const TextStyle(fontSize: 16)),
      ],
    ),
  );
}

void _handleAddWisher() {
  AppLogger.debug('Add Wisher tapped!', context: 'WishersDemo');
}

void _handleWisherTap(Wisher wisher) {
  AppLogger.debug('Wisher tapped: ${wisher.name}', context: 'WishersDemo');
}

class FeatureBulletPoint extends StatelessWidget {
  const FeatureBulletPoint({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacerSize.xsmall),
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
