import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/wishers/wishers_list.dart';
import 'package:wishing_well/components/wishers/add_wisher_item.dart';
import 'package:wishing_well/components/wishers/wisher_item.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_spacing.dart';
import 'package:wishing_well/theme/app_theme.dart';

void main() {
  group('WishersList', () {
    testWidgets('renders wishers section header', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: Scaffold(body: WishersList(onAddWisherTap: () => {})),
        ),
      );

      // Check that "Wishers" title is displayed
      expect(find.text('Wishers'), findsOneWidget);

      // Check that "View All" button is displayed
      expect(find.text('View All'), findsOneWidget);
    });

    testWidgets('header has correct text styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: Scaffold(body: WishersList(onAddWisherTap: () => {})),
        ),
      );

      final wishersTitle = tester.widget<Text>(find.text('Wishers'));
      expect(
        wishersTitle.style!.color,
        AppTheme.lightTheme.textTheme.titleLarge!.color,
      );

      final viewAllText = tester.widget<Text>(find.text('View All'));
      expect(
        viewAllText.style!.color,
        AppTheme.lightTheme.textTheme.bodySmall!.color,
      );
    });

    testWidgets('renders AddWisherItem as first item', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: Scaffold(body: WishersList(onAddWisherTap: () => {})),
        ),
      );

      // Find the ListView
      final listView = find.byType(ListView);
      expect(listView, findsOneWidget);

      // Check that AddWisherItem is rendered (should be first)
      expect(find.byType(AddWisherItem), findsOneWidget);
    });

    testWidgets('renders correct number of wisher items', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: Scaffold(body: WishersList(onAddWisherTap: () => {})),
        ),
      );

      // Should have 8 WisherItem widgets (based on the static _wishers list)
      expect(find.byType(WisherItem), findsNWidgets(8));

      // Total items should be 9 (8 wishers + 1 add button)
      // Verify by checking the total number of items found
      expect(find.byType(AddWisherItem), findsOneWidget);
      expect(find.byType(WisherItem), findsNWidgets(8));
      expect(find.byType(AddWisherItem), findsOneWidget);
      // Total: 1 AddWisherItem + 8 WisherItem = 9 items
    });

    testWidgets('renders specific wisher names', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: Scaffold(body: WishersList(onAddWisherTap: () => {})),
        ),
      );

      // Check for the specific wisher names from the static list
      expect(find.text('Alice'), findsNWidgets(2));
      expect(find.text('Bob'), findsNWidgets(2));
      expect(find.text('Charlie'), findsNWidgets(2));
      expect(find.text('Diana'), findsNWidgets(2));
    });

    testWidgets('renders correct initials for wishers', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: Scaffold(body: WishersList(onAddWisherTap: () => {})),
        ),
      );

      // Check for the correct initials
      expect(find.text('A'), findsNWidgets(2)); // Alice
      expect(find.text('B'), findsNWidgets(2)); // Bob
      expect(find.text('C'), findsNWidgets(2)); // Charlie
      expect(find.text('D'), findsNWidgets(2)); // Diana
    });

    testWidgets('last item has no right padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: Scaffold(body: WishersList(onAddWisherTap: () => {})),
        ),
      );

      // Get all WisherItem widgets
      final wisherItems = tester.widgetList<WisherItem>(
        find.byType(WisherItem),
      );

      // The last wisher item should have EdgeInsets.zero padding
      final lastWisherItem = wisherItems.last;
      expect(lastWisherItem.padding, EdgeInsets.zero);
    });

    testWidgets('list is horizontally scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: Scaffold(body: WishersList(onAddWisherTap: () => {})),
        ),
      );

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.scrollDirection, Axis.horizontal);
    });

    testWidgets('list has correct height constraints', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: Scaffold(body: WishersList(onAddWisherTap: () => {})),
        ),
      );

      // Find the SizedBox that constrains the list height
      final heightConstraint = find.byType(SizedBox).first;
      final sizedBox = tester.widget<SizedBox>(heightConstraint);
      expect(sizedBox.height, 16);
    });

    testWidgets('handles "View All" button tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: Scaffold(body: WishersList(onAddWisherTap: () => {})),
        ),
      );

      // Find and tap the "View All" text
      await tester.tap(find.text('View All'));
      await tester.pump();

      // Should not crash - the gesture detector should handle the tap
      expect(find.text('View All'), findsOneWidget);
    });

    testWidgets('View All button is gesture detector', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: Scaffold(body: WishersList(onAddWisherTap: () => {})),
        ),
      );

      // Find the GestureDetector wrapping "View All"
      final gestureDetector = find.ancestor(
        of: find.text('View All'),
        matching: find.byType(GestureDetector),
      );
      expect(gestureDetector, findsOneWidget);
    });

    testWidgets('list extends beyond screen bounds', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: Scaffold(body: WishersList(onAddWisherTap: () => {})),
        ),
      );

      // Find the Positioned widget that extends the list
      final positioned = find.byType(Positioned);
      expect(positioned, findsWidgets);

      final positionedWidget = tester.widgetList<Positioned>(positioned).first;
      expect(positionedWidget.left, -AppSpacing.screenPaddingStandard);
      expect(positionedWidget.right, -AppSpacing.screenPaddingStandard);
    });

    testWidgets('maintains header-row spacing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: Scaffold(body: WishersList(onAddWisherTap: () => {})),
        ),
      );

      // Find the Row containing header elements
      final headerRow = find.byType(Row);
      expect(headerRow, findsOneWidget);

      final row = tester.widget<Row>(headerRow);
      expect(row.mainAxisAlignment, MainAxisAlignment.spaceBetween);
    });

    testWidgets('uses correct list padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: Scaffold(body: WishersList(onAddWisherTap: () => {})),
        ),
      );

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(
        listView.padding,
        const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPaddingStandard,
        ),
      );
    });

    testWidgets('works with dark theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.darkTheme,
          home: Scaffold(body: WishersList(onAddWisherTap: () => {})),
        ),
      );

      // Should render without errors in dark theme
      expect(find.text('Wishers'), findsOneWidget);
      expect(find.text('View All'), findsOneWidget);
      expect(find.byType(WishersList), findsOneWidget);
      expect(find.byType(AddWisherItem), findsOneWidget);
      expect(find.byType(WisherItem), findsNWidgets(8));

      // Check text styling in dark theme
      final wishersTitle = tester.widget<Text>(find.text('Wishers'));
      expect(
        wishersTitle.style!.color,
        AppTheme.darkTheme.textTheme.titleLarge!.color,
      );

      final viewAllText = tester.widget<Text>(find.text('View All'));
      expect(
        viewAllText.style!.color,
        AppTheme.darkTheme.textTheme.bodySmall!.color,
      );
    });

    testWidgets('handles scrolling to see all items', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: Scaffold(body: WishersList(onAddWisherTap: () => {})),
        ),
      );

      // Initially should see some items
      expect(find.byType(WisherItem), findsNWidgets(8));

      // Scroll horizontally
      await tester.fling(find.byType(ListView), const Offset(-300, 0), 1000);
      await tester.pumpAndSettle();

      // Should still find all items after scrolling
      expect(find.byType(WisherItem), findsNWidgets(8));
    });
  });
}
