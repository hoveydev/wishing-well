import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wishing_well/components/date_picker/app_date_picker_overlay.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_border_radius.dart';
import 'package:wishing_well/theme/app_icon_size.dart';
import 'package:wishing_well/theme/app_theme.dart';

/// A tappable date-picker row that integrates with the app's design system.
class AppDatePickerField extends StatelessWidget {
  const AppDatePickerField({
    required this.onChanged,
    required this.placeholder,
    this.value,
    this.firstDate,
    this.lastDate,
    super.key,
  });

  final DateTime? value;
  final String placeholder;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final hasValue = value != null;

    return Semantics(
      label: hasValue
          ? '$placeholder: ${DateFormat.yMMMMd().format(value!)}'
          : placeholder,
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppBorderRadius.small),
        onTap: () => _pickDate(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: const AppIconSize().large,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  hasValue ? DateFormat.yMMMMd().format(value!) : placeholder,
                  style: hasValue
                      ? textTheme.bodyLarge
                      : textTheme.bodyLarge?.copyWith(
                          color: colorScheme.borderGray,
                        ),
                ),
              ),
              if (hasValue)
                IconButton(
                  onPressed: () => onChanged(null),
                  icon: Icon(
                    Icons.close,
                    size: const AppIconSize().medium,
                    color: colorScheme.borderGray,
                  ),
                  tooltip: l10n.datePickerClearDate,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 48,
                    minHeight: 48,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await AppDatePickerOverlay.show(
      context: context,
      initialDate: value,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? now,
    );
    if (!context.mounted) return;
    if (picked != null) {
      onChanged(picked);
    }
  }
}
