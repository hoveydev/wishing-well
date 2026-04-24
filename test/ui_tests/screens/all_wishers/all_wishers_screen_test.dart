import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/features/all_wishers/all_wishers_screen.dart';
import 'package:wishing_well/features/all_wishers/all_wishers_view_model.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';

void main() {
  group('AllWishersScreen', () {
    late MockWisherRepository mockWisherRepository;
    late AllWishersViewModel viewModel;

    setUp(() {
      mockWisherRepository = MockWisherRepository();
      viewModel = AllWishersViewModel(wisherRepository: mockWisherRepository);
    });

    group(TestGroups.rendering, () {
      testWidgets('renders screen with close app bar', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: AllWishersScreen(viewModel: viewModel)),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppMenuBar), findsOneWidget);
        expect(find.byIcon(Icons.close), findsOneWidget);
      });

      testWidgets('renders screen title', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: AllWishersScreen(viewModel: viewModel)),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('All Wishers'), findsOneWidget);
      });

      testWidgets('renders search bar', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: AllWishersScreen(viewModel: viewModel)),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(TextField), findsOneWidget);
        expect(find.byIcon(Icons.search), findsOneWidget);
      });

      testWidgets('renders wisher names from repository', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: AllWishersScreen(viewModel: viewModel)),
        );
        await TestHelpers.pumpAndSettle(tester);

        // MockWisherRepository has 4 default wishers
        expect(find.text('Alice Test'), findsOneWidget);
        expect(find.text('Bob Test'), findsOneWidget);
      });

      testWidgets('renders wishers in a ListView', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: AllWishersScreen(viewModel: viewModel)),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(ListView), findsOneWidget);
      });

      testWidgets('shows empty message when there are no wishers', (
        WidgetTester tester,
      ) async {
        final emptyRepository = MockWisherRepository(initialWishers: []);
        final emptyViewModel = AllWishersViewModel(
          wisherRepository: emptyRepository,
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: AllWishersScreen(viewModel: emptyViewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('No wishers yet'), findsOneWidget);
        expect(find.byType(ListView), findsNothing);
      });

      testWidgets('shows no-results message when search has no matches', (
        WidgetTester tester,
      ) async {
        final testViewModel = _TestAllWishersViewModel(
          wisherRepository: mockWisherRepository,
        )..updateSearchQuery('xyz_no_match');

        await tester.pumpWidget(
          createScreenTestWidget(
            child: AllWishersScreen(viewModel: testViewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('No results found'), findsOneWidget);
        expect(find.byType(ListView), findsNothing);
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('tapping a wisher item invokes onWisherTap', (
        WidgetTester tester,
      ) async {
        Wisher? tappedWisher;

        final testRepository = MockWisherRepository();
        final testViewModel = _TestAllWishersViewModel(
          wisherRepository: testRepository,
          onWisherItemTap: (wisher) => tappedWisher = wisher,
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: AllWishersScreen(viewModel: testViewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Alice Test'));
        await TestHelpers.pumpAndSettle(tester);

        expect(tappedWisher, isNotNull);
        expect(tappedWisher!.firstName, 'Alice');
      });

      testWidgets('tapping close button invokes tapCloseButton', (
        WidgetTester tester,
      ) async {
        var closeTapped = false;

        final testViewModel = _TestAllWishersViewModel(
          wisherRepository: mockWisherRepository,
          onCloseTap: () => closeTapped = true,
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: AllWishersScreen(viewModel: testViewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.byIcon(Icons.close));

        expect(closeTapped, isTrue);
      });

      testWidgets('typing in search bar updates the filtered list', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: AllWishersScreen(viewModel: viewModel)),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Initially all 4 default wishers are visible
        expect(find.text('Alice Test'), findsOneWidget);
        expect(find.text('Bob Test'), findsOneWidget);

        await tester.enterText(find.byType(TextField), 'Alice');
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Alice Test'), findsOneWidget);
        expect(find.text('Bob Test'), findsNothing);
      });

      testWidgets('clearing search bar restores full list', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: AllWishersScreen(viewModel: viewModel)),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.enterText(find.byType(TextField), 'Alice');
        await TestHelpers.pumpAndSettle(tester);

        await tester.enterText(find.byType(TextField), '');
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Alice Test'), findsOneWidget);
        expect(find.text('Bob Test'), findsOneWidget);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('removes screen without disposal errors', (
        WidgetTester tester,
      ) async {
        final testViewModel = AllWishersViewModel(
          wisherRepository: mockWisherRepository,
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: AllWishersScreen(viewModel: testViewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.pumpWidget(const SizedBox.shrink());
        await TestHelpers.pumpAndSettle(tester);

        expect(tester.takeException(), isNull);
      });

      testWidgets('shows empty state when repository starts empty', (
        WidgetTester tester,
      ) async {
        final emptyRepository = MockWisherRepository(initialWishers: []);
        final testViewModel = AllWishersViewModel(
          wisherRepository: emptyRepository,
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: AllWishersScreen(viewModel: testViewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('No wishers yet'), findsOneWidget);
      });

      testWidgets('shows loading indicator when repository is loading', (
        WidgetTester tester,
      ) async {
        final loadingRepository = MockWisherRepository(initialWishers: []);
        final testViewModel = AllWishersViewModel(
          wisherRepository: loadingRepository,
        );

        // Start a fetch to set isLoading = true before building
        final fetchFuture = loadingRepository.fetchWishers();

        await tester.pumpWidget(
          createScreenTestWidget(
            child: AllWishersScreen(viewModel: testViewModel),
          ),
        );

        // isLoading is true so the indicator should be visible immediately
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('No wishers yet'), findsNothing);

        // Advance past the mock's internal delay to avoid pending timers
        await tester.pump(const Duration(milliseconds: 20));
        await fetchFuture;
      });
    });
  });
}

/// Test double that intercepts navigation calls without needing a BuildContext
/// navigation call (which would crash in tests without a real router).
class _TestAllWishersViewModel extends AllWishersViewModel {
  _TestAllWishersViewModel({
    required super.wisherRepository,
    this.onWisherItemTap,
    this.onCloseTap,
  });

  final void Function(Wisher wisher)? onWisherItemTap;
  final VoidCallback? onCloseTap;

  @override
  void tapWisherItem(BuildContext context, Wisher wisher) {
    onWisherItemTap?.call(wisher);
  }

  @override
  void tapCloseButton(BuildContext context) {
    onCloseTap?.call();
  }
}
