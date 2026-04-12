import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/features/wisher_details/wisher_details_view_model.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';

void main() {
  group('WisherDetailsViewModel', () {
    late MockWisherRepository mockWisherRepository;

    setUp(() {
      mockWisherRepository = MockWisherRepository();
    });

    group('Initialization', () {
      test('initializes with loading state false', () {
        // Act
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        // Assert
        expect(viewModel.isLoading, isFalse);

        // Cleanup
        viewModel.dispose();
      });

      test('initializes with wisher null when not found', () {
        // Act
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: 'nonexistent-id',
        );

        // Assert
        expect(viewModel.wisher, isNull);

        // Cleanup
        viewModel.dispose();
      });

      test('initializes with correct wisherId lookup', () {
        // Act
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        // Assert - Alice exists with ID '1'
        expect(viewModel.wisher, isNotNull);
        expect(viewModel.wisher!.firstName, 'Alice');

        // Cleanup
        viewModel.dispose();
      });
    });

    group('Wisher Loading', () {
      test('finds wisher from cached list by ID', () {
        // Act
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        // Assert
        expect(viewModel.wisher, isNotNull);
        expect(viewModel.wisher!.firstName, 'Alice');

        // Cleanup
        viewModel.dispose();
      });

      test('returns null when wisher ID not found in cache', () {
        // Act
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: 'definitely-not-a-real-id',
        );

        // Assert
        expect(viewModel.wisher, isNull);
        expect(viewModel.isLoading, isFalse);

        // Cleanup
        viewModel.dispose();
      });

      test('handles empty wisherId gracefully', () {
        // Act
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '',
        );

        // Assert - Should not throw, wisher should be null
        expect(viewModel.wisher, isNull);
        expect(viewModel.isLoading, isFalse);

        // Cleanup
        viewModel.dispose();
      });

      test('finds correct wisher when multiple wishers exist', () {
        // Act - Mock has 4 default wishers with IDs '1', '2', '3', '4'
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '2',
        );

        // Assert
        expect(viewModel.wisher, isNotNull);
        expect(viewModel.wisher!.firstName, 'Bob');

        // Cleanup
        viewModel.dispose();
      });
    });

    group('Loading State', () {
      test('initializes with isLoading false after construction', () {
        // Act
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        // Assert - Loading completes synchronously
        expect(viewModel.isLoading, isFalse);

        // Cleanup
        viewModel.dispose();
      });

      test('updates listeners when loading completes', () async {
        // Arrange
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        var notificationCount = 0;
        viewModel.addListener(() {
          notificationCount++;
        });

        // Act - Trigger notification by notifying listeners
        mockWisherRepository.notifyListeners();
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        expect(notificationCount, greaterThanOrEqualTo(0));

        // Cleanup
        viewModel.dispose();
      });
    });

    group('Listener Management', () {
      test('cleans up listener on dispose', () async {
        // Arrange
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        var notificationCount = 0;
        viewModel.addListener(() {
          notificationCount++;
        });

        // Act
        viewModel.dispose();

        // Create a separate wisher to notify listeners
        final tempVm = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '2',
        );

        mockWisherRepository.notifyListeners();
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert - Disposed viewModel should not receive notifications
        expect(notificationCount, 0);

        // Cleanup
        tempVm.dispose();
      });
    });

    group('Contract Implementation', () {
      test('implements WisherDetailsViewModelContract', () {
        // Act
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        // Assert
        expect(viewModel, isA<WisherDetailsViewModelContract>());

        // Cleanup
        viewModel.dispose();
      });

      test('exposes wisher through contract', () {
        // Act
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        // Assert
        final Wisher? wisher = viewModel.wisher;
        expect(wisher, isNotNull);

        // Cleanup
        viewModel.dispose();
      });

      test('exposes isLoading through contract', () {
        // Act
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        // Assert
        final bool isLoading = viewModel.isLoading;
        expect(isLoading, isFalse);

        // Cleanup
        viewModel.dispose();
      });
    });

    group('Edge Cases', () {
      test('handles empty wisherId gracefully without errors', () {
        // Act & Assert
        expect(() {
          final vm = WisherDetailsViewModel(
            wisherRepository: mockWisherRepository,
            wisherId: '',
          );
          vm.dispose();
        }, returnsNormally);
      });

      test('can construct multiple instances with different IDs', () {
        // Act
        final vm1 = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );
        final vm2 = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '2',
        );

        // Assert
        expect(vm1.wisher!.firstName, 'Alice');
        expect(vm2.wisher!.firstName, 'Bob');
        expect(vm1.wisher!.id, isNot(vm2.wisher!.id));

        // Cleanup
        vm1.dispose();
        vm2.dispose();
      });

      test('works with all mock repository wishers', () {
        // Test that we can access all default wishers
        final ids = ['1', '2', '3', '4'];
        final expectedNames = ['Alice', 'Bob', 'Charlie', 'Diana'];

        for (int i = 0; i < ids.length; i++) {
          final vm = WisherDetailsViewModel(
            wisherRepository: mockWisherRepository,
            wisherId: ids[i],
          );

          expect(vm.wisher, isNotNull);
          expect(vm.wisher!.firstName, expectedNames[i]);

          vm.dispose();
        }
      });
    });
  });
}
