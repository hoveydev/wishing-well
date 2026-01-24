import 'package:flutter/material.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/theme/app_theme.dart';

class WisherItem extends StatefulWidget {
  const WisherItem(this.wisher, this.padding, {super.key});
  final Wisher wisher;
  final EdgeInsets padding;

  @override
  WisherItemState createState() => WisherItemState();
}

class WisherItemState extends State<WisherItem> {
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
