import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/wishers/wishers_list_skeleton.dart';
import 'package:wishing_well/components/throbber/skeleton_loader.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('WishersListSkeleton', () {
    group(TestGroups.rendering, () {
      testWidgets('renders skeleton correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const SizedBox(height: 80, child: WishersListSkeleton()),
          ),
        );
        await tester.pump();

        TestHelpers.expectWidgetOnce(WishersListSkeleton);
      });

      testWidgets('renders SkeletonLoader widgets', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const SizedBox(height: 80, child: WishersListSkeleton()),
          ),
        );
        await tester.pump();

        // Each _WisherSkeletonItem has 2 SkeletonLoaders (circle + rectangle)
        // 5 items * 2 loaders = 10 SkeletonLoaders
        expect(find.byType(SkeletonLoader), findsNWidgets(10));
      });

      testWidgets('renders as horizontal ListView', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const SizedBox(height: 80, child: WishersListSkeleton()),
          ),
        );
        await tester.pump();

        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView.scrollDirection, Axis.horizontal);
      });

      testWidgets('has correct horizontal padding', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const SizedBox(height: 80, child: WishersListSkeleton()),
          ),
        );
        await tester.pump();

        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView.padding, const EdgeInsets.symmetric(horizontal: 24));
      });

      testWidgets('renders circle skeleton loaders', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const SizedBox(height: 80, child: WishersListSkeleton()),
          ),
        );
        await tester.pump();

        // Find skeleton loaders and verify they render
        final skeletonLoaders = tester.widgetList<SkeletonLoader>(
          find.byType(SkeletonLoader),
        );

        // At least some should be circles (5 circle loaders for the items)
        final circleLoaders = skeletonLoaders.where(
          (loader) => loader.shape == SkeletonShape.circle,
        );
        expect(circleLoaders.length, 5);
      });

      testWidgets('renders rounded rectangle skeleton loaders', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const SizedBox(height: 80, child: WishersListSkeleton()),
          ),
        );
        await tester.pump();

        final skeletonLoaders = tester.widgetList<SkeletonLoader>(
          find.byType(SkeletonLoader),
        );

        // 5 rounded rectangle loaders for the names
        final rectangleLoaders = skeletonLoaders.where(
          (loader) => loader.shape == SkeletonShape.roundedRectangle,
        );
        expect(rectangleLoaders.length, 5);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('animates continuously', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const SizedBox(height: 80, child: WishersListSkeleton()),
          ),
        );

        // Pump multiple frames to verify animation runs
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 500));

        // Widget should still be present after animation
        expect(find.byType(WishersListSkeleton), findsOneWidget);
        expect(find.byType(SkeletonLoader), findsNWidgets(10));
      });

      testWidgets('renders with correct dimensions', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const SizedBox(height: 80, child: WishersListSkeleton()),
          ),
        );
        await tester.pump();

        final skeletonLoaders = tester.widgetList<SkeletonLoader>(
          find.byType(SkeletonLoader),
        );

        // Circle loaders should be 60x60
        final circleLoaders = skeletonLoaders.where(
          (loader) => loader.shape == SkeletonShape.circle,
        );
        for (final loader in circleLoaders) {
          expect(loader.width, 60);
          expect(loader.height, 60);
        }

        // Rectangle loaders should be 40x14
        final rectangleLoaders = skeletonLoaders.where(
          (loader) => loader.shape == SkeletonShape.roundedRectangle,
        );
        for (final loader in rectangleLoaders) {
          expect(loader.width, 40);
          expect(loader.height, 14);
        }
      });
    });

    group(TestGroups.initialState, () {
      testWidgets('initializes correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            const SizedBox(height: 80, child: WishersListSkeleton()),
          ),
        );
        await tester.pump();

        // Should render without errors
        expect(find.byType(WishersListSkeleton), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(SkeletonLoader), findsNWidgets(10));
      });
    });
  });
}
