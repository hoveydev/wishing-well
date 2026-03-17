import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/routing/transitions.dart';
import 'package:wishing_well/features/auth/login/login_screen.dart';
import 'package:wishing_well/features/auth/login/login_view_model.dart';
import 'package:wishing_well/features/auth/forgot_password/forgot_password_screen.dart';
import 'package:wishing_well/features/auth/forgot_password/forgot_password_view_model.dart';
import 'package:wishing_well/features/auth/create_account/create_account_screen.dart';
import 'package:wishing_well/features/auth/create_account/create_account_view_model.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/utils/loading_controller.dart';

GoRouter authDemoRouter(AuthRepository authRepository) => GoRouter(
  initialLocation: Routes.login.path,
  routes: [
    GoRoute(
      path: Routes.login.path,
      name: Routes.login.name,
      pageBuilder: (context, state) {
        // Check if we should show demo success message
        final showSuccess =
            state.uri.queryParameters['demoLoginSuccess'] == 'true';
        return CustomTransitionPage(
          child: _DemoLoginScreen(
            authRepository: authRepository,
            showDemoSuccess: showSuccess,
          ),
          transitionsBuilder: noTransition,
        );
      },
    ),
    GoRoute(
      path: Routes.forgotPassword.path,
      name: Routes.forgotPassword.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: ForgotPasswordScreen(
          viewModel: ForgotPasswordViewModel(authRepository: authRepository),
        ),
        transitionsBuilder: slideUpTransition,
      ),
    ),
    GoRoute(
      path: Routes.resetPassword.path,
      name: Routes.resetPassword.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: LoginScreen(
          viewModel: LoginViewModel(authRepository: authRepository),
        ),
        transitionsBuilder: slideUpTransition,
      ),
    ),
    GoRoute(
      path: Routes.createAccount.path,
      name: Routes.createAccount.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: CreateAccountScreen(
          viewModel: CreateAccountViewModel(authRepository: authRepository),
        ),
        transitionsBuilder: slideUpTransition,
      ),
    ),
    // Home route - redirect to login with success indicator
    GoRoute(
      path: Routes.home.path,
      name: Routes.home.name,
      redirect: (context, state) =>
          '${Routes.login.path}?demoLoginSuccess=true',
    ),
  ],
);

/// Demo wrapper around LoginScreen that shows success message after login.
class _DemoLoginScreen extends StatefulWidget {
  const _DemoLoginScreen({
    required this.authRepository,
    this.showDemoSuccess = false,
  });

  final AuthRepository authRepository;
  final bool showDemoSuccess;

  @override
  State<_DemoLoginScreen> createState() => _DemoLoginScreenState();
}

class _DemoLoginScreenState extends State<_DemoLoginScreen> {
  late final LoginViewModel _viewModel;
  bool _demoSuccessShown = false;

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel(authRepository: widget.authRepository);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkForDemoSuccess();
  }

  void _checkForDemoSuccess() {
    if (widget.showDemoSuccess && !_demoSuccessShown) {
      _demoSuccessShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        // Remove query param to prevent showing again on rebuild
        context.goNamed(Routes.login.name);

        // Show success message
        final loading = context.read<LoadingController>();
        loading.showSuccess(
          'Login was successful. '
          'In production, the app would navigate to home.',
          onOk: () {},
        );
      });
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LoginScreen(viewModel: _viewModel);
}
