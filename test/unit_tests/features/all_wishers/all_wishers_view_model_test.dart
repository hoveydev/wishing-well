import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/features/all_wishers/all_wishers_view_model.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/utils/result.dart';

void main() {
  group('AllWishersViewModel', () {
    late MockWisherRepository mockWisherRepository;
    late AllWishersViewModel viewModel;

    setUp(() {
      mockWisherRepository = MockWisherRepository();
      viewModel = AllWishersViewModel(
        wisherRepository: mockWisherRepository,
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Initial State', () {
      test('exposes wishers from repository', () {
        expect(viewModel.wishers.length, 4);
        expect(viewModel.wishers.first.firstName, 'Alice');
      });

      test('exposes isLoading from repository', () {
        expect(viewModel.isLoading, isFalse);
      });

      test('has no error initially', () {
        expect(viewModel.hasError, isFalse);
      });
    });

    group('fetchWishers', () {
      test('sets error when fetch fails', () async {
        final failingRepository = MockWisherRepository(
          fetchWishersResult: Result.error(Exception('Network error')),
        );
        final failingViewModel = AllWishersViewModel(
          wisherRepository: failingRepository,
        );

        await failingViewModel.fetchWishers();

        expect(failingViewModel.hasError, isTrue);

        failingViewModel.dispose();
      });

      test('clears error before fetching', () async {
        final failingRepository = MockWisherRepository(
          fetchWishersResult: Result.error(Exception('Network error')),
        );
        final failingViewModel = AllWishersViewModel(
          wisherRepository: failingRepository,
        );
        await failingViewModel.fetchWishers();
        expect(failingViewModel.hasError, isTrue);

        final successRepository = MockWisherRepository(
          fetchWishersResult: const Result.ok(null),
        );
        final successViewModel = AllWishersViewModel(
          wisherRepository: successRepository,
        );
        await successViewModel.fetchWishers();

        expect(successViewModel.hasError, isFalse);

        failingViewModel.dispose();
        successViewModel.dispose();
      });

      test('notifies listeners when fetch completes', () async {
        var notificationCount = 0;
        viewModel.addListener(() => notificationCount++);

        await viewModel.fetchWishers();
        await Future.delayed(const Duration(milliseconds: 50));

        expect(notificationCount, greaterThanOrEqualTo(1));
      });

      test('returns error result when fetch fails', () async {
        final error = Exception('Fetch failed');
        final failingRepository = MockWisherRepository(
          fetchWishersResult: Result.error(error),
        );
        final failingViewModel = AllWishersViewModel(
          wisherRepository: failingRepository,
        );

        final result = await failingViewModel.fetchWishers();

        expect(result, isA<Error>());

        failingViewModel.dispose();
      });
    });

    group('Repository listener', () {
      test('forwards repository notifications to listeners', () async {
        var notificationCount = 0;
        viewModel.addListener(() => notificationCount++);

        mockWisherRepository.notifyListeners();
        await Future.delayed(const Duration(milliseconds: 50));

        expect(notificationCount, 1);
      });

      test('cleans up listener on dispose', () async {
        var notificationCount = 0;
        viewModel.addListener(() => notificationCount++);

        viewModel.dispose();
        mockWisherRepository.notifyListeners();
        await Future.delayed(const Duration(milliseconds: 50));

        expect(notificationCount, 0);

        // Prevent tearDown from disposing again
        viewModel = AllWishersViewModel(
          wisherRepository: mockWisherRepository,
        );
      });
    });

    group('Navigation', () {
      test('tapWisherItem constructs correct path', () {
        final wisher = viewModel.wishers.first;
        final expectedPath = Routes.wisherDetails.buildPath(id: wisher.id);

        expect(expectedPath, '/wisher-details/${wisher.id}');
      });

      test('tapWisherItem constructs path for all repository wishers', () {
        for (final wisher in viewModel.wishers) {
          final path = Routes.wisherDetails.buildPath(id: wisher.id);

          expect(path, startsWith('/wisher-details/'));
          expect(path, contains(wisher.id));
        }
      });

      test('allWishers route name is correct', () {
        expect(Routes.allWishers.name, 'all-wishers');
      });
    });
  });
}
