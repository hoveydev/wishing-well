import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';

class AppBarDemo extends StatelessWidget {
  const AppBarDemo({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('App Bar Components'),
      backgroundColor: Colors.brown.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // All App Bar Types
          _buildSection('App Bar Types', [
            const Text(
              'Main App Bar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            _buildAppBarPreview(
              'Main - Shows logo and title',
              Colors.blue,
              AppMenuBarType.main,
            ),
            const SizedBox(height: 16),
            const Text(
              'Close App Bar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            _buildAppBarPreview(
              'Close - Shows close button',
              Colors.red,
              AppMenuBarType.close,
            ),
            const SizedBox(height: 16),
            const Text(
              'Dismiss App Bar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            _buildAppBarPreview(
              'Dismiss - Shows dismiss button',
              Colors.orange,
              AppMenuBarType.dismiss,
            ),
          ]),

          // Features Section
          _buildSection('App Bar Features', [
            const FeatureBulletPoint(
              text: 'Three types: Main, Close, and Dismiss',
            ),
            const FeatureBulletPoint(text: 'Logo on main app bar'),
            const FeatureBulletPoint(
              text: 'Action buttons for profile and navigation',
            ),
            const FeatureBulletPoint(text: 'Semantic labels for accessibility'),
            const FeatureBulletPoint(text: 'Consistent height and styling'),
          ]),

          // Interactive Examples
          _buildSection('Interactive Examples', [
            const Text(
              'Tap the buttons below to see full app bars:',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInteractiveButton('Main App Bar', Colors.blue, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const _FullAppBarScreen(
                            type: AppMenuBarType.main,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    _buildInteractiveButton('Close App Bar', Colors.red, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const _FullAppBarScreen(
                            type: AppMenuBarType.close,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    _buildInteractiveButton(
                      'Dismiss App Bar',
                      Colors.orange,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const _FullAppBarScreen(
                              type: AppMenuBarType.dismiss,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ]),

          // Use Cases
          _buildSection('Common Use Cases', [
            _buildUseCaseCard('Main screen navigation', 'AppMenuBarType.main'),
            _buildUseCaseCard('Modal or bottom sheet', 'AppMenuBarType.close'),
            _buildUseCaseCard('Overlay or dropdown', 'AppMenuBarType.dismiss'),
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

Widget _buildAppBarPreview(String label, Color color, AppMenuBarType type) =>
    Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(_getIconForType(type), color: color),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );

IconData _getIconForType(AppMenuBarType type) {
  switch (type) {
    case AppMenuBarType.main:
      return Icons.home;
    case AppMenuBarType.close:
      return Icons.close;
    case AppMenuBarType.dismiss:
      return Icons.keyboard_arrow_down;
  }
}

Widget _buildInteractiveButton(String label, Color color, VoidCallback onTap) =>
    ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 48),
      ),
      child: Text(label),
    );

Widget _buildUseCaseCard(String useCase, String type) => Card(
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
            type,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
      ],
    ),
  ),
);

class _FullAppBarScreen extends StatelessWidget {
  const _FullAppBarScreen({required this.type});

  final AppMenuBarType type;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppMenuBar(type: type, action: () => Navigator.pop(context)),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'This is a ${_getTypeName(type)} App Bar',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text('Tap the action button to go back'),
        ],
      ),
    ),
  );
}

String _getTypeName(AppMenuBarType type) {
  switch (type) {
    case AppMenuBarType.main:
      return 'Main';
    case AppMenuBarType.close:
      return 'Close';
    case AppMenuBarType.dismiss:
      return 'Dismiss';
  }
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
