import 'package:flutter/material.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_spacing.dart';
import 'package:wishing_well/theme/app_theme.dart';

class Wisher {
  const Wisher(this.name);
  final String name;
}

class _WisherItem extends StatefulWidget {
  const _WisherItem(this.wisher, this.padding);
  final Wisher wisher;
  final EdgeInsets padding;

  @override
  _WisherItemState createState() => _WisherItemState();
}

class _WisherItemState extends State<_WisherItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final colorScheme = context.colorScheme;
    return Padding(
      padding: widget.padding,
      child: Column(
        children: [
          GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            onTap: () => debugPrint('${widget.wisher.name} tapped'),
            child: AnimatedOpacity(
              opacity: _isPressed ? 0.5 : 1.0,
              duration: _isPressed
                  ? const Duration(milliseconds: 25)
                  : const Duration(milliseconds: 100),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: colorScheme.primary,
                child: Text(
                  widget.wisher.name[0],
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(widget.wisher.name, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}

class WishersList extends StatelessWidget {
  const WishersList({super.key});

  static const List<Wisher> _wishers = [
    Wisher('Alice'),
    Wisher('Bob'),
    Wisher('Charlie'),
    Wisher('Diana'),
    Wisher('Alice'),
    Wisher('Bob'),
    Wisher('Charlie'),
    Wisher('Diana'),
  ];

  Widget _buildItem(BuildContext context, int index) {
    final wisher = _wishers[index];
    final padding = index == _wishers.length - 1
        ? EdgeInsets.zero
        : const EdgeInsets.only(right: 16);
    return _WisherItem(wisher, padding);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      header: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.wishers, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: -AppSpacing.screenPaddingStandard,
                  right: -AppSpacing.screenPaddingStandard,
                  child: SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPaddingStandard,
                      ),
                      itemCount: _wishers.length,
                      itemBuilder: _buildItem,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
