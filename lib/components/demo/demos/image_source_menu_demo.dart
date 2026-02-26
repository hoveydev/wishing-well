import 'package:flutter/material.dart';
import 'package:wishing_well/components/image_picker_circle/image_picker_circle.dart';
import 'package:wishing_well/components/image_source_menu/image_source_menu.dart';
import 'package:wishing_well/l10n/app_localizations.dart';

class ImageSourceMenuDemo extends StatefulWidget {
  const ImageSourceMenuDemo({super.key});

  @override
  State<ImageSourceMenuDemo> createState() => _ImageSourceMenuDemoState();
}

class _ImageSourceMenuDemoState extends State<ImageSourceMenuDemo> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Image Source Menu'),
      backgroundColor: Colors.lime.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Features Section
          _buildSection('Features', [
            const FeatureBulletPoint(
              text: 'Modal bottom sheet for image source selection',
            ),
            const FeatureBulletPoint(
              text: 'Two options: Choose a Photo or Choose a File',
            ),
            const FeatureBulletPoint(
              text: 'Uses custom color scheme from theme',
            ),
            const FeatureBulletPoint(
              text: 'Callback returns selected option enum',
            ),
          ]),

          // Interactive Demo
          _buildSection('Interactive Demo', [
            const Text(
              'Tap the image picker to open the menu:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Center(
              child: CircleImagePicker(
                onTap: () => _showImageSourceMenu(context),
                label: 'Tap to Select',
              ),
            ),
            const SizedBox(height: 16),
            // Selected option display
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Option:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStateRow('Option', _selectedOption ?? 'None'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Clear selection button
            if (_selectedOption != null)
              Center(
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _selectedOption = null),
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear Selection'),
                ),
              ),
          ]),

          // Usage Guide
          _buildSection('Usage', [_buildUsageCode()]),

          // Use Cases
          _buildSection('Common Use Cases', [
            _buildUseCaseCard('Wisher profile photos'),
            _buildUseCaseCard('User avatar selection'),
            _buildUseCaseCard('Wish item images'),
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

  Widget _buildStateRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );

  Widget _buildUsageCode() => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Code Example:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '''ImageSourceMenu.show(
  context: context,
  onOptionSelected: (option) {
    switch (option) {
      case ImageSourceOption.photo:
        // Handle photo selection
        break;
      case ImageSourceOption.file:
        // Handle file selection
        break;
    }
  },
);''',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildUseCaseCard(String useCase) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(Icons.image, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(useCase, style: const TextStyle(fontSize: 16))),
        ],
      ),
    ),
  );

  void _showImageSourceMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ImageSourceMenu.show(
      context: context,
      onOptionSelected: (option) {
        setState(() {
          _selectedOption = switch (option) {
            ImageSourceOption.photo => l10n.chooseAPhoto,
            ImageSourceOption.file => l10n.chooseAFile,
          };
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected: ${_selectedOption ?? "None"}'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
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
