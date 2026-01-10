import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/throbber/app_throbber.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/screens/loading/loading_overlay.dart';
import 'package:wishing_well/theme/app_theme.dart';

dynamic startAppWithLoadingScreen(
  WidgetTester tester,
  LoadingController loadingController,
) async {
  final ChangeNotifierProvider app =
      ChangeNotifierProvider<LoadingController>.value(
        value: loadingController,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const LoadingOverlay(child: Screen(children: [])),
        ),
      );
  await tester.pumpWidget(app);
  await tester.pump();
}

void main() {
  group('Loading Screen Tests', () {
    late LoadingController loadingController;
    setUp(() {
      loadingController = LoadingController();
    });
    tearDown(() {
      loadingController.dispose();
    });
    testWidgets('renders loading spinner with all elements', (
      WidgetTester tester,
    ) async {
      await startAppWithLoadingScreen(tester, loadingController);
      expect(find.byType(AppThrobber), findsOneWidget);
    });

    testWidgets('loading spinner hidden by defaiult', (
      WidgetTester tester,
    ) async {
      await startAppWithLoadingScreen(tester, loadingController);
      await tester.pump();
      final animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(animatedOpacity.opacity, 0.0);
      expect(animatedOpacity.duration, const Duration(milliseconds: 250));
    });

    testWidgets('loading spinner shows and hides from controller', (
      WidgetTester tester,
    ) async {
      await startAppWithLoadingScreen(tester, loadingController);
      await tester.pump();
      AnimatedOpacity animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(animatedOpacity.opacity, 0.0);
      expect(animatedOpacity.duration, const Duration(milliseconds: 250));
      loadingController.show();
      await tester.pump();
      expect(loadingController.isLoading, true);
      await tester.pump(
        const Duration(milliseconds: 250),
      ); // wait for animation to complete
      animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(animatedOpacity.opacity, 1.0);
      expect(animatedOpacity.duration, const Duration(milliseconds: 250));
      loadingController.hide();
      await tester.pump();
      expect(loadingController.isLoading, false);
      await tester.pump(
        const Duration(milliseconds: 250),
      ); // wait for animation to complete
      animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(animatedOpacity.opacity, 0.0);
      expect(animatedOpacity.duration, const Duration(milliseconds: 250));
    });

    testWidgets('IgnorePointer blocks interactions when loading', (
      WidgetTester tester,
    ) async {
      await startAppWithLoadingScreen(tester, loadingController);
      await tester.pump();
      loadingController.show();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      final ignorePointer = tester.widget<IgnorePointer>(
        find.byType(IgnorePointer).last,
      );
      expect(ignorePointer.ignoring, false);
    });

    testWidgets('IgnorePointer allows interactions when not loading', (
      WidgetTester tester,
    ) async {
      await startAppWithLoadingScreen(tester, loadingController);
      await tester.pump();
      loadingController.hide();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      final ignorePointer = tester.widget<IgnorePointer>(
        find.byType(IgnorePointer).last,
      );
      expect(ignorePointer.ignoring, true);
    });
  });
}
