import 'package:flutter/material.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/theme/app_border_radius.dart';
import 'package:wishing_well/theme/app_theme.dart';

/// A customizable text input component with focus animation.
///
/// ## Features
/// - **Focus Animation**: Smooth 200ms border color transition when focused
/// - **Input Types**: Supports text, email, password, and phone inputs
/// - **Auto Icons**: Automatically displays appropriate icons
/// - **Accessibility**: Includes semantic labels for screen readers
///
/// ## Focus Behavior
/// - **Unfocused**: Border displays in `borderGray` color
/// - **Focused**: Border animates to `primary` color
/// - **No Fill/Glow**: Clean minimal design without shadow effects
///
/// ## Usage
/// ```dart
/// AppInput(
///   placeholder: 'Enter your email',
///   type: AppInputType.email,
///   onChanged: (value) => print('Value: $value'),
/// )
/// ```
///
/// ## Focus Animation
/// The component uses an [AnimatedContainer] to provide smooth border
/// color transitions:
/// - Duration: 200ms
/// - Curve: easeInOut
///
/// To test focus behavior programmatically, pass a [FocusNode]:
/// ```dart
/// final focusNode = FocusNode();
/// // ... use focusNode to request/unfocus
/// focusNode.dispose();
/// ```
class AppInput extends StatefulWidget {
  const AppInput({
    required this.placeholder,
    required this.type,
    required this.onChanged,
    this.controller,
    this.focusNode,
    this.showIcon = true,
    super.key,
  });
  final String placeholder;
  final AppInputType type;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool showIcon;

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final colorScheme = context.colorScheme;

    final borderColor = _isFocused
        ? colorScheme.primary!
        : colorScheme.borderGray!;

    return Semantics(
      label: widget.placeholder,
      textField: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: TextField(
          obscureText: widget.type == AppInputType.password,
          decoration: InputDecoration(
            prefixIcon: _getIcon(),
            prefixIconColor: colorScheme.primary,
            hint: Text(style: textStyle.bodyMedium, widget.placeholder),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.medium - 1.5),
              borderSide: BorderSide.none,
            ),
          ),
          cursorColor: colorScheme.primary,
          keyboardType: _getKeyboardType(),
          autofillHints: _getAutofillHints(),
          onChanged: widget.onChanged,
          controller: widget.controller,
          focusNode: _focusNode,
        ),
      ),
    );
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case AppInputType.text:
        return TextInputType.text;
      case AppInputType.email:
        return TextInputType.emailAddress;
      case AppInputType.password:
        return TextInputType.visiblePassword;
      case AppInputType.phone:
        return TextInputType.phone;
    }
  }

  List<String> _getAutofillHints() {
    switch (widget.type) {
      case AppInputType.email:
        return [AutofillHints.email];
      case AppInputType.password:
        return [AutofillHints.password];
      default:
        return [];
    }
  }

  Icon? _getIcon() {
    if (!widget.showIcon) return null;
    switch (widget.type) {
      case AppInputType.text:
        return const Icon(Icons.input);
      case AppInputType.email:
        return const Icon(Icons.email_outlined);
      case AppInputType.password:
        return const Icon(Icons.lock_outline);
      default:
        return const Icon(Icons.input);
    }
  }
}
