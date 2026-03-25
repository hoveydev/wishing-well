import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wishing_well/config/dependencies.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/components/loading_overlay/loading_overlay.dart';

/// Wrapper for running the app in integration tests.
///
/// Provides a standardized way to set up the app with custom providers
/// for testing different scenarios.
///
/// Example:
/// ```dart
/// final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
/// final wrapper = AppTestWrapper();
/// await binding.run(() => wrapper.setUp());
/// ```
class AppTestWrapper {
  AppTestWrapper({
    this.customProviders,
    this.debugShowCheckedModeBanner = false,
    this.useDarkTheme = false,
  });

  /// Optional custom providers to override the default dependencies
  final List<SingleChildWidget>? customProviders;

  /// Whether to enable debug banner (useful for visual verification)
  final bool debugShowCheckedModeBanner;

  /// Whether to use dark theme
  final bool useDarkTheme;

  late Widget _app;

  /// Sets up the test app - call this once before each test
  Future<void> setUp() async {
    _app = MultiProvider(
      providers: customProviders ?? providersRemote,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        builder: (_, child) => LoadingOverlay(child: child!),
        theme: useDarkTheme ? AppTheme.darkTheme : AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const _TestAppHome(),
      ),
    );
  }

  /// Returns the configured app widget
  Widget get app => _app;

  /// Provides the app via [runApp] - the standard way to launch in
  /// integration tests
  void launch() => runApp(_app);
}

/// Simple home widget for test wrapper
class _TestAppHome extends StatelessWidget {
  const _TestAppHome();

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => LoadingController(),
    child: const Scaffold(body: Center(child: Text('Test App'))),
  );
}
