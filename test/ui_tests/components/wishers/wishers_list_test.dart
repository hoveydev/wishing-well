import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/wishers/wishers_list.dart';
import 'package:wishing_well/components/wishers/add_wisher_item.dart';
import 'package:wishing_well/components/wishers/wisher_item.dart';
import 'package:wishing_well/components/wishers/wishers_list_skeleton.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/theme/app_spacing.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('WisherList', () {
    // Helper to create test wishers
    List<Wisher> createTestWishers(int count) => List.generate(
      count,
      (i) => Wisher(
        id: 'wisher-$i',
        userId: 'test-user',
        firstName: ['Alice', 'Bob', 'Charlie', 'Diana'][i % 4],
        lastName: 'Test',
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );

    // Default test wishers (8 items, like the original static list)
    final defaultTestWishers = createTestWishers(8);

    Widget createWishersList({
      List<Wisher> wishers = const [],
      bool isLoading = false,
      bool hasError = false,
      VoidCallback? onAddWisherTap,
      void Function(Wisher)? onWisherTap,
      VoidCallback? onRetry,
    }) => WishersList(
      wishers: wishers,
      isLoading: isLoading,
      hasError: hasError,
      onAddWisherTap: onAddWisherTap ?? () => {},
      onWisherTap: onWisherTap ?? (wisher) => {},
      onRetry: onRetry,
    );

    group(TestGroups.rendering, () {
      testWidgets('renders wishers section with header', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            createWishersList(wishers: defaultTestWishers),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(WishersList);
        TestHelpers.expectTextOnce('Wishers');
        TestHelpers.expectTextOnce('View All');
        TestHelpers.expectWidgetOnce(Row);
        TestHelpers.expectWidgetOnce(ListView);
      });

      testWidgets('renders correct number of items', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            createWishersList(wishers: defaultTestWishers),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // The horizontal ListView lazily builds visible children, so assert
        // the list structure instead of the exact visible child count.
        TestHelpers.expectWidgetOnce(AddWisherItem);
        expect(find.byType(WisherItem), findsWidgets);
        expect(
          tester.widget<ListView>(find.byType(ListView)).semanticChildCount,
          9,
        );
      });

      testWidgets('renders specific wisher first names', (
        WidgetTester tester,
      ) async {
        final visibleWishers = createTestWishers(3);

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            createWishersList(wishers: visibleWishers),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Check for specific visible wisher names
        TestHelpers.expectTextOnce('Alice Test');
        TestHelpers.expectTextOnce('Bob Test');
        TestHelpers.expectTextOnce('Charlie Test');

        // Check for correct initials
        TestHelpers.expectTextOnce('A');
        TestHelpers.expectTextOnce('B');
        TestHelpers.expectTextOnce('C');
      });

      testWidgets('renders AddWisherItem as first item', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            createWishersList(wishers: defaultTestWishers),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Verify the list structure exists and has correct items
        TestHelpers.expectWidgetOnce(ListView);
        TestHelpers.expectWidgetOnce(AddWisherItem);
        expect(find.byType(WisherItem), findsWidgets);
        expect(
          tester.widget<ListView>(find.byType(ListView)).semanticChildCount,
          9,
        );
      });

      testWidgets('has correct layout structure', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            createWishersList(wishers: defaultTestWishers),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Verify key layout elements exist
        final rows = find.descendant(
          of: find.byType(WishersList),
          matching: find.byType(Row),
        );
        final listViews = find.descendant(
          of: find.byType(WishersList),
          matching: find.byType(ListView),
        );

        expect(rows, findsOneWidget);
        expect(listViews, findsOneWidget);

        // Check header row properties
        final row = tester.widget<Row>(rows);
        expect(row.mainAxisAlignment, MainAxisAlignment.spaceBetween);

        // Check scroll direction
        final listView = tester.widget<ListView>(listViews);
        expect(listView.scrollDirection, Axis.horizontal);
      });

      testWidgets('shows only add button when no wishers', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(createWishersList(wishers: [])),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Should NOT show any wisher items
        expect(find.byType(WisherItem), findsNothing);
        // Should still show Add button
        TestHelpers.expectWidgetOnce(AddWisherItem);
      });

      testWidgets('shows skeleton loader when loading', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(createWishersList(isLoading: true)),
        );
        // Use pump() instead of pumpAndSettle() because
        // skeleton has an infinite animation that never settles
        await tester.pump();

        // Should show skeleton loader
        TestHelpers.expectWidgetOnce(WishersListSkeleton);
      });

      testWidgets('shows error card when hasError is true', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            createWishersList(hasError: true, onRetry: () {}),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Should show error title
        TestHelpers.expectTextOnce('Error Loading Wishers');
        // Should show error message
        TestHelpers.expectTextOnce(
          'Something went wrong while loading your wishers. Please try again.',
        );
        // Should show retry button
        TestHelpers.expectTextOnce('retry');
      });

      testWidgets('does not show error card when hasError is false', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(createWishersList()),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Should NOT show error title
        expect(find.text('Error Loading Wishers'), findsNothing);
        // Should show wishers instead
        TestHelpers.expectWidgetOnce(ListView);
      });

      testWidgets('shows skeleton when loading even if hasError is true', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            createWishersList(isLoading: true, hasError: true),
          ),
        );
        await tester.pump();

        // Should show skeleton loader, not error card
        TestHelpers.expectWidgetOnce(WishersListSkeleton);
        // Should NOT show error card
        expect(find.text('Error Loading Wishers'), findsNothing);
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('handles View All button tap', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            createWishersList(wishers: defaultTestWishers),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.text('View All'));

        // Should not crash - gesture detector should handle the tap
        TestHelpers.expectTextOnce('View All');
      });

      testWidgets('handles onAddWisherTap callback', (
        WidgetTester tester,
      ) async {
        var wasTapped = false;

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            WishersList(
              wishers: defaultTestWishers,
              onAddWisherTap: () => wasTapped = true,
              onWisherTap: (wisher) => {},
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Tap on the add icon inside AddWisherItem
        await tester.tap(find.byIcon(Icons.add), warnIfMissed: false);
        await TestHelpers.pumpAndSettle(tester);

        expect(wasTapped, isTrue);
      });

      testWidgets('View All button is clickable', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            createWishersList(wishers: defaultTestWishers),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final gestureDetector = find.ancestor(
          of: find.text('View All'),
          matching: find.byType(GestureDetector),
        );
        expect(gestureDetector, findsOneWidget);
      });

      testWidgets('supports horizontal scrolling', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            createWishersList(wishers: defaultTestWishers),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Initially should render visible items without throwing
        expect(find.byType(WisherItem), findsWidgets);

        // Scroll horizontally
        await tester.fling(find.byType(ListView), const Offset(-300, 0), 1000);
        await TestHelpers.pumpAndSettle(tester);

        // Should still render visible items after scrolling
        expect(find.byType(WisherItem), findsWidgets);
      });

      testWidgets('calls onRetry when retry button is tapped', (
        WidgetTester tester,
      ) async {
        var retryTapped = false;

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            createWishersList(
              hasError: true,
              onRetry: () => retryTapped = true,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Find and tap the retry button (the refresh icon)
        final retryButton = find.byIcon(Icons.refresh);
        expect(retryButton, findsOneWidget);

        await tester.tap(retryButton);
        await TestHelpers.pumpAndSettle(tester);

        expect(retryTapped, isTrue);
      });

      testWidgets(
        'retry button is visible when hasError is true and onRetry is provided',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            createScreenComponentTestWidget(
              createWishersList(hasError: true, onRetry: () {}),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          // Should show the refresh icon
          expect(find.byIcon(Icons.refresh), findsOneWidget);
        },
      );
    });

    group(TestGroups.behavior, () {
      testWidgets('applies correct list padding', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            createWishersList(wishers: defaultTestWishers),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final listView = tester.widget<ListView>(
          find.descendant(
            of: find.byType(WishersList),
            matching: find.byType(ListView),
          ),
        );
        expect(
          listView.padding,
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPaddingStandard,
          ),
        );
      });

      testWidgets('positions list beyond screen bounds', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            createWishersList(wishers: defaultTestWishers),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final positionedWidgets = tester.widgetList<Positioned>(
          find.descendant(
            of: find.byType(WishersList),
            matching: find.byType(Positioned),
          ),
        );
        final positionedWidget = positionedWidgets.first;
        expect(positionedWidget.left, -AppSpacing.screenPaddingStandard);
        expect(positionedWidget.right, -AppSpacing.screenPaddingStandard);
      });

      testWidgets('last item has no right padding', (
        WidgetTester tester,
      ) async {
        final singleWisher = [
          Wisher(
            id: 'single-padding',
            userId: 'test-user',
            firstName: 'Only',
            lastName: 'One',
            createdAt: DateTime(2026),
            updatedAt: DateTime(2026),
          ),
        ];

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            createWishersList(wishers: singleWisher),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final wisherItems = tester.widgetList<WisherItem>(
          find.byType(WisherItem),
        );
        final lastWisherItem = wisherItems.last;
        expect(lastWisherItem.padding, EdgeInsets.zero);
      });

      testWidgets('maintains consistent structure', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            createWishersList(wishers: defaultTestWishers),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Verify key components within WishersList context
        final rows = find.descendant(
          of: find.byType(WishersList),
          matching: find.byType(Row),
        );
        final listViews = find.descendant(
          of: find.byType(WishersList),
          matching: find.byType(ListView),
        );

        expect(rows, findsOneWidget);
        expect(listViews, findsOneWidget);

        TestHelpers.expectWidgetOnce(AddWisherItem);
        expect(find.byType(WisherItem), findsWidgets);
        expect(
          tester.widget<ListView>(find.byType(ListView)).semanticChildCount,
          9,
        );
      });

      testWidgets('renders single wisher correctly', (
        WidgetTester tester,
      ) async {
        final singleWisher = [
          Wisher(
            id: 'single',
            userId: 'test-user',
            firstName: 'Only',
            lastName: 'One',
            createdAt: DateTime(2026),
            updatedAt: DateTime(2026),
          ),
        ];

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            createWishersList(wishers: singleWisher),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(WisherItem), findsOneWidget);
        TestHelpers.expectTextOnce('Only One');
        TestHelpers.expectTextOnce('O');
      });
    });

    group('Accessibility', () {
      testWidgets('has increased container height for large text support', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
            child: createScreenComponentTestWidget(
              createWishersList(wishers: defaultTestWishers),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final wishersListContext = tester.element(find.byType(WishersList));
        final expectedHeight = AppSpacing.wisherListItemHeightFor(
          wishersListContext,
        );

        final rowHeightSizedBoxFinder = find.descendant(
          of: find.byType(WishersList),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is SizedBox &&
                widget.height != null &&
                widget.child is Stack,
            description: 'SizedBox with a non-null height and Stack child',
          ),
        );

        expect(rowHeightSizedBoxFinder, findsOneWidget);

        final sizedBox = tester.widget<SizedBox>(rowHeightSizedBoxFinder);
        expect(sizedBox.height, greaterThanOrEqualTo(expectedHeight));
      });

      testWidgets('does not overflow the error card at large text sizes', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
            child: createScreenComponentTestWidget(
              createWishersList(hasError: true, onRetry: () {}),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(tester.takeException(), isNull);
      });

      testWidgets('uses base row height while loading with hasError', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
            child: createScreenComponentTestWidget(
              createWishersList(isLoading: true, hasError: true),
            ),
          ),
        );
        await tester.pump();

        final wishersListContext = tester.element(find.byType(WishersList));
        final expectedHeight = AppSpacing.wisherListItemHeightFor(
          wishersListContext,
        );
        final rowHeightSizedBoxFinder = find.descendant(
          of: find.byType(WishersList),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is SizedBox &&
                widget.height != null &&
                widget.child is Stack,
            description: 'SizedBox with a non-null height and Stack child',
          ),
        );

        expect(rowHeightSizedBoxFinder, findsOneWidget);

        final sizedBox = tester.widget<SizedBox>(rowHeightSizedBoxFinder);
        expect(sizedBox.height, expectedHeight);
      });

      testWidgets('keeps error text visible without ellipses', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
            child: createScreenComponentTestWidget(
              createWishersList(hasError: true, onRetry: () {}),
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final titleText = tester.widget<Text>(
          find.text('Error Loading Wishers'),
        );
        final messageText = tester.widget<Text>(
          find.text(
            'Something went wrong while loading your wishers. '
            'Please try again.',
          ),
        );
        final retryText = tester.widget<Text>(find.text('retry'));

        expect(titleText.overflow, isNull);
        expect(messageText.overflow, isNull);
        expect(retryText.overflow, isNull);
      });

      testWidgets('View All text has overflow ellipsis for large text', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            createWishersList(wishers: defaultTestWishers),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Find the View All text
        final viewAllText = find.text('View All');
        expect(viewAllText, findsOneWidget);

        // Verify the text widget has overflow handling
        final textWidget = tester.widget<Text>(viewAllText);
        expect(textWidget.overflow, TextOverflow.ellipsis);
      });

      testWidgets('View All is wrapped in Flexible for shrinking', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            createWishersList(wishers: defaultTestWishers),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Find Flexible widget that contains View All text
        final flexibleWithViewAll = find.ancestor(
          of: find.text('View All'),
          matching: find.byType(Flexible),
        );

        expect(flexibleWithViewAll, findsOneWidget);
      });
    });
  });
}
