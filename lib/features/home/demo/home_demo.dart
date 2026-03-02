import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/home/demo/home_demo_providers.dart';
import 'package:wishing_well/features/home/demo/home_demo_router.dart';
import 'package:wishing_well/features/shared/loading/loading_overlay.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';

// Available scenarios:
// - noWishers: Empty wishers list
// - fewWishers: 2 wishers
// - manyWishers: 50 wishers (default)
// - failure: Empty with error handling
const HomeDemoScenario _scenario = HomeDemoScenario.manyWishers;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: getHomeDemoProviders(scenario: _scenario),
      child: Builder(
        builder: (context) {
          final authRepo = context.read<AuthRepository>();
          final wisherRepo = context.read<WisherRepository>();
          final router = homeDemoRouter(authRepo, wisherRepo);
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
      title: 'Home - Demo',
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
