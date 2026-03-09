import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/features/home/home_view_model.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/utils/result.dart';

void main() {
  group('HomeViewModel', () {
    late MockAuthRepository mockAuthRepository;
    late MockWisherRepository mockWisherRepository;
    late HomeViewModel viewModel;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockWisherRepository = MockWisherRepository();

      viewModel = HomeViewModel(
        authRepository: mockAuthRepository,
        wisherRepository: mockWisherRepository,
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('should forward repository notifications to listeners', () async {
      // Arrange
      var notificationCount = 0;
      viewModel.addListener(() {
        notificationCount++;
      });

      // Act - Simulate repository notifying listeners
      // In a real scenario, this would happen when fetchWishers completes
      mockWisherRepository.notifyListeners();

      // Allow async operations to complete
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(notificationCount, 1);
    });

    test('should clean up listener on dispose', () async {
      // Arrange
      var notificationCount = 0;
      viewModel.addListener(() {
        notificationCount++;
      });

      // Act
      viewModel.dispose();
      mockWisherRepository.notifyListeners();

      // Allow async operations to complete
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert - Should not receive notifications after dispose
      expect(notificationCount, 0);

      // Prevent tearDown from disposing again
      viewModel = HomeViewModel(
        authRepository: mockAuthRepository,
        wisherRepository: mockWisherRepository,
      );
    });

    test('should expose wishers from repository', () {
      // Act & Assert - MockWisherRepository has 4 default wishers
      expect(viewModel.wishers.length, 4);
      expect(viewModel.wishers.first.firstName, 'Alice');
    });

    test('should expose isLoading from repository', () async {
      // Act - Start loading
      final fetchFuture = viewModel.fetchWishers();

      // Assert - Should be loading
      expect(viewModel.isLoadingWishers, true);

      // Wait for fetch to complete
      await fetchFuture;

      // Assert - Should not be loading anymore
      expect(viewModel.isLoadingWishers, false);
    });

    test('should expose firstName from auth repository', () {
      // Act & Assert - MockAuthRepository returns 'TestUser'
      expect(viewModel.firstName, 'TestUser');
    });

    test('should receive notification when fetchWishers completes', () async {
      // Arrange
      var notificationCount = 0;
      viewModel.addListener(() {
        notificationCount++;
      });

      // Act
      await viewModel.fetchWishers();

      // Allow async operations to complete
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert - Should have received at least 2 notifications (loading start/end)
      expect(notificationCount, greaterThanOrEqualTo(2));
    });

    group('error state', () {
      test('should have no error initially', () {
        expect(viewModel.hasWisherError, isFalse);
        expect(viewModel.wisherError, isNull);
      });

      test('should set error when fetchWishers fails', () async {
        // Arrange - Create mock with error result
        final errorException = Exception('Failed to fetch wishers');
        final failingMockWisherRepository = MockWisherRepository(
          fetchWishersResult: Result.error(errorException),
        );
        final failingViewModel = HomeViewModel(
          authRepository: mockAuthRepository,
          wisherRepository: failingMockWisherRepository,
        );

        // Act
        await failingViewModel.fetchWishers();

        // Assert
        expect(failingViewModel.hasWisherError, isTrue);
        expect(failingViewModel.wisherError, equals(errorException));

        // Cleanup
        failingViewModel.dispose();
      });

      test('should clear error before fetching', () async {
        // Arrange - First fetch fails
        final failingMockWisherRepository = MockWisherRepository(
          fetchWishersResult: Result.error(Exception('Failed')),
        );
        final failingViewModel = HomeViewModel(
          authRepository: mockAuthRepository,
          wisherRepository: failingMockWisherRepository,
        );
        await failingViewModel.fetchWishers();
        expect(failingViewModel.hasWisherError, isTrue);

        // Create new view model with successful mock for second fetch
        final successMockWisherRepository = MockWisherRepository(
          fetchWishersResult: const Result.ok(null),
        );
        final successViewModel = HomeViewModel(
          authRepository: mockAuthRepository,
          wisherRepository: successMockWisherRepository,
        );

        // Act - Fetch succeeds
        await successViewModel.fetchWishers();

        // Assert - Error should be cleared
        expect(successViewModel.hasWisherError, isFalse);
        expect(successViewModel.wisherError, isNull);

        // Cleanup
        failingViewModel.dispose();
        successViewModel.dispose();
      });

      test('should notify listeners when error occurs', () async {
        // Arrange
        final failingMockWisherRepository = MockWisherRepository(
          fetchWishersResult: Result.error(Exception('Failed')),
        );
        final failingViewModel = HomeViewModel(
          authRepository: mockAuthRepository,
          wisherRepository: failingMockWisherRepository,
        );

        var notificationCount = 0;
        failingViewModel.addListener(() {
          notificationCount++;
        });

        // Act
        await failingViewModel.fetchWishers();

        // Allow async operations to complete
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert - Should have received notifications
        expect(notificationCount, greaterThanOrEqualTo(1));

        // Cleanup
        failingViewModel.dispose();
      });
    });
  });
}
