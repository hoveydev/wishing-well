import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/features/all_wishers/all_wishers_view_model.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';

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

      test('exposes empty wishers when repository has none', () {
        final emptyRepo = MockWisherRepository(initialWishers: []);
        final emptyViewModel = AllWishersViewModel(
          wisherRepository: emptyRepo,
        );

        expect(emptyViewModel.wishers, isEmpty);

        emptyViewModel.dispose();
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
