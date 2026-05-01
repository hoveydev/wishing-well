import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_border_radius.dart';
import 'package:wishing_well/theme/app_icon_size.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/theme/extensions/color_scheme_extension.dart';

/// A custom bottom-sheet date picker styled with the app's design system.
///
/// Shows a calendar grid with month/year navigation and Confirm/Cancel
/// actions. The calendar highlights today, the selected date, and dims
/// dates outside [firstDate]–[lastDate].
///
/// Use [AppDatePickerOverlay.show] to present the overlay and receive the
/// chosen date (or `null` if the user cancels).
class AppDatePickerOverlay extends StatefulWidget {
  AppDatePickerOverlay({
    required this.firstDate,
    required this.lastDate,
    this.initialDate,
    super.key,
  })  : assert(!firstDate.isAfter(lastDate)),
        assert(
          initialDate == null || !initialDate.isBefore(firstDate),
        ),
        assert(
          initialDate == null || !initialDate.isAfter(lastDate),
        );

  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  /// Shows the overlay as a modal bottom sheet and returns the selected
  /// [DateTime], or `null` if the user cancels or dismisses.
  static Future<DateTime?> show({
    required BuildContext context,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? initialDate,
  }) {
    final colorScheme = context.colorScheme;
    return showModalBottomSheet<DateTime?>(
      context: context,
      backgroundColor: colorScheme.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.large),
        ),
      ),
      builder: (_) => AppDatePickerOverlay(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      ),
    );
  }

  @override
  State<AppDatePickerOverlay> createState() => _AppDatePickerOverlayState();
}

class _AppDatePickerOverlayState extends State<AppDatePickerOverlay> {
  late DateTime _displayedMonth;
  late DateTime _firstDate;
  late DateTime _lastDate;
  DateTime? _pendingDate;

  static const double _dayCellSize = 40.0;
  static const double _dayCellFontSize = 14.0;
  static const int _calendarRowCount = 6;

  @override
  void initState() {
    super.initState();
    _firstDate = DateUtils.dateOnly(widget.firstDate);
    _lastDate = DateUtils.dateOnly(widget.lastDate);
    final initial = widget.initialDate != null
        ? DateUtils.dateOnly(widget.initialDate!)
        : null;
    // Only use initialDate if it's within the valid range
    _pendingDate =
        (initial != null &&
            !initial.isBefore(_firstDate) &&
            !initial.isAfter(_lastDate))
        ? initial
        : null;
    _displayedMonth = _monthOf(_pendingDate ?? _firstDate);
  }

  DateTime _monthOf(DateTime date) => DateTime(date.year, date.month);

  bool get _canGoPrevious => _monthOf(_firstDate).isBefore(_displayedMonth);

  bool get _canGoNext => _displayedMonth.isBefore(_monthOf(_lastDate));

