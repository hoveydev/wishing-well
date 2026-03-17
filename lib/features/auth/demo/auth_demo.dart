import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/features/auth/demo/auth_demo_providers.dart';
import 'package:wishing_well/features/auth/demo/auth_demo_router.dart';
import 'package:wishing_well/components/loading_overlay/loading_overlay.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';

// Available scenarios:
// - success: Successful login/signup flow
// - error: Failed login/signup with error
// - loading: Indefinite loading state
const AuthDemoScenario _scenario = AuthDemoScenario.success;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: getAuthDemoProviders(scenario: _scenario),
      child: Builder(
        builder: (context) {
          final authRepo = context.read<AuthRepository>();
          final router = authDemoRouter(authRepo);
          return _DemoApp(router: router);
        },
      ),
    ),
  );
}

class _DemoApp extends StatelessWidget {
  const _DemoApp({required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => LoadingController(),
    child: MaterialApp.router(
      builder: (_, child) => LoadingOverlay(child: child!),
      title: 'Auth - Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}
