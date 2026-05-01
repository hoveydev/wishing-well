import 'package:flutter/material.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/checklist/checklist_icon.dart';
import 'package:wishing_well/components/multi_select/app_multi_select_field.dart';
import 'package:wishing_well/components/sheet/app_selection_sheet.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/touch_feedback/touch_feedback_opacity.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';

/// A scrollable modal bottom sheet for selecting multiple items via checkboxes.
///
/// Displays a list of [AppMultiSelectItem] entries with a checkbox for each.
/// The user may toggle any number of items; tapping "Done" confirms the
/// selection and returns a [List<String>] of selected values.
///
/// Use [MultiSelectSheet.show] to present the sheet and await the result.
class MultiSelectSheet extends StatefulWidget {
  const MultiSelectSheet({
    required this.items,
    required this.selectedValues,
    required this.title,
    super.key,
  });

  final List<AppMultiSelectItem> items;
  final List<String> selectedValues;
  final String title;

  /// Show the multi-select sheet as a modal bottom sheet.
  ///
  /// Returns the updated list of selected values when the user taps "Done",
  /// or `null` if the sheet is dismissed without confirming.
  static Future<List<String>?> show({
    required BuildContext context,
    required List<AppMultiSelectItem> items,
    required List<String> selectedValues,
    required String title,
  }) => AppSelectionSheet.show<List<String>>(
    context: context,
    isScrollControlled: true,
    builder: (context) => MultiSelectSheet(
      items: items,
      selectedValues: selectedValues,
      title: title,
    ),
  );

  @override
  State<MultiSelectSheet> createState() => _MultiSelectSheetState();
}

class _MultiSelectSheetState extends State<MultiSelectSheet> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          AppSheetHeader(title: widget.title),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isSelected = _selected.contains(item.value);
                return TouchFeedbackOpacity(
                  onTap: () => setState(() {
                    if (isSelected) {
                      _selected.remove(item.value);
                    } else {
                      _selected.add(item.value);
                    }
                  }),
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: _SelectionRow(
                      label: item.label,
                      isSelected: isSelected,
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: AppButton.label(
                label: l10n.done,
                type: AppButtonType.primary,
                onPressed: () => Navigator.of(context).pop(_selected.toList()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionRow extends StatelessWidget {
  const _SelectionRow({required this.label, required this.isSelected});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        ChecklistIcon(
          icon: isSelected ? Icons.check : null,
          iconColor: isSelected
              ? colorScheme.onPrimary!
              : colorScheme.primary!,
          bgColor: isSelected ? colorScheme.primary! : colorScheme.background!,
          borderColor: isSelected
              ? colorScheme.primary!
              : colorScheme.borderGray!,
        ),
        const AppSpacer.small(),
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary!),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
