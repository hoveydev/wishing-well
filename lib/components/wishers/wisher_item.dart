import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/touch_feedback/touch_feedback_opacity.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/app_logger.dart';

/// Wisher avatar component that displays profile pictures.
///
/// Shows initial letter as placeholder.
/// On image load error, cleanly shows the initial.
class WisherItem extends StatelessWidget {
  const WisherItem(this.wisher, this.padding, {super.key});
  final Wisher wisher;
  final EdgeInsets padding;

  /// Get auth headers for loading private images
  Map<String, String> get _authHeaders {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        return {'Authorization': 'Bearer ${session.accessToken}'};
      }
    } catch (e) {
      // Supabase not initialized - return empty headers
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Always show initial - clean fallback
    final initialAvatar = CircleAvatar(
      radius: 30,
      backgroundColor: colorScheme.primary,
      child: Text(
        wisher.initial,
        style: textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary),
      ),
    );

    // No image? Show initial
    if (wisher.profilePicture == null) {
      return Padding(
        padding: padding,
        child: Column(
          children: [
            TouchFeedbackOpacity(
              onTap: () => AppLogger.debug(
                '${wisher.name} tapped',
                context: 'WisherItem',
              ),
              child: initialAvatar,
            ),
            const AppSpacer.xsmall(),
            Text(wisher.firstName, style: textTheme.bodySmall),
          ],
        ),
      );
    }

    // Has image - load it
    return Padding(
      padding: padding,
      child: Column(
        children: [
          TouchFeedbackOpacity(
            onTap: () =>
                AppLogger.debug('${wisher.name} tapped', context: 'WisherItem'),
            child: SizedBox(
              width: 60,
              height: 60,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Bottom: initial (always visible, shows on error)
                  initialAvatar,
                  // Top: image
                  Image.network(
                    wisher.profilePicture!,
                    headers: _authHeaders,
                    fit: BoxFit.cover,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded || frame != null) {
                            return ClipOval(child: child);
                          }
                          return const SizedBox.shrink();
                        },
                    // On error - show initial (already visible below)
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
          const AppSpacer.xsmall(),
          Text(wisher.firstName, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}
