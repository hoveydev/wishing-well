import 'package:flutter/material.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';

class SpacerDemo extends StatelessWidget {
  const SpacerDemo({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Spacer Components'),
      backgroundColor: Colors.grey.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // All Spacer Sizes
          _buildSection('Spacer Sizes', [
            _buildSpacerCard('XSmall (4px)', AppSpacerSize.xsmall, Colors.blue),
            _buildSpacerCard('Small (8px)', AppSpacerSize.small, Colors.green),
            _buildSpacerCard(
              'Medium (16px)',
              AppSpacerSize.medium,
              Colors.orange,
            ),
            _buildSpacerCard('Large (24px)', AppSpacerSize.large, Colors.red),
            _buildSpacerCard(
              'XLarge (48px)',
              AppSpacerSize.xlarge,
              Colors.purple,
            ),
          ]),

          // Features Section
          _buildSection('Spacer Features', [
            const FeatureBulletPoint(text: 'Consistent spacing across the app'),
            const FeatureBulletPoint(
              text: 'Predefined sizes for design consistency',
            ),
            const FeatureBulletPoint(text: 'Simple and easy to use'),
            const FeatureBulletPoint(
              text: 'Both vertical and horizontal spacing',
            ),
            const FeatureBulletPoint(text: 'Reduces magic numbers in code'),
          ]),

          // Visual Comparison
          _buildSection('Visual Comparison', [
            const Text(
              'Same elements with different spacers:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                        _buildColoredBox(Colors.blue),
                        const AppSpacer.xsmall(),
                        _buildColoredBox(Colors.green),
                      ],
                    ),
                    Row(
                      children: [
                        _buildColoredBox(Colors.orange),
                        const AppSpacer.small(),
                        _buildColoredBox(Colors.red),
                      ],
                    ),
                    Row(
                      children: [
                        _buildColoredBox(Colors.purple),
                        const AppSpacer.medium(),
                        _buildColoredBox(Colors.teal),
                      ],
                    ),
                    Row(
                      children: [
                        _buildColoredBox(Colors.cyan),
                        const AppSpacer.large(),
                        _buildColoredBox(Colors.indigo),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),

          // Vertical Spacing Example
          _buildSection('Vertical Spacing Example', [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Header 1'),
                    const AppSpacer.xsmall(),
                    _buildSectionContent('Content with xsmall spacer'),
                    const AppSpacer.small(),
                    _buildSectionContent('Content with small spacer'),
                    const AppSpacer.medium(),
                    _buildSectionContent('Content with medium spacer'),
                    const AppSpacer.large(),
                    _buildSectionContent('Content with large spacer'),
                  ],
                ),
              ),
            ),
          ]),

          // Use Cases
          _buildSection('Common Use Cases', [
            _buildUseCaseCard('Between form elements', 'AppSpacer.small()'),
            _buildUseCaseCard('Between sections', 'AppSpacer.medium()'),
            _buildUseCaseCard('Between major blocks', 'AppSpacer.large()'),
            _buildUseCaseCard('Tight spacing', 'AppSpacer.xsmall()'),
            _buildUseCaseCard('Major separation', 'AppSpacer.xlarge()'),
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

  Widget _buildSpacerCard(String label, double size, Color color) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildColoredBox(color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${size.toInt()} pixels',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.3),
              border: Border.all(color: color),
            ),
            child: Center(
              child: Text(
                size.toInt().toString(),
                style: TextStyle(
                  fontSize: size > 20 ? 14 : 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildColoredBox(Color color) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(4),
    ),
  );

  Widget _buildSectionHeader(String text) => Text(
    text,
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );

  Widget _buildSectionContent(String text) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(text),
  );

  Widget _buildUseCaseCard(String useCase, String code) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(child: Text(useCase, style: const TextStyle(fontSize: 16))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              code,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
            ),
          ),
        ],
      ),
    ),
  );
}

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
