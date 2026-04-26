import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/features/auth/deep_link_error/deep_link_error_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_icon_size.dart';
import 'package:wishing_well/theme/extensions/color_scheme_extension.dart';

class DeepLinkErrorScreen extends StatelessWidget {
  const DeepLinkErrorScreen({required this.viewModel, super.key});
  final DeepLinkErrorViewModelContract viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).extension<AppColorScheme>();
    final textTheme = Theme.of(context).textTheme;

    return Screen(
      appBar: AppMenuBar(
        action: () => viewModel.tapCloseButton(context),
        type: AppMenuBarType.close,
      ),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: const AppIconSize().overlayIcon,
          color: colorScheme?.primary,
        ),
        const AppSpacer.large(),
        Text(
          l10n.deepLinkErrorTitle,
          textAlign: TextAlign.center,
          style: textTheme.titleLarge?.copyWith(color: colorScheme?.primary),
        ),
        const AppSpacer.medium(),
        Text(
          _errorMessage(l10n),
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: colorScheme?.primary),
        ),
        const AppSpacer.large(),
        AppButton.label(
          label: _actionLabel(l10n),
          onPressed: () => viewModel.tapActionButton(context),
          type: AppButtonType.primary,
        ),
      ],
    );
  }

  String _errorMessage(AppLocalizations l10n) => switch (viewModel.errorType) {
    DeepLinkErrorType.passwordReset => l10n.deepLinkErrorPasswordResetMessage,
    DeepLinkErrorType.accountConfirm => l10n.deepLinkErrorAccountConfirmMessage,
    DeepLinkErrorType.unknown => l10n.deepLinkErrorGenericMessage,
  };

  String _actionLabel(AppLocalizations l10n) => switch (viewModel.errorType) {
    DeepLinkErrorType.passwordReset => l10n.deepLinkErrorPasswordResetAction,
    DeepLinkErrorType.accountConfirm => l10n.deepLinkErrorAccountConfirmAction,
    DeepLinkErrorType.unknown => l10n.deepLinkErrorGenericAction,
  };
}
