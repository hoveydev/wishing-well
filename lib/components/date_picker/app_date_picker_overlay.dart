import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_border_radius.dart';
import 'package:wishing_well/theme/app_border_weight.dart';
import 'package:wishing_well/theme/app_icon_size.dart';
import 'package:wishing_well/theme/app_spacer_size.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/theme/extensions/color_scheme_extension.dart';

enum _DatePickerView { calendar, selector }

enum _DatePickerSelectorTab { year, month }

/// A custom bottom-sheet date picker styled with the app's design system.
///
/// Shows a calendar grid with month/year navigation and Confirm/Cancel
/// actions. The calendar highlights today, the selected date, and dims
/// dates outside [firstDate]–[lastDate].
///
/// Tapping the month/year label in the header switches to selector mode with
/// separate year and month views.
///
/// Use [AppDatePickerOverlay.show] to present the overlay and receive the
/// chosen date (or `null` if the user cancels).
class AppDatePickerOverlay extends StatefulWidget {
  AppDatePickerOverlay({
    required this.firstDate,
    required this.lastDate,
    this.initialDate,
    super.key,
  }) : assert(
         !DateUtils.dateOnly(firstDate).isAfter(DateUtils.dateOnly(lastDate)),
       ),
       assert(
         initialDate == null ||
             !DateUtils.dateOnly(
               initialDate,
             ).isBefore(DateUtils.dateOnly(firstDate)),
       ),
       assert(
         initialDate == null ||
             !DateUtils.dateOnly(
               initialDate,
             ).isAfter(DateUtils.dateOnly(lastDate)),
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
  _DatePickerView _view = _DatePickerView.calendar;
  _DatePickerSelectorTab _selectorTab = _DatePickerSelectorTab.year;
  late int _selectedYear;
  late final ScrollController _yearScrollController;

  static const double _dayCellSize = 40.0;
  static const double _dayCellFontSize = 14.0;
  static const int _calendarRowCount = 6;
  static const double _selectorContentHeight = 280.0;
  static const double _yearItemExtent = 48.0;
  static const double _yearSelectorVerticalPadding =
      (_selectorContentHeight - _yearItemExtent) / 2;

  @override
  void initState() {
    super.initState();
    _firstDate = DateUtils.dateOnly(widget.firstDate);
    _lastDate = DateUtils.dateOnly(widget.lastDate);

    final initial = widget.initialDate != null
        ? DateUtils.dateOnly(widget.initialDate!)
        : null;
    _pendingDate =
        initial != null &&
            !initial.isBefore(_firstDate) &&
            !initial.isAfter(_lastDate)
        ? initial
        : null;

    final focusDate = _pendingDate ?? _defaultFocusDate();
    _displayedMonth = _monthOf(focusDate);
    _selectedYear = focusDate.year;
    _yearScrollController = ScrollController(
      initialScrollOffset:
          (_selectedYear - _firstDate.year).toDouble() * _yearItemExtent,
    );
  }

  @override
  void dispose() {
    _yearScrollController.dispose();
    super.dispose();
  }

  DateTime _monthOf(DateTime date) => DateTime(date.year, date.month);

  DateTime _defaultFocusDate() {
    final today = DateUtils.dateOnly(DateTime.now());
    if (today.isBefore(_firstDate)) return _firstDate;
    if (today.isAfter(_lastDate)) return _lastDate;
    return today;
  }

  int get _yearCount => _lastDate.year - _firstDate.year + 1;

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

  void _openSelector() {
    setState(() {
      _selectedYear = _displayedMonth.year;
      _selectorTab = _DatePickerSelectorTab.year;
      _view = _DatePickerView.selector;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scrollYearIntoView(animated: false);
    });
  }

  void _scrollYearIntoView({required bool animated}) {
    final offset = _yearOffset(_selectedYear);
    if (animated) {
      _yearScrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
    } else {
      _yearScrollController.jumpTo(offset);
    }
  }

  double _yearOffset(int year) => (year - _firstDate.year) * _yearItemExtent;

  int _yearFromScrollOffset(double offset) {
    final yearIndex = (offset / _yearItemExtent).round().clamp(
      0,
      _yearCount - 1,
    );
    return _firstDate.year + yearIndex;
  }

  void _updateSelectedYearFromScroll() {
    if (!_yearScrollController.hasClients) return;
    final year = _yearFromScrollOffset(_yearScrollController.offset);
    if (year == _selectedYear) return;
    setState(() => _selectedYear = year);
  }

  void _snapYearToCenter() {
    if (!_yearScrollController.hasClients) return;
    final targetOffset = _yearOffset(_selectedYear);
    final currentOffset = _yearScrollController.offset;
    if ((currentOffset - targetOffset).abs() < 0.5) {
      _yearScrollController.jumpTo(targetOffset);
      return;
    }
    _yearScrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = context.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacerSize.large,
          0,
          AppSpacerSize.large,
          AppSpacerSize.large,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(colorScheme),
            const SizedBox(height: AppSpacerSize.small),
            _buildTitle(context, l10n),
            const SizedBox(height: AppSpacerSize.medium),
            _buildMonthHeader(context),
            const SizedBox(height: AppSpacerSize.small),
            if (_view == _DatePickerView.calendar) ...[
              _buildDayOfWeekRow(context),
              const SizedBox(height: AppSpacerSize.xsmall),
              _buildCalendarGrid(context),
            ] else
              _buildSelector(context),
            const SizedBox(height: AppSpacerSize.large),
            _buildActions(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle(AppColorScheme colorScheme) => Container(
    margin: const EdgeInsets.only(top: AppSpacerSize.medium),
    width: 40,
    height: AppSpacerSize.xsmall,
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
    final l10n = AppLocalizations.of(context)!;

    if (_view == _DatePickerView.selector) {
      return Row(
        children: [
          Semantics(
            button: true,
            label: l10n.datePickerBackToCalendar,
            child: AppButton.icon(
              icon: Icons.chevron_left,
              type: AppButtonType.tertiary,
              onPressed: () => setState(() => _view = _DatePickerView.calendar),
              color: colorScheme.primary,
              iconSize: const AppIconSize().large,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                l10n.datePickerSelectYearMonth,
                style: textTheme.titleSmall,
              ),
            ),
          ),
          const SizedBox(width: 56),
        ],
      );
    }

    final monthLabel = DateFormat.yMMMM().format(_displayedMonth);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Semantics(
          button: true,
          enabled: _canGoPrevious,
          label: l10n.datePickerPreviousMonth,
          child: IgnorePointer(
            ignoring: !_canGoPrevious,
            child: AppButton.icon(
              icon: Icons.chevron_left,
              type: AppButtonType.tertiary,
              onPressed: _previousMonth,
              color: _canGoPrevious
                  ? colorScheme.primary
                  : colorScheme.borderGray,
              iconSize: const AppIconSize().large,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Semantics(
              button: true,
              label: '$monthLabel — ${l10n.datePickerSelectYearMonth}',
              child: AppButton.labelWithIcon(
                icon: Icons.calendar_today_outlined,
                label: monthLabel,
                type: AppButtonType.secondary,
                onPressed: _openSelector,
                color: colorScheme.primary,
              ),
            ),
          ),
        ),
        Semantics(
          button: true,
          enabled: _canGoNext,
          label: l10n.datePickerNextMonth,
          child: IgnorePointer(
            ignoring: !_canGoNext,
            child: AppButton.icon(
              icon: Icons.chevron_right,
              type: AppButtonType.tertiary,
              onPressed: _nextMonth,
              color: _canGoNext ? colorScheme.primary : colorScheme.borderGray,
              iconSize: const AppIconSize().large,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelector(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      _buildSelectorTabs(context),
      const SizedBox(height: AppSpacerSize.medium),
      if (_selectorTab == _DatePickerSelectorTab.year)
        _buildYearSelector(context)
      else
        _buildMonthSelector(context),
    ],
  );

  Widget _buildSelectorTabs(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isYearSelected = _selectorTab == _DatePickerSelectorTab.year;
    final selectedColor = context.colorScheme.primary;
    final unselectedColor = context.colorScheme.borderGray;

    return Row(
      children: [
        Expanded(
          child: AppButton.label(
            label: l10n.datePickerYearTab,
            type: AppButtonType.secondary,
            onPressed: () => setState(() {
              _selectorTab = _DatePickerSelectorTab.year;
              _scrollYearIntoView(animated: true);
            }),
            color: isYearSelected ? selectedColor : unselectedColor,
          ),
        ),
        const SizedBox(width: AppSpacerSize.medium),
        Expanded(
          child: AppButton.label(
            label: l10n.datePickerMonthTab,
            type: AppButtonType.secondary,
            onPressed: () =>
                setState(() => _selectorTab = _DatePickerSelectorTab.month),
            color: isYearSelected ? unselectedColor : selectedColor,
          ),
        ),
      ],
    );
  }

  Widget _buildYearSelector(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: _selectorContentHeight,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.axis != Axis.vertical) return false;
          _updateSelectedYearFromScroll();
          if (notification is ScrollEndNotification) {
            _snapYearToCenter();
          }
          return false;
        },
        child: ListView.builder(
          controller: _yearScrollController,
          itemCount: _yearCount,
          itemExtent: _yearItemExtent,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            vertical: _yearSelectorVerticalPadding,
          ),
          itemBuilder: (context, index) {
            final year = _firstDate.year + index;
            final isSelected = year == _selectedYear;

            return Semantics(
              button: true,
              selected: isSelected,
              label: '$year',
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacerSize.xsmall,
                ),
                child: GestureDetector(
                  onTap: () => setState(() {
                    _selectedYear = year;
                    _scrollYearIntoView(animated: true);
                  }),
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: double.infinity,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary!.withValues(alpha: 0.12)
                            : null,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '$year',
                        style: textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.borderGray,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMonthSelector(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final monthNames = List.generate(
      12,
      (i) => DateFormat.MMM().format(DateTime(2000, i + 1)),
    );

    return SizedBox(
      height: _selectorContentHeight,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.0,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          final month = index + 1;
          final monthStart = DateTime(_selectedYear, month);
          final monthEnd = DateTime(_selectedYear, month + 1, 0);
          final inRange =
              !monthEnd.isBefore(_firstDate) && !monthStart.isAfter(_lastDate);
          final isCurrentMonth =
              _selectedYear == _displayedMonth.year &&
              month == _displayedMonth.month;

          return Semantics(
            button: inRange,
            enabled: inRange,
            selected: isCurrentMonth,
            label: DateFormat.yMMMM().format(DateTime(_selectedYear, month)),
            child: GestureDetector(
              onTap: inRange
                  ? () => setState(() {
                      _displayedMonth = DateTime(_selectedYear, month);
                      _view = _DatePickerView.calendar;
                    })
                  : null,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isCurrentMonth ? colorScheme.primary : null,
                  border: Border.all(
                    color: inRange
                        ? colorScheme.primary!
                        : colorScheme.borderGray!,
                    width: AppBorderWeight.bold,
                  ),
                  borderRadius: BorderRadius.circular(AppBorderRadius.small),
                ),
                child: Text(
                  monthNames[index],
                  style: textTheme.bodySmall?.copyWith(
                    color: isCurrentMonth
                        ? colorScheme.onPrimary
                        : inRange
                        ? colorScheme.primary
                        : colorScheme.borderGray,
                    fontWeight: isCurrentMonth ? FontWeight.bold : null,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDayOfWeekRow(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = Theme.of(context).textTheme;
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
        child: SizedBox(
          height: 56,
          child: AppButton.label(
            label: l10n.cancel,
            type: AppButtonType.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      const SizedBox(width: AppSpacerSize.medium),
      Expanded(
        child: SizedBox(
          height: 56,
          child: AppButton.label(
            label: l10n.datePickerConfirm,
            type: AppButtonType.primary,
            onPressed: () => Navigator.of(context).pop(_pendingDate),
          ),
        ),
      ),
    ],
  );
}
