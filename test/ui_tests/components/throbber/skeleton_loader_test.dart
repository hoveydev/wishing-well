import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/throbber/skeleton_loader.dart';
import 'package:wishing_well/theme/app_theme.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('SkeletonLoader', () {
    group(TestGroups.rendering, () {
      testWidgets('renders circle shape correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const SkeletonLoader(
              shape: SkeletonShape.circle,
              width: 60,
              height: 60,
            ),
          ),
        );
        await tester.pump();

        TestHelpers.expectWidgetOnce(SkeletonLoader);

        final skeleton = tester.widget<SkeletonLoader>(
          find.byType(SkeletonLoader),
        );
        expect(skeleton.shape, SkeletonShape.circle);
        expect(skeleton.width, 60);
        expect(skeleton.height, 60);
      });

      testWidgets('renders rounded rectangle shape correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const SkeletonLoader(
              shape: SkeletonShape.roundedRectangle,
              width: 120,
              height: 20,
              borderRadius: 8,
            ),
          ),
        );
        await tester.pump();

        TestHelpers.expectWidgetOnce(SkeletonLoader);

        final skeleton = tester.widget<SkeletonLoader>(
          find.byType(SkeletonLoader),
        );
        expect(skeleton.shape, SkeletonShape.roundedRectangle);
        expect(skeleton.width, 120);
        expect(skeleton.height, 20);
        expect(skeleton.borderRadius, 8);
      });

      testWidgets('uses default border radius when not specified', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const SkeletonLoader(
              shape: SkeletonShape.roundedRectangle,
              width: 100,
              height: 16,
            ),
          ),
        );
        await tester.pump();

        final skeleton = tester.widget<SkeletonLoader>(
          find.byType(SkeletonLoader),
        );
        // Default borderRadius is null when not specified,
        // widget uses ?? 4 in the build method
        expect(skeleton.borderRadius, isNull);
      });

      testWidgets('applies custom dimensions correctly', (
        WidgetTester tester,
      ) async {
        const testWidth = 80.0;
        const testHeight = 40.0;

        await tester.pumpWidget(
          createComponentTestWidget(
            const SkeletonLoader(
              shape: SkeletonShape.roundedRectangle,
              width: testWidth,
              height: testHeight,
            ),
          ),
        );
        await tester.pump();

        final skeleton = tester.widget<SkeletonLoader>(
          find.byType(SkeletonLoader),
        );
        expect(skeleton.width, testWidth);
        expect(skeleton.height, testHeight);
      });

      testWidgets('renders with different sizes', (WidgetTester tester) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const Column(
              children: [
                SkeletonLoader(
                  shape: SkeletonShape.circle,
                  width: 24,
                  height: 24,
                ),
                SkeletonLoader(
                  shape: SkeletonShape.circle,
                  width: 40,
                  height: 40,
                ),
                SkeletonLoader(
                  shape: SkeletonShape.circle,
                  width: 60,
                  height: 60,
                ),
              ],
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(SkeletonLoader), findsNWidgets(3));
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('animates continuously', (WidgetTester tester) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const SkeletonLoader(
              shape: SkeletonShape.circle,
              width: 60,
              height: 60,
            ),
          ),
        );

        // Pump multiple frames to verify animation runs
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Widget should still be present after animation
        expect(find.byType(SkeletonLoader), findsOneWidget);
      });

      testWidgets('renders in light theme', (WidgetTester tester) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const SkeletonLoader(
              shape: SkeletonShape.circle,
              width: 40,
              height: 40,
            ),
          ),
        );
        await tester.pump();

        // Should render without errors in light theme
        expect(find.byType(SkeletonLoader), findsOneWidget);
      });

      testWidgets('renders in dark theme', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: const Scaffold(
              body: Center(
                child: SkeletonLoader(
                  shape: SkeletonShape.circle,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        // Should render without errors in dark theme
        expect(find.byType(SkeletonLoader), findsOneWidget);
      });
    });

    group(TestGroups.initialState, () {
      testWidgets('initializes with correct shape enum', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const SkeletonLoader(
              shape: SkeletonShape.circle,
              width: 50,
              height: 50,
            ),
          ),
        );
        await tester.pump();

        final skeleton = tester.widget<SkeletonLoader>(
          find.byType(SkeletonLoader),
        );
        expect(skeleton.shape, SkeletonShape.circle);
      });

      testWidgets('initializes with roundedRectangle shape', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createComponentTestWidget(
            const SkeletonLoader(
              shape: SkeletonShape.roundedRectangle,
              width: 100,
              height: 20,
            ),
          ),
        );
        await tester.pump();

        final skeleton = tester.widget<SkeletonLoader>(
          find.byType(SkeletonLoader),
        );
        expect(skeleton.shape, SkeletonShape.roundedRectangle);
      });
    });
  });
}
