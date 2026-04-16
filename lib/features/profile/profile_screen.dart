import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_alert/app_alert.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/features/profile/profile_view_model.dart';
import 'package:wishing_well/utils/auth_error.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({required this.viewModel, super.key});

  final ProfileViewModelContract viewModel;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_showErrorAlert);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_showErrorAlert);
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Screen(
      appBar: AppMenuBar(
        action: () => widget.viewModel.tapCloseButton(context),
        type: AppMenuBarType.close,
      ),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox.shrink(),
        AppButton.label(
          label: l10n.logout,
          onPressed: () => widget.viewModel.tapLogoutButton(context),
          type: AppButtonType.tertiary,
        ),
      ],
    );
  }

  void _showErrorAlert() {
    if (widget.viewModel.authError ==
        const UIAuthError(ProfileErrorType.none)) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return AppAlert(
            title: l10n.errorAlertTitle,
            message: _errorMessage(context),
            confirmLabel: l10n.ok,
            onConfirm: () {
              widget.viewModel.clearError();
            },
          );
        },
      );
    });
  }

  String _errorMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return switch (widget.viewModel.authError) {
      UIAuthError(:final type) => switch (type) {
        ProfileErrorType.unknown => l10n.errorUnknown,
        ProfileErrorType.none => '',
      },
      SupabaseAuthError(:final message) => message,
    };
  }
}
