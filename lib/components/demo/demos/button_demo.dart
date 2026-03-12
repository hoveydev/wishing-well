import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/theme/extensions/color_scheme_extension.dart';

class ButtonDemo extends StatefulWidget {
  const ButtonDemo({super.key});

  @override
  State<ButtonDemo> createState() => _ButtonDemoState();
}

class _ButtonDemoState extends State<ButtonDemo> {
  bool _isLoading = false;
  bool _isDisabled = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).extension<AppColorScheme>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Button Components'),
        backgroundColor: Colors.blue.withValues(alpha: 0.1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Controls
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Interactive Controls',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: _isLoading,
                          onChanged: (value) =>
                              setState(() => _isLoading = value ?? false),
                        ),
                        const Text('Loading State'),
                        const SizedBox(width: 20),
                        Checkbox(
                          value: _isDisabled,
                          onChanged: (value) =>
                              setState(() => _isDisabled = value ?? false),
                        ),
                        const Text('Disabled State'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Primary Buttons
            _buildSection('Primary Buttons', [
              Row(
                children: [
                  Expanded(
                    child: AppButton.label(
                      label: 'Normal',
                      onPressed: _isDisabled ? () {} : _handleButtonPress,
                      type: AppButtonType.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton.label(
                      label: _isLoading ? 'Loading...' : 'With Loading',
                      onPressed: _isDisabled ? () {} : _handleButtonPress,
                      type: AppButtonType.primary,
                      isLoading: _isLoading,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AppButton.label(
                label: 'Disabled',
                onPressed: () {},
                type: AppButtonType.primary,
              ),
            ]),

            // Secondary Buttons
            _buildSection('Secondary Buttons', [
              Row(
                children: [
                  Expanded(
                    child: AppButton.label(
                      label: 'Normal',
                      onPressed: _isDisabled ? () {} : _handleButtonPress,
                      type: AppButtonType.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton.label(
                      label: _isLoading ? 'Loading...' : 'With Loading',
                      onPressed: _isDisabled ? () {} : _handleButtonPress,
                      type: AppButtonType.secondary,
                      isLoading: _isLoading,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AppButton.label(
                label: 'Disabled',
                onPressed: () {},
                type: AppButtonType.secondary,
              ),
            ]),

            // Tertiary Buttons
            _buildSection('Tertiary Buttons', [
              Row(
                children: [
                  Expanded(
                    child: AppButton.label(
                      label: 'Normal',
                      onPressed: _isDisabled ? () {} : _handleButtonPress,
                      type: AppButtonType.tertiary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton.label(
                      label: _isLoading ? 'Loading...' : 'With Loading',
                      onPressed: _isDisabled ? () {} : _handleButtonPress,
                      type: AppButtonType.tertiary,
                      isLoading: _isLoading,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AppButton.label(
                label: 'Disabled',
                onPressed: () {},
                type: AppButtonType.tertiary,
              ),
            ]),

            // Buttons with Icons
            _buildSection('Buttons with Icons', [
              Row(
                children: [
                  Expanded(
                    child: AppButton.labelWithIcon(
                      label: 'With Icon',
                      icon: Icons.star,
                      onPressed: _handleButtonPress,
                      type: AppButtonType.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton.icon(
                      icon: Icons.favorite,
                      onPressed: _handleButtonPress,
                      type: AppButtonType.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppButton.labelWithIcon(
                      label: 'Tertiary + Icon',
                      icon: Icons.settings,
                      onPressed: _handleButtonPress,
                      type: AppButtonType.tertiary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton.icon(
                      icon: Icons.delete,
                      onPressed: _handleButtonPress,
                      type: AppButtonType.primary,
                    ),
                  ),
                ],
              ),
            ]),

            // Color Variations (Tertiary/Secondary buttons with custom colors)
            _buildSection('Color Variations', [
              const Text(
                'Use the optional color parameter on tertiary or secondary '
                'buttons to create custom colored variants:',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),

              // Tertiary with semantic colors
              const Text(
                'Tertiary with semantic colors:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: AppButton.label(
                      label: 'Success',
                      onPressed: _handleButtonPress,
                      type: AppButtonType.tertiary,
                      color: colorScheme?.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton.label(
                      label: 'Error',
                      onPressed: _handleButtonPress,
                      type: AppButtonType.tertiary,
                      color: colorScheme?.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppButton.label(
                      label: 'Warning',
                      onPressed: _handleButtonPress,
                      type: AppButtonType.tertiary,
                      color: colorScheme?.warning,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton.label(
                      label: 'Primary',
                      onPressed: _handleButtonPress,
                      type: AppButtonType.tertiary,
                      color: colorScheme?.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Secondary with custom colors
              const Text(
                'Secondary with custom colors:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: AppButton.label(
                      label: 'Custom Red',
                      onPressed: _handleButtonPress,
                      type: AppButtonType.secondary,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton.label(
                      label: 'Custom Blue',
                      onPressed: _handleButtonPress,
                      type: AppButtonType.secondary,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppButton.label(
                      label: 'Purple',
                      onPressed: _handleButtonPress,
                      type: AppButtonType.secondary,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton.label(
                      label: 'Teal',
                      onPressed: _handleButtonPress,
                      type: AppButtonType.secondary,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
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

  void _handleButtonPress() {
    if (_isLoading) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Button pressed!')));
  }
}
