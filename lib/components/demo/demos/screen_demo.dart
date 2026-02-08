import 'package:flutter/material.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';

class ScreenDemo extends StatelessWidget {
  const ScreenDemo({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Screen Components'),
      backgroundColor: Colors.cyan.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Features Section
          _buildSection('Screen Features', [
            const FeatureBulletPoint(text: 'Automatic safe area handling'),
            const FeatureBulletPoint(text: 'Built-in scrollable content'),
            const FeatureBulletPoint(text: 'Optional app bar integration'),
            const FeatureBulletPoint(text: 'Customizable padding'),
            const FeatureBulletPoint(text: 'Flexible layout control'),
          ]),

          // Basic Screen
          _buildSection('Basic Screen', [
            const Text(
              'A simple screen with content:',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(
                  height: 150,
                  child: Screen(
                    children: [
                      Text(
                        'Basic Screen',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This is a basic screen component with '
                        'default padding and layout.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),

          // Screen with App Bar
          _buildSection('Screen with App Bar', [
            const Text(
              'Click button to see full screen:',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            AppButton.label(
              label: 'Open Screen with App Bar',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => _FullAppBarScreen()),
                );
              },
              type: AppButtonType.primary,
            ),
          ]),

          // Different Layouts
          _buildSection('Layout Variations', [
            _buildLayoutCard(
              'Centered Content',
              MainAxisAlignment.center,
              CrossAxisAlignment.center,
              Colors.blue,
            ),
            _buildLayoutCard(
              'Start Content',
              MainAxisAlignment.start,
              CrossAxisAlignment.start,
              Colors.green,
            ),
            _buildLayoutCard(
              'End Content',
              MainAxisAlignment.end,
              CrossAxisAlignment.end,
              Colors.orange,
            ),
          ]),

          // Custom Padding
          _buildSection('Custom Padding', [
            const Text(
              'Screen with reduced padding:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(
                  height: 120,
                  child: Screen(
                    padding: EdgeInsets.all(8),
                    children: [
                      Text(
                        'Reduced Padding',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('This screen has reduced padding.'),
                    ],
                  ),
                ),
              ),
            ),
          ]),

          // Use Cases
          _buildSection('Common Use Cases', [
            _buildUseCaseCard('Form screens'),
            _buildUseCaseCard('List views'),
            _buildUseCaseCard('Detail pages'),
            _buildUseCaseCard('Settings screens'),
            _buildUseCaseCard('Profile pages'),
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

  Widget _buildLayoutCard(
    String label,
    MainAxisAlignment mainAxis,
    CrossAxisAlignment crossAxis,
    Color color,
  ) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 120,
        child: Screen(
          mainAxisAlignment: mainAxis,
          crossAxisAlignment: crossAxis,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildUseCaseCard(String useCase) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(useCase, style: const TextStyle(fontSize: 16))),
        ],
      ),
    ),
  );
}

class _FullAppBarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Screen(
    appBar: AppMenuBar(
      type: AppMenuBarType.close,
      action: () => Navigator.pop(context),
    ),
    children: const [
      Text(
        'Full Screen with App Bar',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 16),
      Text(
        'This is a full-screen example with an app bar. The Screen component '
        'automatically handles the app bar integration.',
        style: TextStyle(fontSize: 16),
      ),
      SizedBox(height: 24),
      Divider(),
      SizedBox(height: 24),
      Text(
        'Additional Content',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 16),
      Text(
        'The Screen component makes it easy to create consistent layouts '
        'across your app. It handles safe areas, scrolling, '
        'and padding automatically.',
        style: TextStyle(fontSize: 16),
      ),
    ],
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