  void _previousMonth() {
    if (!_canGoPrevious) return;
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    if (!_canGoNext) return;
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  void _selectDate(DateTime date) => setState(() => _pendingDate = date);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = context.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(colorScheme),
            const SizedBox(height: 8),
            _buildTitle(context, l10n),
            const SizedBox(height: 12),
            _buildMonthHeader(context),
            const SizedBox(height: 8),
            _buildDayOfWeekRow(context),
            const SizedBox(height: 4),
            _buildCalendarGrid(context),
            const SizedBox(height: 16),
            _buildActions(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle(AppColorScheme colorScheme) => Container(
    margin: const EdgeInsets.only(top: 12),
    width: 40,
    height: 4,
    decoration: BoxDecoration(
      color: colorScheme.borderGray,
      borderRadius: BorderRadius.circular(2),
    ),
  );

  Widget _buildTitle(BuildContext context, AppLocalizations l10n) => Text(
    l10n.datePickerTitle,
    style: Theme.of(context).textTheme.titleMedium,
  );

  Widget _buildMonthHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = context.colorScheme;
    final monthLabel = DateFormat.yMMMM().format(_displayedMonth);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Semantics(
          button: true,
          enabled: _canGoPrevious,
          child: IgnorePointer(
            ignoring: !_canGoPrevious,
            child: AppButton.icon(
              icon: Icons.chevron_left,
              type: AppButtonType.tertiary,
              onPressed: _previousMonth,
              color:
                  _canGoPrevious
                      ? colorScheme.primary
                      : colorScheme.borderGray,
              iconSize: const AppIconSize().large,
            ),
          ),
        ),
        Text(monthLabel, style: textTheme.titleSmall),
        Semantics(
          button: true,
          enabled: _canGoNext,
          child: IgnorePointer(
            ignoring: !_canGoNext,
            child: AppButton.icon(
              icon: Icons.chevron_right,
              type: AppButtonType.tertiary,
              onPressed: _nextMonth,
              color:
                  _canGoNext ? colorScheme.primary : colorScheme.borderGray,
              iconSize: const AppIconSize().large,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayOfWeekRow(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // Sunday-first abbreviated day names from intl
    final dayNames = DateFormat().dateSymbols.SHORTWEEKDAYS
        .map((d) => d.substring(0, 1).toUpperCase())
        .toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: dayNames
          .map(
            (d) => SizedBox(
              width: _dayCellSize,
              child: Center(
                child: Text(
                  d,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.borderGray,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    final firstDayOfMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
    );
    // Dart weekday: Mon=1..Sun=7 → Sun=0..Sat=6
    final startWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = DateUtils.getDaysInMonth(
      _displayedMonth.year,
      _displayedMonth.month,
    );

    return Column(
      children: List.generate(
        _calendarRowCount,
        (row) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (col) {
            final cellIndex = row * 7 + col;
            final dayNumber = cellIndex - startWeekday + 1;
            if (dayNumber < 1 || dayNumber > daysInMonth) {
              return const SizedBox(width: _dayCellSize, height: _dayCellSize);
            }
            final date = DateTime(
              _displayedMonth.year,
              _displayedMonth.month,
              dayNumber,
            );
            return _buildDayCell(context, date, today);
          }),
        ),
      ),
    );
  }

  Widget _buildDayCell(BuildContext context, DateTime date, DateTime today) {
    final colorScheme = context.colorScheme;
    final isSelected =
        _pendingDate != null && DateUtils.isSameDay(_pendingDate, date);
    final isToday = DateUtils.isSameDay(today, date);
    final inRange = !date.isBefore(_firstDate) && !date.isAfter(_lastDate);

    Color textColor;
    BoxDecoration decoration;

    if (isSelected) {
      textColor = colorScheme.onPrimary!;
      decoration = BoxDecoration(
        color: colorScheme.primary,
        shape: BoxShape.circle,
      );
    } else if (isToday && inRange) {
      textColor = colorScheme.primary!;
      decoration = BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colorScheme.primary!),
      );
    } else {
      textColor = inRange ? colorScheme.primary! : colorScheme.borderGray!;
      decoration = const BoxDecoration(shape: BoxShape.circle);
    }

    final dateLabel = DateFormat.yMMMMd().format(date);

    final cell = Semantics(
      label: dateLabel,
      button: inRange,
      enabled: inRange,
      selected: isSelected,
      child: Container(
        width: _dayCellSize,
        height: _dayCellSize,
        decoration: decoration,
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(
              fontSize: _dayCellFontSize,
              color: textColor,
              fontWeight: isSelected || isToday ? FontWeight.bold : null,
            ),
          ),
        ),
      ),
    );

    if (!inRange) return cell;

    return GestureDetector(onTap: () => _selectDate(date), child: cell);
  }

  Widget _buildActions(BuildContext context, AppLocalizations l10n) => Row(
    children: [
      Expanded(
        child: AppButton.label(
          label: l10n.cancel,
          type: AppButtonType.secondary,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: AppButton.label(
          label: l10n.datePickerConfirm,
          type: AppButtonType.primary,
          onPressed: () => Navigator.of(context).pop(_pendingDate),
        ),
      ),
    ],
  );
}
