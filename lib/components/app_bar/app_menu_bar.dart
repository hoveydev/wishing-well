import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/logo/app_logo.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_icon_size.dart';
import 'package:wishing_well/theme/app_spacing.dart';
import 'package:wishing_well/theme/app_theme.dart';

class AppMenuBar extends StatelessWidget implements PreferredSizeWidget {
  const AppMenuBar({required this.action, required this.type, super.key});
  final AppMenuBarType type;
  final void Function() action;

  @override
  Size get preferredSize => const Size.fromHeight(AppSpacing.appBarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return AppBar(
      backgroundColor: colorScheme.background,
      surfaceTintColor: colorScheme.primary,
      automaticallyImplyLeading: false,
      leading: _menuBarLeading(action, textTheme, l10n),
      titleSpacing: type == AppMenuBarType.main
          ? AppSpacing.appBarTitleSpacing
          : null,
      centerTitle: false,
      title: _menuBarTitle(l10n, textTheme),
      actions: _menuBarActions(action, l10n),
      elevation: 1,
      shadowColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.1)),
        ),
      ),
    );
  }

  Widget? _menuBarTitle(AppLocalizations l10n, TextTheme textTheme) =>
      switch (type) {
        AppMenuBarType.main => Text(l10n.appName, style: textTheme.titleMedium),
        _ => null,
      };

  Widget? _menuBarLeading(
    void Function() action,
    TextTheme textTheme,
    AppLocalizations l10n,
  ) => switch (type) {
    AppMenuBarType.main => FittedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: AppSpacerSize.xsmall),
        child: AppLogo(size: const AppIconSize().xsmall),
      ),
    ),
    AppMenuBarType.close => null,
    AppMenuBarType.dismiss => Builder(
      builder: (context) => Semantics(
        label: l10n.appBarDismiss,
        button: true,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacerSize.xsmall),
          child: AppButton.icon(
            icon: Icons.keyboard_arrow_down,
            onPressed: action,
            type: AppButtonType.tertiary,
          ),
        ),
      ),
    ),
  };

  List<Widget>? _menuBarActions(
    void Function() action,
    AppLocalizations l10n,
  ) => switch (type) {
    AppMenuBarType.main => [
      Builder(
        builder: (context) => Semantics(
          label: l10n.appBarProfile,
          button: true,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacerSize.xsmall),
            child: AppButton.icon(
              icon: Icons.account_circle,
              onPressed: action,
              type: AppButtonType.tertiary,
            ),
          ),
        ),
      ),
    ],
    AppMenuBarType.close => [
      Builder(
        builder: (context) => Semantics(
          label: l10n.appBarClose,
          button: true,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacerSize.xsmall),
            child: AppButton.icon(
              icon: Icons.close,
              onPressed: action,
              type: AppButtonType.tertiary,
            ),
          ),
        ),
      ),
    ],
    AppMenuBarType.dismiss => null,
  };
}
