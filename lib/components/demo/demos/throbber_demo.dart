import 'package:flutter/material.dart';
import 'package:wishing_well/components/throbber/app_throbber.dart';
import 'package:wishing_well/components/throbber/app_throbber_size.dart';

class ThrobberDemo extends StatelessWidget {
  const ThrobberDemo({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Throbber Components'),
      backgroundColor: Colors.indigo.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // All Throbber Sizes
          _buildSection('Throbber Sizes', [
            _buildThrobberCard(
              'XSmall (4px)',
              AppThrobberSize.xsmall,
              Colors.blue,
            ),
            _buildThrobberCard(
              'Small (8px)',
              AppThrobberSize.small,
              Colors.green,
            ),
            _buildThrobberCard(
              'Medium (16px)',
              AppThrobberSize.medium,
              Colors.orange,
            ),
            _buildThrobberCard(
              'Large (24px)',
              AppThrobberSize.large,
              Colors.red,
            ),
            _buildThrobberCard(
              'XLarge (48px)',
              AppThrobberSize.xlarge,
              Colors.purple,
            ),
          ]),

          // Features Section
          _buildSection('Throbber Features', [
            const FeatureBulletPoint(text: 'Smooth, continuous animation'),
            const FeatureBulletPoint(
              text: 'Customizable sizes for different contexts',
            ),
            const FeatureBulletPoint(text: 'Uses theme colors automatically'),
            const FeatureBulletPoint(text: 'Lightweight custom painting'),
            const FeatureBulletPoint(
              text: 'Accessibility-friendly loading indicator',
            ),
          ]),

          // Visual Comparison
          _buildSection('Visual Size Comparison', [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        AppThrobber.xsmall(),
                        SizedBox(height: 8),
                        Text('XS'),
                      ],
                    ),
                    Column(
                      children: [
                        AppThrobber.small(),
                        SizedBox(height: 8),
                        Text('S'),
                      ],
                    ),
                    Column(
                      children: [
                        AppThrobber.medium(),
                        SizedBox(height: 8),
                        Text('M'),
                      ],
                    ),
                    Column(
                      children: [
                        AppThrobber.large(),
                        SizedBox(height: 8),
                        Text('L'),
                      ],
                    ),
                    Column(
                      children: [
                        AppThrobber.xlarge(),
                        SizedBox(height: 8),
                        Text('XL'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),

          // Use Cases
          _buildSection('Common Use Cases', [
            _buildUseCaseCard(
              'Inline loading (button text)',
              'AppThrobber.small()',
              const AppThrobber.small(),
            ),
            _buildUseCaseCard(
              'Form input loading',
              'AppThrobber.medium()',
              const AppThrobber.medium(),
            ),
            _buildUseCaseCard(
              'Section loading',
              'AppThrobber.large()',
              const AppThrobber.large(),
            ),
            _buildUseCaseCard(
              'Full page loading',
              'AppThrobber.xlarge()',
              const AppThrobber.xlarge(),
            ),
          ]),

          // Animated Demo
          _buildSection('Animated Demo', [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'All throbbers animating simultaneously:',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AppThrobber.xsmall(),
                        AppThrobber.small(),
                        AppThrobber.medium(),
                        AppThrobber.large(),
                      ],
                    ),
                    SizedBox(height: 16),
                    Center(child: AppThrobber.xlarge()),
                  ],
                ),
              ),
            ),
          ]),

          // Button with Throbber
          _buildSection('Button Integration', [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const AppThrobber.small(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Loading...',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Button with inline throbber',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
      const SizedBox(height: 12),
      ...children,
      const SizedBox(height: 24),
    ],
  );

  Widget _buildThrobberCard(String label, double size, Color color) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: size + 20,
            height: size + 20,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: AppThrobber.medium()),
          ),
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
                  '${size.toInt()} pixels diameter',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildUseCaseCard(String useCase, String code, Widget throbber) =>
      Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              throbber,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(useCase, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                      code,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
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
