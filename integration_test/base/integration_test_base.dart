import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wishing_well/config/dependencies.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';
import 'package:wishing_well/components/status_overlay/status_overlay.dart';

/// Base class for integration tests.
///
/// Provides common setup and teardown logic for all integration tests,
/// including proper app initialization with optional custom providers.
///
/// Example:
/// ```dart
/// class MyIntegrationTest extends IntegrationTestBase {
///   @override
///   List<SingleChildWidget>? get customProviders => [...];
///
///   testWidgets('my test', (WidgetTester tester) async {
///     await setUp(tester);
///     // test logic
///   });
/// }
/// ```
abstract class IntegrationTestBase {
  /// Optional custom providers to override the default dependencies
  /// Override this in subclasses to provide custom mocks
  List<SingleChildWidget>? get customProviders => null;

  /// Whether to enable debug banner (useful for visual verification)
  bool get debugShowCheckedModeBanner => false;

  /// Whether to use dark theme
  bool get useDarkTheme => false;

  /// The binding for the integration test
  late IntegrationTestWidgetsFlutterBinding binding;

  /// Sets up the integration test - call this in setUp or before each test
  Future<void> setUp(WidgetTester tester) async {
    binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    final app = MultiProvider(
      providers: customProviders ?? providersRemote,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        builder: (_, child) => StatusOverlay(child: child!),
        theme: useDarkTheme ? AppTheme.darkTheme : AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: _TestHome(controller: StatusOverlayController()),
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
  }

  /// Tears down the integration test - call this in tearDown or after each test
  Future<void> tearDown(WidgetTester tester) async {
    // Clean up resources if needed
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  }
}

/// Default home widget used in test base
class _TestHome extends StatelessWidget {
  const _TestHome({required this.controller});

  final StatusOverlayController controller;

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<StatusOverlayController>.value(
        value: controller,
        child: const Scaffold(body: Center(child: Text('Integration Test'))),
      );
}

/// Convenience mixin for tests that need common integration test utilities
mixin IntegrationTestMixin on WidgetTester {
  /// Wait for a specific duration - useful for animations or network delays
  Future<void> wait([
    Duration duration = const Duration(milliseconds: 500),
  ]) async {
    await pump(duration);
    await pumpAndSettle();
  }

  /// Wait until a condition is met or timeout is reached
  Future<void> waitUntil(
    bool Function() condition, {
    int maxIterations = 50,
  }) async {
    for (var i = 0; i < maxIterations; i++) {
      await pumpAndSettle();
      if (condition()) return;
      await pump(const Duration(milliseconds: 100));
    }
  }

  /// Pump and settle with animation duration
  Future<void> pumpWithAnimation() async {
    await pump();
    await pump(const Duration(milliseconds: 500));
    await pumpAndSettle();
  }
}
