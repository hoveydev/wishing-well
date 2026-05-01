import 'package:flutter/material.dart';
import 'package:wishing_well/components/multi_select/multi_select_sheet.dart';
import 'package:wishing_well/components/touch_feedback/touch_feedback_opacity.dart';
import 'package:wishing_well/theme/app_theme.dart';

/// A single item in an [AppMultiSelectField].
class AppMultiSelectItem {
  const AppMultiSelectItem({required this.value, required this.label});

  final String value;
  final String label;
}

/// A tappable multi-select field that opens a bottom sheet with checkboxes.
class AppMultiSelectField extends StatefulWidget {
  const AppMultiSelectField({
    required this.items,
    required this.selectedValues,
    required this.onChanged,
    required this.placeholder,
    required this.title,
    super.key,
  });

  final List<AppMultiSelectItem> items;
  final List<String> selectedValues;
  final ValueChanged<List<String>> onChanged;
  final String placeholder;
  final String title;

  @override
  State<AppMultiSelectField> createState() => _AppMultiSelectFieldState();
}

class _AppMultiSelectFieldState extends State<AppMultiSelectField> {
  Future<void> _openSheet() async {
    final result = await MultiSelectSheet.show(
      context: context,
      items: widget.items,
      selectedValues: widget.selectedValues,
      title: widget.title,
    );
    if (!mounted) return;
    if (result != null) {
      widget.onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final selected = widget.selectedValues;
    final hasSelection = selected.isNotEmpty;
    final labelByValue = {
      for (final item in widget.items) item.value: item.label,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TouchFeedbackOpacity(
          onTap: _openSheet,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                Icon(
                  Icons.checklist_outlined,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hasSelection
                        ? MaterialLocalizations.of(
                            context,
                          ).selectedRowCountTitle(selected.length)
                        : widget.placeholder,
                    style: hasSelection
                        ? textTheme.bodyLarge
                        : textTheme.bodyLarge?.copyWith(
                            color: colorScheme.borderGray,
                          ),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: colorScheme.borderGray),
              ],
            ),
          ),
        ),
        if (hasSelection)
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: selected.map((value) {
                final label = labelByValue[value] ?? value;
                return Chip(
                  label: Text(
                    label,
                    style: TextStyle(color: colorScheme.primary),
                  ),
                  backgroundColor: colorScheme.primary!.withValues(alpha: 0.12),
                  side: BorderSide(
                    color: colorScheme.primary!.withValues(alpha: 0.3),
                  ),
                  deleteIconColor: colorScheme.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onDeleted: () {
                    final updated = selected.where((v) => v != value).toList();
                    widget.onChanged(updated);
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
