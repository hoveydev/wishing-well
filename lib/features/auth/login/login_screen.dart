import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/features/auth/login/components/login_buttons.dart';
import 'package:wishing_well/features/auth/login/components/login_header.dart';
import 'package:wishing_well/features/auth/login/components/login_inputs.dart';
import 'package:wishing_well/features/auth/login/login_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/utils/loading_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    required this.viewModel,

    /// Demo-only: Shows success message after login simulation.
    this.showDemoSuccess = false,
    super.key,
  });
  final LoginViewModel viewModel;

  /// Demo-only flag to show success message after login simulation.
  final bool showDemoSuccess;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _accountConfirmationChecked = false;
  bool _demoSuccessShown = false;

  // Demo-only message shown after successful login simulation
  static const String _demoLoginSuccessMessage =
      'Login was successful. The application would route to home in production '
      'but the demo does not have this functionality.';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkForAccountConfirmation();
    _checkForDemoSuccess();
  }

  void _checkForDemoSuccess() {
    // Show demo success message when redirected back after login
    if (widget.showDemoSuccess && !_demoSuccessShown) {
      _demoSuccessShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final loading = context.read<LoadingController>();
        loading.showSuccess(
          _demoLoginSuccessMessage,
          onOk: () {
            // Stay on login screen
          },
        );
      });
    }
  }

  void _checkForAccountConfirmation() {
    // Prevent multiple checks - only run once per screen instance
    if (_accountConfirmationChecked) return;
    _accountConfirmationChecked = true;

    try {
      final state = GoRouterState.of(context);
      if (state.uri.queryParameters['accountConfirmed'] == 'true') {
        // Show success overlay after the first frame renders
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final loading = context.read<LoadingController>();
          final l10n = AppLocalizations.of(context)!;
          loading.showSuccess(
            l10n.accountConfirmationMessage,
            onOk: () {
              // Just acknowledge - stay on login screen
            },
          );
          // Remove the query parameter to prevent showing again on rebuild
          context.goNamed(state.uri.path);
        });
      }
    } catch (_) {
      // GoRouter not available (e.g., in tests) - ignore
    }
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _dismissKeyboard(BuildContext context) {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => _dismissKeyboard(context),
    child: Screen(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const LoginHeader(),
        const AppSpacer.large(),
        LoginInputs(
          viewModel: widget.viewModel,
          emailFocusNode: _emailFocusNode,
          passwordFocusNode: _passwordFocusNode,
        ),
        const AppSpacer.large(),
        LoginButtons(viewModel: widget.viewModel),
      ],
    ),
  );
}
