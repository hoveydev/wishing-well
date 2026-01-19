import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/app_alert/app_alert.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/profile_screen/profile_viewmodel.dart';
import 'package:wishing_well/utils/auth_error.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel(authRepository: context.read());
    _viewModel.addListener(_showErrorAlert);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_showErrorAlert);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Screen(
      appBar: AppMenuBar(
        action: () => context.pop(),
        type: AppMenuBarType.close,
      ),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox.shrink(),
        AppButton.label(
          label: l10n.logout,
          onPressed: () => _viewModel.tapLogoutButton(context),
          type: AppButtonType.tertiary,
        ),
      ],
    );
  }

  void _showErrorAlert() {
    if (_viewModel.authError == const UIAuthError(ProfileErrorType.none)) {
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
              _viewModel.clearError();
            },
          );
        },
      );
    });
  }

  String _errorMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return switch (_viewModel.authError) {
      UIAuthError(:final type) => switch (type) {
        ProfileErrorType.unknown => l10n.errorUnknown,
        ProfileErrorType.none => '',
      },
      SupabaseAuthError(:final message) => message,
    };
  }
}
