import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/utils/app_config.dart';
import 'package:wishing_well/config/dependencies.dart';
import 'package:wishing_well/utils/deep_links/deep_link_handler.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/utils/deep_links/deep_link_source.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/routing/router.dart';
import 'package:wishing_well/components/loading_overlay/loading_overlay.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/app_logger.dart';
import 'package:wishing_well/features/add_wisher/demo/add_wisher_demo.dart'
    as add_wisher_demo;
import 'package:wishing_well/features/auth/demo/auth_demo.dart' as auth_demo;
import 'package:wishing_well/features/home/demo/home_demo.dart' as home_demo;
import 'package:wishing_well/components/demo/main.dart' as components_demo;

/// Run configuration - switch between app and demos
enum AppRunConfig {
  /// Run the full production app
  production,

  /// Run the components demo
  componentsDemo,

  /// Run the auth feature demo
  authDemo,

  /// Run the home feature demo
  homeDemo,

  /// Run the add_wisher feature demo
  addWisherDemo,
}

/// Current run configuration - change this to run different demos
const AppRunConfig _runConfig = AppRunConfig.production;

/// Current environment for the app.
///
/// Switch between environments by changing this value:
/// - [Environment.local] →  Local Supabase (run `supabase start` first)
/// - [Environment.development] →  Remote Supabase (default)
/// - [Environment.production] →  Production Supabase
///
/// NOTE: This is set to [Environment.local] for local development.
/// Change to [Environment.development] or [Environment.production]
/// before deploying or merging to main for release builds.
const Environment _environment = Environment.development;

Future<void> main() async {
  switch (_runConfig) {
    case AppRunConfig.production:
      await _runProduction();
    case AppRunConfig.addWisherDemo:
      await add_wisher_demo.main();
    case AppRunConfig.homeDemo:
      await home_demo.main();
    case AppRunConfig.authDemo:
      await auth_demo.main();
    case AppRunConfig.componentsDemo:
      components_demo.main();
      return;
  }
}

Future<void> _runProduction() async {
  final goRouter = router();
  final deepLinkSource = DeepLinkSource.platform();
  final deepLinkHandler = DeepLinkHandler(
    (name, queryParameters) => goRouter.goNamed(
      name,
      queryParameters: queryParameters ?? const <String, dynamic>{},
    ),
    source: deepLinkSource,
  );
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.init();
  await AppConfig.initialize(environment: _environment);
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseSecret,
  );
  runApp(
    MultiProvider(
      providers: providersRemote,
      builder: (context, child) =>
          MainApp(router: goRouter, deepLinkHandler: deepLinkHandler),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({
    required this.router,
    required this.deepLinkHandler,
    super.key,
  });
  final GoRouter router;
  final DeepLinkHandler deepLinkHandler;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    widget.deepLinkHandler.init();
  }

  @override
  void dispose() {
    widget.deepLinkHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => LoadingController(),
    child: MaterialApp.router(
      builder: (_, child) => LoadingOverlay(child: child!),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: widget.router,
    ),
  );
}
