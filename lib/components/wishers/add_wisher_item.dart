import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';

class AddWisherItem extends StatefulWidget {
  const AddWisherItem(this.padding, {super.key});
  final EdgeInsets padding;

  @override
  AddWisherItemState createState() => AddWisherItemState();
}

class AddWisherItemState extends State<AddWisherItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final colorScheme = context.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: widget.padding,
      child: Column(
        children: [
          GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            onTap: () => debugPrint('Add Wisher tapped'),
            child: AnimatedOpacity(
              opacity: _isPressed ? 0.5 : 1.0,
              duration: _isPressed
                  ? const Duration(milliseconds: 25)
                  : const Duration(milliseconds: 100),
              child: DottedBorder(
                options: CircularDottedBorderOptions(
                  dashPattern: [10, 5],
                  strokeWidth: 2,
                  borderPadding: const EdgeInsets.all(1),
                  color: colorScheme.primary!,
                ),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 24,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const AppSpacer.xsmall(),
          Text(l10n.add, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}
