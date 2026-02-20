import 'package:flutter/material.dart';
import 'package:wishing_well/components/touch_feedback/touch_feedback_opacity.dart';
import 'package:wishing_well/utils/app_logger.dart';

class TouchFeedbackDemo extends StatelessWidget {
  const TouchFeedbackDemo({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Touch Feedback Components'),
      backgroundColor: Colors.lime.withValues(alpha: 0.1),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Features Section
          _buildSection('Touch Feedback Features', [
            const FeatureBulletPoint(text: 'Opacity-based touch feedback'),
            const FeatureBulletPoint(
              text: 'Customizable press and release durations',
            ),
            const FeatureBulletPoint(text: 'Adjustable opacity values'),
            const FeatureBulletPoint(text: 'Works with any widget'),
            const FeatureBulletPoint(text: 'Accessibility-friendly'),
          ]),

          // Basic Examples
          _buildSection('Basic Examples', [
            const Text(
              'Tap the boxes below to see feedback:',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildFeedbackBox(
                    'Default',
                    Colors.blue,
                    () => _showSnackBar(context, 'Default tapped!'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFeedbackBox(
                    'Custom',
                    Colors.green,
                    () => _showSnackBar(context, 'Custom tapped!'),
                  ),
                ),
              ],
            ),
          ]),

          // Different Opacities
          _buildSection('Opacity Variations', [
            _buildOpacityCard('Light Touch', Colors.blue, 0.8),
            _buildOpacityCard('Medium Touch', Colors.green, 0.5),
            _buildOpacityCard('Heavy Touch', Colors.orange, 0.3),
          ]),

          // Different Shapes
          _buildSection('Different Shapes', [
            Row(
              children: [
                Expanded(
                  child: _buildShapeFeedback(
                    'Circle',
                    Colors.blue,
                    BoxShape.circle,
                    () => _showSnackBar(context, 'Circle tapped!'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildShapeFeedback(
                    'Rectangle',
                    Colors.green,
                    BoxShape.rectangle,
                    () => _showSnackBar(context, 'Rectangle tapped!'),
                  ),
                ),
              ],
            ),
          ]),

          // Icon Buttons
          _buildSection('Icon Buttons with Feedback', [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconButton(
                  Icons.favorite,
                  Colors.red,
                  () => _showSnackBar(context, 'Favorite tapped!'),
                ),
                _buildIconButton(
                  Icons.thumb_up,
                  Colors.blue,
                  () => _showSnackBar(context, 'Thumbs up tapped!'),
                ),
                _buildIconButton(
                  Icons.share,
                  Colors.green,
                  () => _showSnackBar(context, 'Share tapped!'),
                ),
                _buildIconButton(
                  Icons.bookmark,
                  Colors.orange,
                  () => _showSnackBar(context, 'Bookmark tapped!'),
                ),
              ],
            ),
          ]),

          // Custom Animation Durations
          _buildSection('Animation Durations', [
            const Text(
              'Different press/release speeds:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildDurationCard(
                    'Fast',
                    Colors.blue,
                    const Duration(milliseconds: 10),
                    const Duration(milliseconds: 50),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDurationCard(
                    'Normal',
                    Colors.green,
                    const Duration(milliseconds: 25),
                    const Duration(milliseconds: 100),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDurationCard(
                    'Slow',
                    Colors.orange,
                    const Duration(milliseconds: 50),
                    const Duration(milliseconds: 200),
                  ),
                ),
              ],
            ),
          ]),

          // Use Cases
          _buildSection('Common Use Cases', [
            _buildUseCaseCard('Custom buttons'),
            _buildUseCaseCard('List items'),
            _buildUseCaseCard('Card taps'),
            _buildUseCaseCard('Image overlays'),
            _buildUseCaseCard('Interactive icons'),
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

  Widget _buildFeedbackBox(String label, Color color, VoidCallback onTap) =>
      TouchFeedbackOpacity(
        onTap: onTap,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

  Widget _buildOpacityCard(String label, Color color, double pressedOpacity) =>
      Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              TouchFeedbackOpacity(
                pressedOpacity: pressedOpacity,
                onTap: () => AppLogger.debug(
                  '$label tapped',
                  context: 'TouchFeedbackDemo',
                ),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
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
                      'Opacity: ${(pressedOpacity * 100).toInt()}%',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildShapeFeedback(
    String label,
    Color color,
    BoxShape shape,
    VoidCallback onTap,
  ) => TouchFeedbackOpacity(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            shape: shape,
            borderRadius: shape == BoxShape.rectangle
                ? BorderRadius.circular(12)
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    ),
  );

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onTap) =>
      TouchFeedbackOpacity(
        onTap: onTap,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 30),
        ),
      );

  Widget _buildDurationCard(
    String label,
    Color color,
    Duration pressDuration,
    Duration releaseDuration,
  ) => TouchFeedbackOpacity(
    pressDuration: pressDuration,
    releaseDuration: releaseDuration,
    onTap: () => AppLogger.debug('$label tapped', context: 'TouchFeedbackDemo'),
    child: Container(
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
          const Icon(Icons.touch_app, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(useCase, style: const TextStyle(fontSize: 16))),
        ],
      ),
    ),
  );

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
