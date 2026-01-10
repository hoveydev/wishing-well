import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/logo/app_logo.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_icon_size.dart';
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
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return AppBar(
      backgroundColor: colorScheme.background,
      surfaceTintColor: colorScheme.primary,
      automaticallyImplyLeading: false,
      leading: _menuBarLeading(action, textTheme),
      centerTitle: false,
      title: _menuBarTitle(l10n, textTheme),
      actions: _menuBarActions(action),
    );
  }

  Widget? _menuBarTitle(AppLocalizations l10n, TextTheme textTheme) =>
      switch (type) {
        AppMenuBarType.main => Text(l10n.appName, style: textTheme.titleMedium),
        _ => null,
      };

  Widget? _menuBarLeading(void Function() action, TextTheme textTheme) =>
      switch (type) {
        AppMenuBarType.main => FittedBox(
          child: Padding(
            padding: const EdgeInsetsGeometry.only(left: AppSpacerSize.xsmall),
            child: AppLogo(size: const AppIconSize().small),
          ),
        ),
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
    AppMenuBarType.main => [
      FittedBox(
        child: AppButton.icon(
          icon: Icons.account_circle,
          onPressed: action,
          type: AppButtonType.tertiary,
        ),
      ),
    ],
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
