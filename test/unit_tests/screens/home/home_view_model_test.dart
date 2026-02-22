import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/home/home_view_model.dart';
import '../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';
import '../../../../testing_resources/mocks/repositories/mock_wisher_repository.dart';

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
  });
}
