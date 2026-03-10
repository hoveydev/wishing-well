import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_error_card/app_error_card.dart';

class AppErrorCardDemo extends StatelessWidget {
  const AppErrorCardDemo({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Error Card Components'),
      backgroundColor: Colors.red.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Default with Retry
          _buildSection('Default (with retry)', [
            _buildErrorCard(
              'Error Loading Wishers',
              'Something went wrong while loading your wishers. '
                  'Please try again.',
            ),
          ]),

          // Without Retry Button
          _buildSection('Without retry button', [
            _buildErrorCard(
              'Error Loading Wishers',
              'Something went wrong while loading your wishers.',
              showRetry: false,
            ),
          ]),

          // Custom Icons
          _buildSection('Custom Icons', [
            _buildErrorCard(
              'Connection Failed',
              'Unable to connect to the server. '
                  'Check your internet connection.',
              icon: Icons.error,
            ),
            const SizedBox(height: 12),
            _buildErrorCard(
              'Slow Connection',
              'Your connection is slow. Some features may take '
                  'longer to load.',
              icon: Icons.warning_amber,
            ),
          ]),

          // Features
          _buildSection('Features', [
            _buildFeatureBullet('Retry button with 36x36 touch target'),
            _buildFeatureBullet('Customizable icon (refresh by default)'),
            _buildFeatureBullet('Configurable font sizes'),
            _buildFeatureBullet('Adjustable padding for different layouts'),
            _buildFeatureBullet('Compact, card-based design'),
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

  Widget _buildErrorCard(
    String title,
    String message, {
    bool showRetry = true,
    IconData icon = Icons.refresh,
  }) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: AppErrorCard(
        onRetry: showRetry ? () {} : null,
        title: title,
        message: message,
        retryText: 'retry',
        icon: icon,
      ),
    ),
  );

  Widget _buildFeatureBullet(String text) => Padding(
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
