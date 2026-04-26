import 'package:flutter/material.dart';
import 'package:wishing_well/theme/app_border_radius.dart';
import 'package:wishing_well/theme/app_theme.dart';

/// A styled search text input that mirrors [AppInput]'s focus-aware animated
/// border and Semantics wrapping, with a fixed search prefix icon.
///
/// ## Usage
/// ```dart
/// AppSearchInput(
///   placeholder: 'Search wishers',
///   onChanged: viewModel.updateSearchQuery,
///   controller: _searchController,
///   focusNode: _searchFocusNode,
/// )
/// ```
class AppSearchInput extends StatefulWidget {
  const AppSearchInput({
    required this.placeholder,
    required this.onChanged,
    this.controller,
    this.focusNode,
    super.key,
  });

  final String placeholder;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  State<AppSearchInput> createState() => _AppSearchInputState();
}

class _AppSearchInputState extends State<AppSearchInput> {
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

  void _handleFocusChange() => setState(() => _isFocused = _focusNode.hasFocus);

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
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            prefixIconColor: colorScheme.primary,
            hint: Text(widget.placeholder, style: textStyle.bodyMedium),
            // Inset by the border width so the inner radius matches
            // the outer animated border.
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.medium - 1.5),
              borderSide: BorderSide.none,
            ),
          ),
          cursorColor: colorScheme.primary,
        ),
      ),
    );
  }
}
