import 'package:flutter/material.dart';
import 'package:wishing_well/components/profile_image/profile_image.dart';
import 'package:wishing_well/theme/app_spacer_size.dart';

class ProfileImageDemo extends StatefulWidget {
  const ProfileImageDemo({super.key});

  @override
  State<ProfileImageDemo> createState() => _ProfileImageDemoState();
}

class _ProfileImageDemoState extends State<ProfileImageDemo> {
  String _firstName = 'John';
  String _lastName = 'Doe';
  double _radius = 40;
  bool _showEditIcon = false;
  String? _imageUrl;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Profile Image'),
      backgroundColor: Colors.pink.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacerSize.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Interactive Demo
          _buildSection('Interactive Demo', [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacerSize.large),
                child: Column(
                  children: [
                    const Text(
                      'ProfileImage:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppSpacerSize.large),
                    Center(
                      child: ProfileImage(
                        imageUrl: _imageUrl,
                        firstName: _firstName,
                        radius: _radius,
                        showEditIcon: _showEditIcon,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),

          // Controls
          _buildSection('Controls', [
            _buildTextField(
              'First Name',
              _firstName,
              (v) => setState(() => _firstName = v),
            ),
            _buildTextField(
              'Last Name',
              _lastName,
              (v) => setState(() => _lastName = v),
            ),
            _buildTextField(
              'Image URL (optional)',
              _imageUrl ?? '',
              (v) => setState(() => _imageUrl = v.isEmpty ? null : v),
            ),
            _buildSlider(
              'Radius',
              _radius,
              20,
              80,
              (v) => setState(() => _radius = v),
            ),
            _buildSwitch(
              'Show Edit Icon',
              _showEditIcon,
              (v) => setState(() => _showEditIcon = v),
            ),
          ]),

          // ProfileAvatar
          _buildSection('ProfileAvatar (simpler version for lists)', [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacerSize.large),
                child: Column(
                  children: [
                    const Text(
                      'With image:',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: AppSpacerSize.small),
                    ProfileAvatar(
                      imageUrl: _imageUrl,
                      firstName: _firstName,
                      lastName: _lastName,
                    ),
                    const SizedBox(height: AppSpacerSize.large),
                    const Text(
                      'Without image (fallback to initials):',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: AppSpacerSize.small),
                    ProfileAvatar(firstName: _firstName, lastName: _lastName),
                  ],
                ),
              ),
            ),
          ]),

          // ProfileImageWithLabel
          _buildSection('ProfileImageWithLabel (for success/error overlays)', [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacerSize.large),
                child: Center(
                  child: ProfileImageWithLabel(
                    imageUrl: _imageUrl,
                    name: '$_firstName $_lastName'.trim(),
                  ),
                ),
              ),
            ),
          ]),

          // Sizes Comparison
          _buildSection('Size Variations', [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacerSize.large),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        ProfileAvatar(firstName: 'A', radius: 20),
                        SizedBox(height: AppSpacerSize.xsmall),
                        Text('20px', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        ProfileAvatar(firstName: 'B'),
                        SizedBox(height: AppSpacerSize.xsmall),
                        Text('30px', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        ProfileAvatar(firstName: 'C', radius: 40),
                        SizedBox(height: AppSpacerSize.xsmall),
                        Text('40px', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        ProfileAvatar(firstName: 'D', radius: 50),
                        SizedBox(height: AppSpacerSize.xsmall),
                        Text('50px', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),

          // Features
          _buildSection('Features', [
            const _FeatureBulletPoint(text: 'Supports local file display'),
            const _FeatureBulletPoint(
              text: 'Supports remote URL with auth headers',
            ),
            const _FeatureBulletPoint(text: 'Loading state with spinner'),
            const _FeatureBulletPoint(text: 'Error fallback to initials'),
            const _FeatureBulletPoint(
              text:
                  'Three variants: ProfileImage, ProfileAvatar, '
                  'ProfileImageWithLabel',
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

  Widget _buildTextField(
    String label,
    String value,
    ValueChanged<String> onChanged,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacerSize.medium),
    child: TextField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      controller: TextEditingController(text: value),
      onChanged: onChanged,
    ),
  );

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacerSize.medium),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toInt()}'),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    ),
  );

  Widget _buildSwitch(String label, bool value, ValueChanged<bool> onChanged) =>
      Padding(
        padding: const EdgeInsets.only(bottom: AppSpacerSize.medium),
        child: Row(
          children: [
            Text(label),
            const Spacer(),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      );
}

class _FeatureBulletPoint extends StatelessWidget {
  const _FeatureBulletPoint({required this.text});

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
