import 'package:flutter/material.dart';
import 'package:wishing_well/components/logo/app_logo.dart';
import 'package:wishing_well/theme/app_spacer_size.dart';

class LogoDemo extends StatelessWidget {
  const LogoDemo({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Logo Components'),
      backgroundColor: Colors.pink.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacerSize.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Sizes
          _buildSection('Logo Sizes', [
            _buildLogoCard('XSmall (10px)', 10, Colors.blue),
            _buildLogoCard('Small (14px)', 14, Colors.green),
            _buildLogoCard('Medium (18px)', 18, Colors.orange),
            _buildLogoCard('Large (24px)', 24, Colors.red),
            _buildLogoCard('XLarge (60px)', 60, Colors.purple),
            _buildLogoCard('Default (80px)', 80, Colors.teal),
          ]),

          // Features Section
          _buildSection('Logo Features', [
            const FeatureBulletPoint(text: 'Customizable size parameter'),
            const FeatureBulletPoint(text: 'High-quality image rendering'),
            const FeatureBulletPoint(text: 'Maintains aspect ratio'),
            const FeatureBulletPoint(text: 'Easy to use with default size'),
            const FeatureBulletPoint(text: 'Consistent branding across app'),
          ]),

          // Visual Comparison
          _buildSection('Visual Size Comparison', [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacerSize.large),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        AppLogo(size: 20),
                        SizedBox(height: AppSpacerSize.small),
                        Text('20px'),
                      ],
                    ),
                    Column(
                      children: [
                        AppLogo(size: 40),
                        SizedBox(height: AppSpacerSize.small),
                        Text('40px'),
                      ],
                    ),
                    Column(
                      children: [
                        AppLogo(size: 60),
                        SizedBox(height: AppSpacerSize.small),
                        Text('60px'),
                      ],
                    ),
                    Column(
                      children: [
                        AppLogo(),
                        SizedBox(height: AppSpacerSize.small),
                        Text('80px'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),

          // Use Cases
          _buildSection('Common Use Cases', [
            _buildUseCaseCard('App bar icon', 'AppLogo(size: 20)', 20),
            _buildUseCaseCard('Navigation header', 'AppLogo(size: 40)', 40),
            _buildUseCaseCard('Section header', 'AppLogo(size: 60)', 60),
            _buildUseCaseCard('Landing page', 'AppLogo(size: 80)', 80),
            _buildUseCaseCard('Custom size', 'AppLogo(size: 100)', 100),
          ]),

          // Interactive Demo
          _buildSection('Interactive Demo', [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacerSize.large),
                child: Column(
                  children: [
                    const Text(
                      'Default Logo:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppSpacerSize.large),
                    const Center(child: AppLogo()),
                    const SizedBox(height: AppSpacerSize.large),
                    const Divider(),
                    const SizedBox(height: AppSpacerSize.large),
                    const Text(
                      'Logo with background:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppSpacerSize.large),
                    Container(
                      padding: const EdgeInsets.all(AppSpacerSize.xxlarge),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const AppLogo(),
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
      const SizedBox(height: AppSpacerSize.medium),
      ...children,
      const SizedBox(height: AppSpacerSize.xxlarge),
    ],
  );

  Widget _buildLogoCard(String label, double size, Color color) => Card(
    margin: const EdgeInsets.only(bottom: AppSpacerSize.medium),
    child: Padding(
      padding: const EdgeInsets.all(AppSpacerSize.large),
      child: Row(
        children: [
          Container(
            width: size + 20,
            height: size + 20,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: AppLogo(size: size),
          ),
          const SizedBox(width: AppSpacerSize.medium),
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
                const SizedBox(height: AppSpacerSize.xsmall),
                Text(
                  '${size.toInt()} pixels',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildUseCaseCard(String useCase, String code, double size) => Card(
    margin: const EdgeInsets.only(bottom: AppSpacerSize.small),
    child: Padding(
      padding: const EdgeInsets.all(AppSpacerSize.medium),
      child: Row(
        children: [
          AppLogo(size: size),
          const SizedBox(width: AppSpacerSize.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(useCase, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: AppSpacerSize.xsmall),
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
