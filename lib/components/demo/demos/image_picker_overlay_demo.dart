// Demo files have longer lines for readability
// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:wishing_well/components/image_picker_overlay/image_picker_overlay.dart';
import 'package:wishing_well/components/image_picker_overlay/image_picker_overlay_constants.dart';

class ImagePickerOverlayDemo extends StatefulWidget {
  const ImagePickerOverlayDemo({super.key});

  @override
  State<ImagePickerOverlayDemo> createState() => _ImagePickerOverlayDemoState();
}

class _ImagePickerOverlayDemoState extends State<ImagePickerOverlayDemo> {
  bool _showOverlay = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Image Picker Overlay'),
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
              text: 'Animated loading overlay for image picker operations',
            ),
            const FeatureBulletPoint(
              text: 'Smooth pulsing icon animation with fade-in effect',
            ),
            const FeatureBulletPoint(
              text: 'Semi-transparent backdrop for focus',
            ),
            const FeatureBulletPoint(
              text: 'Customizable messages (gallery/camera)',
            ),
            const FeatureBulletPoint(
              text: 'Cross-fades with dismissing bottom sheets',
            ),
            const FeatureBulletPoint(
              text: 'Fully themed using app color scheme',
            ),
          ]),

          // Interactive Demo
          _buildSection('Interactive Demo', [
            const Text(
              'Tap the buttons to show/hide the overlay:',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => setState(() => _showOverlay = true),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Show Overlay'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => setState(() => _showOverlay = false),
                  icon: const Icon(Icons.stop),
                  label: const Text('Hide Overlay'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current State:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStateRow('Overlay Visible', _showOverlay.toString()),
                  ],
                ),
              ),
            ),
          ]),

          // Overlay Previews
          _buildSection('Overlay Preview - Gallery Message', [
            const Text(
              'This is how the overlay looks with "Opening gallery..." '
              'message:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // Sample background content
                  Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Text(
                        'Your app content would be here',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  // Overlay preview
                  if (_showOverlay)
                    const ImagePickerOverlay(
                      message: ImagePickerOverlayMessage.gallery,
                    ),
                ],
              ),
            ),
          ]),

          _buildSection('Overlay Preview - Camera Message', [
            const Text(
              'This is how the overlay looks with "Opening camera..." message:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // Sample background content
                  Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Text(
                        'Your app content would be here',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  // Overlay preview
                  if (_showOverlay)
                    const ImagePickerOverlay(
                      message: ImagePickerOverlayMessage.camera,
                    ),
                ],
              ),
            ),
          ]),

          // Constants Section
          _buildSection('Available Constants', [
            const Text(
              'The component provides organized constants:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            _buildConstantsCard('ImagePickerOverlaySize', [
              'iconContainer: ${ImagePickerOverlaySize.iconContainer}',
              'icon: ${ImagePickerOverlaySize.icon}',
            ]),
            _buildConstantsCard('ImagePickerOverlayAnimation', [
              'pulseDuration: '
                  '${ImagePickerOverlayAnimation.pulseDuration.inMilliseconds}ms',
              'fadeInIntervalEnd: '
                  '${ImagePickerOverlayAnimation.fadeInIntervalEnd}',
              'iconOpacityMin: '
                  '${ImagePickerOverlayAnimation.iconOpacityMin}',
              'iconOpacityMax: '
                  '${ImagePickerOverlayAnimation.iconOpacityMax}',
              'iconScaleMin: '
                  '${ImagePickerOverlayAnimation.iconScaleMin}',
              'iconScaleMax: '
                  '${ImagePickerOverlayAnimation.iconScaleMax}',
            ]),
            _buildConstantsCard('ImagePickerOverlayVisuals', [
              'backdropOpacity: ${ImagePickerOverlayVisuals.backdropOpacity}',
              'containerOpacity: ${ImagePickerOverlayVisuals.containerOpacity}',
              'textOpacity: ${ImagePickerOverlayVisuals.textOpacity}',
              'textSize: ${ImagePickerOverlayVisuals.textSize}',
              'textWeight: ${ImagePickerOverlayVisuals.textWeight}',
              'textSpacing: ${ImagePickerOverlayVisuals.textSpacing}',
            ]),
            _buildConstantsCard('ImagePickerOverlayMessage', [
              'gallery: "${ImagePickerOverlayMessage.gallery}"',
              'camera: "${ImagePickerOverlayMessage.camera}"',
            ]),
            _buildConstantsCard('ImagePickerOverlayIcon', [
              'icon: Icons.photo_library_outlined',
            ]),
          ]),

          // Use Cases
          _buildSection('Common Use Cases', [
            _buildUseCaseCard('Loading while gallery opens'),
            _buildUseCaseCard('Loading while camera opens'),
            _buildUseCaseCard('Any async image selection operation'),
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
          width: 120,
          child: Text(
            '$label:',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
        Text(value, style: const TextStyle(fontSize: 14)),
      ],
    ),
  );

  Widget _buildConstantsCard(String title, List<String> values) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...values.map(
            (v) => Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 2),
              child: Text(
                v,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'monospace',
                  color: Colors.grey[700],
                ),
              ),
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
