import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/theme/app_theme.dart';

class AppMenuBar extends StatelessWidget implements PreferredSizeWidget {
  const AppMenuBar({required this.action, required this.type, super.key});
  final AppMenuBarType type;
  final void Function() action;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return AppBar(
      backgroundColor: colorScheme.background,
      surfaceTintColor: colorScheme.primary,
      automaticallyImplyLeading: false,
      leading: _menuBarLeading(action),
      actions: _menuBarActions(action),
    );
  }

  Widget? _menuBarLeading(void Function() action) => switch (type) {
    AppMenuBarType.close => null,
    AppMenuBarType.dismiss => FittedBox(
      child: AppButton.icon(
        icon: Icons.keyboard_arrow_down,
        onPressed: action,
        type: AppButtonType.tertiary,
      ),
    ),
  };

  List<Widget>? _menuBarActions(void Function() action) => switch (type) {
    AppMenuBarType.close => [
      FittedBox(
        child: AppButton.icon(
          icon: Icons.close,
          onPressed: action,
          type: AppButtonType.tertiary,
        ),
      ),
    ],
    AppMenuBarType.dismiss => null,
  };
}
