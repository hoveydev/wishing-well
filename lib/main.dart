import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/utils/app_config.dart';
import 'package:wishing_well/config/dependencies.dart';
import 'package:wishing_well/data/data_sources/auth/auth_data_source_supabase.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository_impl.dart';
import 'package:wishing_well/utils/deep_links/deep_link_handler.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/utils/deep_links/deep_link_source.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';
import 'package:wishing_well/routing/router.dart';
import 'package:wishing_well/components/status_overlay/status_overlay.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/app_logger.dart';
import 'package:wishing_well/features/add_wisher/demo/add_wisher_demo.dart'
    as add_wisher_demo;
import 'package:wishing_well/features/wisher_details/demo/wisher_details_demo.dart'
    as wisher_details_demo;
import 'package:wishing_well/features/auth/demo/auth_demo.dart' as auth_demo;
import 'package:wishing_well/features/home/demo/home_demo.dart' as home_demo;
import 'package:wishing_well/features/all_wishers/demo/all_wishers_demo.dart'
    as all_wishers_demo;
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

  /// Run the wisher_details feature demo
  wisherDetailsDemo,

  /// Run the all_wishers feature demo
  allWishersDemo,
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
    case AppRunConfig.wisherDetailsDemo:
      await wisher_details_demo.main();
    case AppRunConfig.addWisherDemo:
      await add_wisher_demo.main();
    case AppRunConfig.homeDemo:
      await home_demo.main();
    case AppRunConfig.authDemo:
      await auth_demo.main();
    case AppRunConfig.allWishersDemo:
      await all_wishers_demo.main();
    case AppRunConfig.componentsDemo:
      components_demo.main();
      return;
  }
}

Future<void> _runProduction() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.init();
  await AppConfig.initialize(environment: _environment);
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  final authRepository = AuthRepositoryImpl(
    dataSource: AuthDataSourceSupabase(supabase: Supabase.instance.client),
    emailRedirectTo: AppConfig.accountConfirmUrl,
  );

  final goRouter = router(authRepository: authRepository);
  final deepLinkSource = DeepLinkSource.platform();

  // Supabase processes the password reset deep link internally and emits
  // a passwordRecovery event once the recovery session is established.
  // We navigate to the reset-password screen in response to that event
  // rather than parsing the URI directly, which avoids a race condition
  // where GoRouter processes the initial deep link URL and redirects to
  // /login after our URI-based navigation has already fired.
  final passwordRecoveryStream = Supabase.instance.client.auth.onAuthStateChange
      .where((state) => state.event == AuthChangeEvent.passwordRecovery)
      .map((state) => state.session?.user.email);

  // Detect account confirmation via the deep link source and emit when we
  // get a signup confirmation link. The handler itself will emit to this
  // controller when it detects a valid account-confirm URI (both initial
  // and ongoing streams).
  final accountConfirmationController = StreamController<void>.broadcast();

  final deepLinkHandler = DeepLinkHandler(
    (name, queryParameters) => goRouter.goNamed(
      name,
      queryParameters: queryParameters ?? const <String, dynamic>{},
    ),
    source: deepLinkSource,
    passwordRecovery: passwordRecoveryStream,
    accountConfirmationController: accountConfirmationController,
  );

  final statusOverlayController = StatusOverlayController();

  runApp(
    MultiProvider(
      providers: [
        ...providersRemoteWith(authRepository: authRepository),
        ChangeNotifierProvider.value(value: statusOverlayController),
      ],
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
  StreamSubscription? _authStreamSub;
  StreamSubscription? _accountConfirmationSub;

  @override
  void initState() {
    super.initState();
    // Catch exceptions from Supabase's auth processing of deep links.
    // When an expired/invalid deep link is clicked, Supabase throws an
    // AuthException before we can process the URI, so we subscribe here to
    // suppress those expected errors. Unexpected errors are logged at warning
    // level so they are not silently swallowed.
    _authStreamSub = Supabase.instance.client.auth.onAuthStateChange.listen(
      (_) {
        // Auth state changes are handled by the passwordRecoveryStream above.
      },
      onError: (Object error, StackTrace stackTrace) {
        if (error is AuthException) return;
        AppLogger.error(
          'Unexpected auth stream error',
          context: '_MainAppState.initState',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
    // Delay until after first frame to safely access context and
    // StatusOverlayController for error handling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      final overlayController = context.read<StatusOverlayController>();
      // Use the navigator's context (inside MaterialApp.router's Localizations
      // tree) rather than _MainAppState's context (which is above
      // MaterialApp.router and therefore has no Localizations ancestor).
      widget.deepLinkHandler.setErrorHandler((errorType) {
        final navContext =
            widget.router.routerDelegate.navigatorKey.currentContext;
        if (navContext == null || !navContext.mounted) return;
        final l10n = AppLocalizations.of(navContext);
        if (l10n == null) return;
        // All deep link error types currently show the same message.
        // The typed errorType is passed through for future per-type messages.
        overlayController.showError(l10n.deepLinkError);
      });
      // Subscribe to account confirmation events and show success overlay.
      // Using StatusOverlayController directly avoids a race with GoRouter:
      // by the time the deep link is processed Supabase may have already
      // signed the user in (triggering a redirect to /home), which would
      // discard any query-param navigation to /login. The StatusOverlay wraps
      // the entire app and persists across route changes.
      _accountConfirmationSub = widget
          .deepLinkHandler
          .accountConfirmationController
          ?.stream
          .listen((_) {
            final navContext =
                widget.router.routerDelegate.navigatorKey.currentContext;
            if (navContext == null || !navContext.mounted) return;
            final l10n = AppLocalizations.of(navContext);
            if (l10n == null) return;
            AppLogger.debug(
              'Account confirmation event received, showing success overlay',
              context: '_MainAppState.initState',
            );
            overlayController.showSuccess(
              l10n.accountConfirmationMessage,
              onOk: () {},
            );
          });
      widget.deepLinkHandler.init();
    });
  }

  @override
  void dispose() {
    _authStreamSub?.cancel();
    _accountConfirmationSub?.cancel();
    widget.deepLinkHandler.accountConfirmationController?.close();
    widget.deepLinkHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    builder: (_, child) => StatusOverlay(child: child!),
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
  );
}
