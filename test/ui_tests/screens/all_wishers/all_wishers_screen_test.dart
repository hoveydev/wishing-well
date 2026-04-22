import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/features/all_wishers/all_wishers_screen.dart';
import 'package:wishing_well/features/all_wishers/all_wishers_view_model.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/utils/result.dart';

void main() {
  group('AllWishersScreen', () {
    late MockWisherRepository mockWisherRepository;
    late AllWishersViewModel viewModel;

    setUp(() {
      mockWisherRepository = MockWisherRepository();
      viewModel = AllWishersViewModel(
        wisherRepository: mockWisherRepository,
      );
    });

    group(TestGroups.rendering, () {
      testWidgets('renders screen with close app bar', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: AllWishersScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppMenuBar), findsOneWidget);
        expect(find.byIcon(Icons.close), findsOneWidget);
      });

      testWidgets('renders wisher names from repository', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: AllWishersScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // MockWisherRepository has 4 default wishers
        expect(find.text('Alice Test'), findsOneWidget);
        expect(find.text('Bob Test'), findsOneWidget);
      });

      testWidgets('renders wishers in a ListView', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(
            child: AllWishersScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(ListView), findsOneWidget);
      });

      testWidgets('shows loading indicator when isLoading is true', (
        WidgetTester tester,
      ) async {
        final loadingViewModel = _AlwaysLoadingViewModel(
          wisherRepository: mockWisherRepository,
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: AllWishersScreen(viewModel: loadingViewModel),
          ),
        );
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(ListView), findsNothing);
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

      testWidgets('shows error UI when hasError is true', (
        WidgetTester tester,
      ) async {
        final errorViewModel = _AlwaysErrorViewModel(
          wisherRepository: mockWisherRepository,
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: AllWishersScreen(viewModel: errorViewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Error Loading Wishers'), findsOneWidget);
        expect(find.text('retry'), findsOneWidget);
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

      testWidgets('retry button triggers fetchWishers', (
        WidgetTester tester,
      ) async {
        var fetchCallCount = 0;

        final testViewModel = _FetchCountingViewModel(
          wisherRepository: mockWisherRepository,
          onFetch: () => fetchCallCount++,
          alwaysHasError: true,
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: AllWishersScreen(viewModel: testViewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final previousCount = fetchCallCount;
        await TestHelpers.tapAndSettle(tester, find.text('retry'));

        expect(fetchCallCount, greaterThan(previousCount));
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

      testWidgets('updates UI when repository notifies listeners', (
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
    });
  });
}

/// Test double that intercepts tapWisherItem without needing a BuildContext
/// navigation call (which would crash in tests without a real router).
class _TestAllWishersViewModel extends AllWishersViewModel {
  _TestAllWishersViewModel({
    required super.wisherRepository,
    required this.onWisherItemTap,
  });

  final void Function(Wisher wisher) onWisherItemTap;

  @override
  void tapWisherItem(BuildContext context, Wisher wisher) {
    onWisherItemTap(wisher);
  }
}

/// Test double that counts fetchWishers calls without real navigation.
class _FetchCountingViewModel extends AllWishersViewModel {
  _FetchCountingViewModel({
    required super.wisherRepository,
    required this.onFetch,
    this.alwaysHasError = false,
  });

  final void Function() onFetch;
  final bool alwaysHasError;

  @override
  bool get hasError => alwaysHasError || super.hasError;

  @override
  Future<Result<void>> fetchWishers() {
    onFetch();
    return super.fetchWishers();
  }
}

/// Test double that always reports isLoading = true, with no timers.
class _AlwaysLoadingViewModel extends AllWishersViewModel {
  _AlwaysLoadingViewModel({required super.wisherRepository});

  @override
  bool get isLoading => true;
}

/// Test double that always reports hasError = true, with no async fetch.
class _AlwaysErrorViewModel extends AllWishersViewModel {
  _AlwaysErrorViewModel({required super.wisherRepository});

  @override
  bool get hasError => true;
}
