import 'package:flutter/material.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/theme/app_theme.dart';

/// Shared infrastructure for selection-style modal bottom sheets.
///
/// Provides consistent styling (background color, rounded top corners) and a
/// reusable header widget used by sheets like [ImageSourceMenu] and
/// [MultiSelectSheet].

/// A header widget for selection bottom sheets.
///
/// Renders the standard drag handle bar followed by a sheet title.
/// Used as the top section of [ImageSourceMenu], [MultiSelectSheet], and any
/// future selection sheets.
class AppSheetHeader extends StatelessWidget {
  const AppSheetHeader({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: colorScheme.borderGray,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const AppSpacer.small(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(title, style: textTheme.titleMedium),
        ),
      ],
    );
  }
}

/// Utility class for showing selection-style modal bottom sheets.
///
/// Provides a consistent [showModalBottomSheet] configuration (background
/// color, rounded top corners) shared across all selection sheets in the
/// app.
class AppSelectionSheet {
  AppSelectionSheet._();

  /// Shows a modal bottom sheet with the app's standard selection sheet
  /// styling.
  ///
  /// Use [isScrollControlled] when the sheet content uses a
  /// [DraggableScrollableSheet] or otherwise needs to expand beyond half
  /// the screen height.
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isScrollControlled = false,
  }) {
    final colorScheme = context.colorScheme;
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: colorScheme.background,
      isScrollControlled: isScrollControlled,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: builder,
    );
  }
}
