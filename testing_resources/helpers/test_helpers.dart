import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';

/// Standardized test wrapper for component tests
Widget createComponentTestWidget(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  home: Screen(children: [child]),
);

/// Standardized test wrapper for component tests
Widget createScreenComponentTestWidget(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: Screen(children: [child]),
);

/// Standardized test wrapper for screen tests with localization
Widget createScreenTestWidget({
  required Widget child,
  LoadingController? loadingController,
}) {
  final controller = loadingController ?? LoadingController();

  return ChangeNotifierProvider<LoadingController>.value(
    value: controller,
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

/// Common finder patterns for frequently used widgets
class CommonFinders {
  static Finder findByText(String text) => find.text(text);
  static Finder findByType(Type type) => find.byType(type);
  static Finder findByWidgetPredicate(bool Function(Widget) predicate) =>
      find.byWidgetPredicate(predicate);
  static Finder findByKey(Key key) => find.byKey(key);
}

/// Common test utilities
class TestHelpers {
  /// Pump widget and settle with standard timing
  static Future<void> pumpAndSettle(WidgetTester tester) async {
    await tester.pumpAndSettle();
  }

  /// Enter text into a widget and settle
  static Future<void> enterTextAndSettle(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }

  /// Tap widget and settle
  static Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Verify text exists exactly once
  static void expectTextOnce(String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Verify text exists multiple times
  static void expectTextTimes(String text, int count) {
    expect(find.text(text), findsNWidgets(count));
  }

  /// Verify widget type exists exactly once
  static void expectWidgetOnce(Type type) {
    expect(find.byType(type), findsOneWidget);
  }
}

/// Standardized group naming conventions
abstract class TestGroups {
  static const String component = 'Component';
  static const String rendering = 'Rendering';
  static const String interaction = 'Interaction';
  static const String behavior = 'Behavior';
  static const String errorHandling = 'Error Handling';
  static const String initialState = 'Initial State';
  static const String stateChanges = 'State Changes';
  static const String validation = 'Validation';
  static const String accessibility = 'Accessibility';
}
