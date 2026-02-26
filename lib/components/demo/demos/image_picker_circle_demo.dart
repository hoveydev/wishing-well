import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wishing_well/components/image_picker_circle/image_picker_circle.dart';

class CircleImagePickerDemo extends StatefulWidget {
  const CircleImagePickerDemo({super.key});

  @override
  State<CircleImagePickerDemo> createState() => _CircleImagePickerDemoState();
}

class _CircleImagePickerDemoState extends State<CircleImagePickerDemo> {
  File? _selectedFile;
  String? _remoteUrl;

  // Simulated remote URL for demo
  static const _demoRemoteUrl =
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=200&fit=crop';

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Circle Image Picker'),
      backgroundColor: Colors.lime.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Features Section
          _buildSection('Features', [
            const FeatureBulletPoint(text: 'Generic circular image picker'),
            const FeatureBulletPoint(text: 'Supports local file or remote URL'),
            const FeatureBulletPoint(text: 'Configurable size (radius)'),
            const FeatureBulletPoint(text: 'Optional edit icon overlay'),
            const FeatureBulletPoint(text: 'Optional label text'),
            const FeatureBulletPoint(text: 'Placeholder with camera icon'),
          ]),

          // Basic Examples
          _buildSection('Basic Examples', [
            const Text(
              'Tap any avatar to simulate image selection:',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Empty - no image
                CircleImagePicker(
                  onTap: () => _simulatePickImage(context, useRemote: false),
                  label: 'Empty',
                ),
                // With local file
                if (_selectedFile != null)
                  CircleImagePicker(
                    onTap: () => _simulatePickImage(context, useRemote: false),
                    imageFile: _selectedFile,
                    label: 'Local File',
                  ),
                // With remote URL
                if (_selectedFile == null && _remoteUrl != null)
                  CircleImagePicker(
                    onTap: () => _simulatePickImage(context, useRemote: true),
                    imageUrl: _remoteUrl,
                    label: 'Remote URL',
                  ),
              ],
            ),
          ]),

          // Size Variations
          _buildSection('Size Variations', [
            const Text(
              'Different radius values:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSizeDemo('Small', 30),
                _buildSizeDemo('Medium', 50),
                _buildSizeDemo('Large', 70),
              ],
            ),
          ]),

          // Edit Icon Variations
          _buildSection('Edit Icon Variations', [
            const Text(
              'Show/hide the edit icon overlay:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleImagePicker(
                  onTap: () {},
                  imageUrl: _demoRemoteUrl,
                  label: 'With Edit',
                ),
                CircleImagePicker(
                  onTap: () {},
                  imageUrl: _demoRemoteUrl,
                  showEditIcon: false,
                  label: 'No Edit',
                ),
              ],
            ),
          ]),

          // Label Variations
          _buildSection('Label Variations', [
            const Text(
              'Different label configurations:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleImagePicker(onTap: () {}, label: 'Add Photo'),
                CircleImagePicker(
                  onTap: () {},
                  imageUrl: _demoRemoteUrl,
                  label: 'Change',
                ),
                CircleImagePicker(
                  onTap: _demoOnlyNoOp,
                  // No label, no image - display only
                ),
              ],
            ),
          ]),

          // Interactive Demo
          _buildSection('Interactive Demo', [
            const Text(
              'Try it out - tap to "select" an image:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Center(
              child: CircleImagePicker(
                onTap: () => _showPickOptions(context),
                imageFile: _selectedFile,
                imageUrl: _remoteUrl,
                label: _selectedFile != null
                    ? 'Change Photo'
                    : (_remoteUrl != null ? 'Change Photo' : 'Add Photo'),
              ),
            ),
            const SizedBox(height: 16),
            // Status
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
                    _buildStateRow('Local File', _selectedFile?.path ?? 'None'),
                    _buildStateRow('Remote URL', _remoteUrl ?? 'None'),
                    _buildStateRow(
                      'Has Image',
                      (_selectedFile != null || _remoteUrl != null).toString(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: _remoteUrl != null
                      ? () => setState(() => _remoteUrl = null)
                      : null,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear URL'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _selectedFile != null
                      ? () => setState(() => _selectedFile = null)
                      : null,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear File'),
                ),
              ],
            ),
          ]),

          // Use Cases
          _buildSection('Common Use Cases', [
            _buildUseCaseCard('User profile pictures'),
            _buildUseCaseCard('Wisher profile photos'),
            _buildUseCaseCard('Avatar selection'),
            _buildUseCaseCard('Photo galleries'),
            _buildUseCaseCard('Contact images'),
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

  Widget _buildSizeDemo(String label, double radius) => Column(
    children: [
      CircleImagePicker(onTap: () {}, imageUrl: _demoRemoteUrl, radius: radius),
      const SizedBox(height: 8),
      Text('$label ($radius)'),
    ],
  );

  Widget _buildStateRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        SizedBox(
          width: 100,
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

  void _simulatePickImage(BuildContext context, {required bool useRemote}) {
    // In real usage, this would open image_picker
    // For demo, we just toggle between states
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          useRemote
              ? 'In production: Opens image picker, uploads to '
                    'storage, returns URL'
              : 'In production: Opens image picker, returns local file',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showPickOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                // In production: use image_picker to take photo
                _simulatePickImage(context, useRemote: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                // In production: use image_picker to pick from gallery
                _simulatePickImage(context, useRemote: false);
              },
            ),
            if (_selectedFile == null)
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('Use Remote URL (Demo)'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _remoteUrl = _demoRemoteUrl;
                  });
                },
              ),
            if (_selectedFile != null || _remoteUrl != null)
              ListTile(
                leading: const Icon(Icons.clear),
                title: const Text('Remove Photo'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedFile = null;
                    _remoteUrl = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  // Demo-only: no-op callback for display-only examples
  void _demoOnlyNoOp() {}
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
