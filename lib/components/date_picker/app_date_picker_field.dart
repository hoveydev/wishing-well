import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wishing_well/components/date_picker/app_date_picker_overlay.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacerSize.medium,
            vertical: AppSpacerSize.xsmall / 2,
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: const AppIconSize().large,
                color: colorScheme.primary,
              ),
              const SizedBox(width: AppSpacerSize.medium),
              Expanded(
                child: Text(
                  hasValue ? DateFormat.yMMMMd().format(value!) : placeholder,
                  overflow: TextOverflow.ellipsis,
                  style: hasValue
                      ? textTheme.bodyLarge
                      : textTheme.bodyLarge?.copyWith(
                          color: colorScheme.borderGray,
                        ),
                ),
              ),
              Semantics(
                button: hasValue,
                label: hasValue ? l10n.datePickerClearDate : null,
                child: hasValue
                    ? Tooltip(
                        message: l10n.datePickerClearDate,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onChanged(null),
                          child: SizedBox(
                            width: AppSpacerSize.xlarge,
                            height: AppSpacerSize.xlarge,
                            child: Center(
                              child: Icon(
                                Icons.close,
                                size: const AppIconSize().medium,
                                color: colorScheme.borderGray,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        width: AppSpacerSize.xlarge,
                        height: AppSpacerSize.xlarge,
                        child: Center(
                          child: Icon(
                            Icons.arrow_drop_down,
                            size: const AppIconSize().medium,
                            color: colorScheme.borderGray,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final initialDate = value ?? _defaultInitialDate();
    final picked = await AppDatePickerOverlay.show(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime.now(),
    );
    if (!context.mounted) return;
    if (picked != null) {
      onChanged(picked);
    }
  }

  DateTime _defaultInitialDate() {
    final now = DateUtils.dateOnly(DateTime.now());
    final first = DateUtils.dateOnly(firstDate ?? DateTime(1900));
    final last = DateUtils.dateOnly(lastDate ?? DateTime.now());

    if (now.isBefore(first)) return first;
    if (now.isAfter(last)) return last;
    return now;
  }
}
