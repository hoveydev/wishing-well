import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/throbber/app_throbber.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/screens/loading/loading_overlay.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('LoadingOverlay', () {
    late LoadingController loadingController;

    setUp(() {
      loadingController = LoadingController();
    });

    tearDown(() {
      loadingController.dispose();
    });

    group(TestGroups.initialState, () {
      testWidgets(
        'renders child content and hidden throbber when not loading',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            createScreenTestWidget(
              loadingController: loadingController,
              child: const LoadingOverlay(
                child: Screen(children: [Text('Test Content')]),
              ),
            ),
          );
          await tester.pump();

          // Child content should be visible
          TestHelpers.expectTextOnce('Test Content');
          TestHelpers.expectWidgetOnce(Screen);

          // Loading overlay should be present but hidden
          TestHelpers.expectWidgetOnce(AppThrobber);
        },
      );

      testWidgets(
        'AnimatedOpacity has 0.0 opacity when loading controller is initial',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            createScreenTestWidget(
              loadingController: loadingController,
              child: const LoadingOverlay(child: Screen(children: [])),
            ),
          );
          await tester.pump();

          expect(loadingController.isLoading, false);

          final animatedOpacity = tester.widget<AnimatedOpacity>(
            find.byType(AnimatedOpacity),
          );
          expect(animatedOpacity.opacity, 0.0);
          expect(animatedOpacity.duration, const Duration(milliseconds: 250));
        },
      );
    });

    group(TestGroups.stateChanges, () {
      testWidgets('AnimatedOpacity transitions to 1.0 '
          'opacity when controller show() is called', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: loadingController,
            child: const LoadingOverlay(child: Screen(children: [])),
          ),
        );
        await tester.pump();

        // Initially hidden
        expect(loadingController.isLoading, false);
        var animatedOpacity = tester.widget<AnimatedOpacity>(
          find.byType(AnimatedOpacity),
        );
        expect(animatedOpacity.opacity, 0.0);

        // Show loading
        loadingController.show();
        await tester.pump();
        expect(loadingController.isLoading, true);

        // Wait for animation to complete
        await tester.pump(const Duration(milliseconds: 250));

        animatedOpacity = tester.widget<AnimatedOpacity>(
          find.byType(AnimatedOpacity),
        );
        expect(animatedOpacity.opacity, 1.0);
        expect(animatedOpacity.duration, const Duration(milliseconds: 250));
      });

      testWidgets('AnimatedOpacity transitions to 0.0 '
          'opacity when controller hide() is called', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: loadingController,
            child: const LoadingOverlay(child: Screen(children: [])),
          ),
        );
        await tester.pump();

        // Start with loading shown
        loadingController.show();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 250));
        expect(loadingController.isLoading, true);

        var animatedOpacity = tester.widget<AnimatedOpacity>(
          find.byType(AnimatedOpacity),
        );
        expect(animatedOpacity.opacity, 1.0);

        // Hide loading
        loadingController.hide();
        await tester.pump();
        expect(loadingController.isLoading, false);

        // Wait for animation to complete
        await tester.pump(const Duration(milliseconds: 250));

        animatedOpacity = tester.widget<AnimatedOpacity>(
          find.byType(AnimatedOpacity),
        );
        expect(animatedOpacity.opacity, 0.0);
        expect(animatedOpacity.duration, const Duration(milliseconds: 250));
      });
    });

    group(TestGroups.interaction, () {
      testWidgets(
        'IgnorePointer ignoring property is false when loading is active',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            createScreenTestWidget(
              loadingController: loadingController,
              child: const LoadingOverlay(child: Screen(children: [])),
            ),
          );
          await tester.pump();

          // Show loading
          loadingController.show();
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 250));

          final ignorePointer = tester.widget<IgnorePointer>(
            find.byType(IgnorePointer).last,
          );
          expect(ignorePointer.ignoring, false);
        },
      );

      testWidgets(
        'IgnorePointer ignoring property is true when loading is inactive',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            createScreenTestWidget(
              loadingController: loadingController,
              child: const LoadingOverlay(child: Screen(children: [])),
            ),
          );
          await tester.pump();

          // Ensure loading is hidden
          loadingController.hide();
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 250));

          final ignorePointer = tester.widget<IgnorePointer>(
            find.byType(IgnorePointer).last,
          );
          expect(ignorePointer.ignoring, true);
        },
      );
    });

    group(TestGroups.behavior, () {
      testWidgets('Semantics label is set to Loading when overlay is visible', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: loadingController,
            child: const LoadingOverlay(child: Screen(children: [])),
          ),
        );
        await tester.pump();

        loadingController.show();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 250));

        // Check for accessibility label
        final semanticsFinder = find.bySemanticsLabel('Loading');
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('renders exactly one AppThrobber.xlarge '
          'component regardless of visibility state', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: loadingController,
            child: const LoadingOverlay(child: Screen(children: [])),
          ),
        );
        await tester.pump();

        // Verify the AppThrobber component exists
        expect(find.byType(AppThrobber), findsOneWidget);

        // Show loading to make it visible
        loadingController.show();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 250));

        // Should still be exactly one AppThrobber
        expect(find.byType(AppThrobber), findsOneWidget);
      });
    });
  });
}
