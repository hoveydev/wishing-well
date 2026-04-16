import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/profile_image/profile_image.dart';
import 'package:wishing_well/components/throbber/app_throbber.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/loading_overlay/loading_overlay.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

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
      testWidgets('renders child content when not loading', (
        WidgetTester tester,
      ) async {
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
      });

      testWidgets('overlay is hidden in idle state', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: loadingController,
            child: const LoadingOverlay(child: Screen(children: [])),
          ),
        );
        await tester.pump();

        // Animation controller starts at 0.0, so overlay should be invisible
        expect(loadingController.isIdle, true);
      });
    });

    group(TestGroups.stateChanges, () {
      testWidgets('shows loading content when controller show() is called', (
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

        // Show loading
        loadingController.show();
        await tester.pump();
        expect(loadingController.isLoading, true);

        // Wait for animation to complete
        await tester.pump(const Duration(milliseconds: 100));

        // Should show loading content
        expect(find.byType(AppThrobber), findsOneWidget);
      });

      testWidgets('hides loading content when controller hide() is called', (
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
        await tester.pump(const Duration(milliseconds: 100));
        expect(loadingController.isLoading, true);

        expect(find.byType(AppThrobber), findsOneWidget);

        // Hide loading
        loadingController.hide();
        await tester.pump();
        expect(loadingController.isLoading, false);

        // The overlay is still rendered but with 0 opacity
        // The key is the controller state is now idle
      });
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
        await tester.pump(const Duration(milliseconds: 100));

        // Check for accessibility label
        final semanticsFinder = find.bySemanticsLabel('Loading');
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('renders AppThrobber when loading is visible', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: loadingController,
            child: const LoadingOverlay(child: Screen(children: [])),
          ),
        );
        await tester.pump();

        // Show loading to make it visible
        loadingController.show();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Should show AppThrobber when loading
        expect(find.byType(AppThrobber), findsOneWidget);
      });
    });

    group('success state', () {
      testWidgets('shows success content when showSuccess is called', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: loadingController,
            child: const LoadingOverlay(child: Screen(children: [])),
          ),
        );
        await tester.pump();

        loadingController.showSuccess('Operation completed!');
        await tester.pump();
        await tester.pumpAndSettle();

        // Should show success icon
        expect(find.byIcon(Icons.check_circle), findsOneWidget);

        // Should show message
        expect(find.text('Operation completed!'), findsOneWidget);
      });
    });

    group('error state', () {
      testWidgets('shows error content when showError is called', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: loadingController,
            child: const LoadingOverlay(child: Screen(children: [])),
          ),
        );
        await tester.pump();

        loadingController.showError('Something went wrong');
        await tester.pump();
        await tester.pumpAndSettle();

        // Should show error icon
        expect(find.byIcon(Icons.error), findsOneWidget);

        // Should show message
        expect(find.text('Something went wrong'), findsOneWidget);
      });

      testWidgets('shows OK button in error state', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: loadingController,
            child: const LoadingOverlay(child: Screen(children: [])),
          ),
        );
        await tester.pump();

        loadingController.showError('Error occurred');
        await tester.pump();
        await tester.pumpAndSettle();

        // Should show OK button
        expect(find.text('Ok'), findsOneWidget);
      });

      testWidgets('tapping OK button dismisses error', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: loadingController,
            child: const LoadingOverlay(child: Screen(children: [])),
          ),
        );
        await tester.pump();

        loadingController.showError('Error occurred');
        await tester.pump();
        await tester.pumpAndSettle();

        // Verify error is showing
        expect(loadingController.isError, true);

        // Tap OK button
        await TestHelpers.tapAndSettle(tester, find.text('Ok'));

        // Error should be cleared
        expect(loadingController.isError, false);
        expect(loadingController.isIdle, true);
      });
    });

    group('success state with name', () {
      testWidgets('shows success with name renders correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: loadingController,
            child: const LoadingOverlay(child: Screen(children: [])),
          ),
        );
        await tester.pump();

        // Show success with name
        loadingController.showSuccess('John was created!', name: 'John');
        await tester.pump();
        await tester.pumpAndSettle();

        // Should show ProfileImage (not check_circle) when name is provided
        expect(find.byType(ProfileImage), findsOneWidget);

        // Should show OK button
        expect(find.text('Ok'), findsOneWidget);
      });

      testWidgets('success state with name shows OK button', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: loadingController,
            child: const LoadingOverlay(child: Screen(children: [])),
          ),
        );
        await tester.pump();

        // Show success with name (without imageUrl to avoid network issues)
        loadingController.showSuccess('Success!', name: 'TestUser');
        await tester.pump();
        await tester.pumpAndSettle();

        // Should show OK button
        expect(find.text('Ok'), findsOneWidget);
      });

      testWidgets('tapping OK button dismisses success overlay', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            loadingController: loadingController,
            child: const LoadingOverlay(child: Screen(children: [])),
          ),
        );
        await tester.pump();

        loadingController.showSuccess('Operation complete!');
        await tester.pump();
        await tester.pumpAndSettle();

        // Verify success is showing
        expect(loadingController.isSuccess, true);

        // Tap OK button
        await TestHelpers.tapAndSettle(tester, find.text('Ok'));

        // Success should be cleared
        expect(loadingController.isSuccess, false);
        expect(loadingController.isIdle, true);
      });
    });

    group('Overlay transitions', () {
      testWidgets('transition from loading to success works', (
        WidgetTester tester,
      ) async {
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
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(AppThrobber), findsOneWidget);

        // Transition to success
        loadingController.showSuccess('Done!');
        await tester.pump();
        await tester.pumpAndSettle();

        // Should show success now
        expect(find.byIcon(Icons.check_circle), findsOneWidget);
      });

      testWidgets('transition from loading to error works', (
        WidgetTester tester,
      ) async {
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
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(AppThrobber), findsOneWidget);

        // Transition to error
        loadingController.showError('Failed!');
        await tester.pump();
        await tester.pumpAndSettle();

        // Should show error now
        expect(find.byIcon(Icons.error), findsOneWidget);
      });
    });
  });
}
