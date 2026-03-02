import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository_impl.dart';
import 'package:wishing_well/utils/result.dart';

import '../../../../../test_helpers/helpers/test_helpers.dart';
import '../../../../../test_helpers/mocks/data_sources/mock_wisher_data_source.dart';

void main() {
  group('WisherRepositoryImpl', () {
    late MockWisherDataSource mockDataSource;
    late WisherRepositoryImpl repository;

    setUp(() {
      mockDataSource = MockWisherDataSource();
      repository = WisherRepositoryImpl(dataSource: mockDataSource);
    });

    tearDown(() {
      repository.dispose();
    });

    group(TestGroups.initialState, () {
      test('is a ChangeNotifier', () {
        expect(repository, isA<ChangeNotifier>());
      });

      test('wishers returns empty list initially', () {
        expect(repository.wishers, isEmpty);
      });

      test('isLoading returns false initially', () {
        expect(repository.isLoading, isFalse);
      });

      test('error returns null initially', () {
        expect(repository.error, isNull);
      });

      test('wishers returns unmodifiable list', () {
        final wishers = repository.wishers;
        expect(
          () => wishers.add(
            Wisher(
              id: 'test',
              userId: 'test',
              firstName: 'Test',
              lastName: 'Test',
              createdAt: DateTime(2024),
              updatedAt: DateTime(2024),
            ),
          ),
          throwsUnsupportedError,
        );
      });
    });

    group('FetchWishers', () {
      test('returns Ok and populates wishers on success', () async {
        mockDataSource.fetchWishersResult = [
          {
            'id': '1',
            'user_id': 'user-1',
            'first_name': 'Alice',
            'last_name': 'Test',
            'created_at': '2024-01-01T00:00:00Z',
            'updated_at': '2024-01-01T00:00:00Z',
          },
          {
            'id': '2',
            'user_id': 'user-1',
            'first_name': 'Bob',
            'last_name': 'Test',
            'created_at': '2024-01-02T00:00:00Z',
            'updated_at': '2024-01-02T00:00:00Z',
          },
        ];

        final result = await repository.fetchWishers();

        expect(result, isA<Ok>());
        expect(repository.wishers.length, 2);
        expect(repository.wishers[0].firstName, 'Alice');
        expect(repository.wishers[1].firstName, 'Bob');
        expect(mockDataSource.fetchWishersCalled, isTrue);
      });

      test('sets isLoading to true during fetch', () async {
        // Use a slow data source to verify loading state
        final slowDataSource = _SlowMockWisherDataSource();
        repository = WisherRepositoryImpl(dataSource: slowDataSource);

        expect(repository.isLoading, isFalse);

        final fetchFuture = repository.fetchWishers();

        // Check loading state before future completes
        expect(repository.isLoading, isTrue);

        await fetchFuture;

        expect(repository.isLoading, isFalse);
      });

      test('returns Error and sets error on exception', () async {
        mockDataSource.fetchWishersError = Exception('Network error');

        final result = await repository.fetchWishers();

        expect(result, isA<Error>());
        expect(repository.error, isNotNull);
        expect(repository.error.toString(), contains('Network error'));
      });

      test('clears error on successful fetch', () async {
        mockDataSource.fetchWishersError = Exception('First error');
        await repository.fetchWishers();

        mockDataSource.fetchWishersError = null;
        mockDataSource.fetchWishersResult = [
          {
            'id': '1',
            'user_id': 'user-1',
            'first_name': 'Alice',
            'last_name': 'Test',
            'created_at': '2024-01-01T00:00:00Z',
            'updated_at': '2024-01-01T00:00:00Z',
          },
        ];

        final result = await repository.fetchWishers();

        expect(result, isA<Ok>());
        expect(repository.error, isNull);
      });

      test('notifies listeners during fetch lifecycle', () async {
        final notifyStates = <String>[];
        repository.addListener(() {
          notifyStates.add(repository.isLoading ? 'loading' : 'loaded');
        });

        await repository.fetchWishers();

        // Should notify: loading start, loading end
        expect(notifyStates, contains('loading'));
        expect(notifyStates, contains('loaded'));
      });

      test('notifies listeners exactly twice (start and end)', () async {
        var notifyCount = 0;
        repository.addListener(() {
          notifyCount++;
        });

        await repository.fetchWishers();

        expect(notifyCount, 2);
      });
    });

    group('CreateWisher', () {
      test('returns Ok with created wisher on success', () async {
        mockDataSource.createWisherResult = {
          'id': 'new-id',
          'user_id': 'user-1',
          'first_name': 'New',
          'last_name': 'Wisher',
          'profile_picture': 'https://example.com/pic.jpg',
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-01T00:00:00Z',
        };

        final result = await repository.createWisher(
          userId: 'user-1',
          firstName: 'New',
          lastName: 'Wisher',
          profilePicture: 'https://example.com/pic.jpg',
        );

        expect(result, isA<Ok>());
        final wisher = (result as Ok<Wisher>).value;
        expect(wisher.id, 'new-id');
        expect(wisher.firstName, 'New');
        expect(wisher.profilePicture, 'https://example.com/pic.jpg');
      });

      test('adds created wisher to local list at beginning', () async {
        mockDataSource.fetchWishersResult = [
          {
            'id': 'existing-1',
            'user_id': 'user-1',
            'first_name': 'Existing',
            'last_name': 'Wisher',
            'created_at': '2024-01-01T00:00:00Z',
            'updated_at': '2024-01-01T00:00:00Z',
          },
        ];
        await repository.fetchWishers();
        expect(repository.wishers.length, 1);

        mockDataSource.createWisherResult = {
          'id': 'new-id',
          'user_id': 'user-1',
          'first_name': 'New',
          'last_name': 'Wisher',
          'created_at': '2024-01-02T00:00:00Z',
          'updated_at': '2024-01-02T00:00:00Z',
        };

        await repository.createWisher(
          userId: 'user-1',
          firstName: 'New',
          lastName: 'Wisher',
        );

        expect(repository.wishers.length, 2);
        expect(repository.wishers.first.id, 'new-id');
      });

      test('returns Error on data source exception', () async {
        mockDataSource.createWisherError = Exception('Creation failed');

        final result = await repository.createWisher(
          userId: 'user-1',
          firstName: 'New',
          lastName: 'Wisher',
        );

        expect(result, isA<Error>());
      });

      test('notifies listeners after creation', () async {
        var notified = false;
        repository.addListener(() {
          notified = true;
        });

        await repository.createWisher(
          userId: 'user-1',
          firstName: 'New',
          lastName: 'Wisher',
        );

        expect(notified, isTrue);
      });

      test('calls data source with correct parameters', () async {
        await repository.createWisher(
          userId: 'specific-user',
          firstName: 'Specific',
          lastName: 'Name',
          profilePicture: 'https://example.com/specific.jpg',
        );

        expect(mockDataSource.createWisherCalled, isTrue);
      });
    });

    group('UpdateWisher', () {
      test('returns Ok with updated wisher on success', () async {
        // Setup initial wisher
        mockDataSource.fetchWishersResult = [
          {
            'id': 'wisher-1',
            'user_id': 'user-1',
            'first_name': 'Old',
            'last_name': 'Name',
            'created_at': '2024-01-01T00:00:00Z',
            'updated_at': '2024-01-01T00:00:00Z',
          },
        ];
        await repository.fetchWishers();

        mockDataSource.updateWisherResult = {
          'id': 'wisher-1',
          'user_id': 'user-1',
          'first_name': 'Updated',
          'last_name': 'Name',
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-02T00:00:00Z',
        };

        final wisherToUpdate = repository.wishers.first.copyWith(
          firstName: 'Updated',
        );

        final result = await repository.updateWisher(wisherToUpdate);

        expect(result, isA<Ok>());
        final updated = (result as Ok<Wisher>).value;
        expect(updated.firstName, 'Updated');
      });

      test('updates wisher in local list', () async {
        mockDataSource.fetchWishersResult = [
          {
            'id': 'wisher-1',
            'user_id': 'user-1',
            'first_name': 'Old',
            'last_name': 'Name',
            'created_at': '2024-01-01T00:00:00Z',
            'updated_at': '2024-01-01T00:00:00Z',
          },
        ];
        await repository.fetchWishers();

        mockDataSource.updateWisherResult = {
          'id': 'wisher-1',
          'user_id': 'user-1',
          'first_name': 'Updated',
          'last_name': 'Name',
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-02T00:00:00Z',
        };

        final wisherToUpdate = repository.wishers.first.copyWith(
          firstName: 'Updated',
        );

        await repository.updateWisher(wisherToUpdate);

        expect(repository.wishers.first.firstName, 'Updated');
      });

      test('returns Error on data source exception', () async {
        final wisher = Wisher(
          id: 'wisher-1',
          userId: 'user-1',
          firstName: 'Test',
          lastName: 'User',
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024),
        );

        mockDataSource.updateWisherError = Exception('Update failed');

        final result = await repository.updateWisher(wisher);

        expect(result, isA<Error>());
      });

      test('notifies listeners after update', () async {
        // First, fetch wishers so the wisher exists in local list
        mockDataSource.fetchWishersResult = [
          {
            'id': 'wisher-1',
            'user_id': 'user-1',
            'first_name': 'Test',
            'last_name': 'User',
            'created_at': '2024-01-01T00:00:00Z',
            'updated_at': '2024-01-01T00:00:00Z',
          },
        ];
        await repository.fetchWishers();

        var notified = false;
        repository.addListener(() {
          notified = true;
        });

        mockDataSource.updateWisherResult = {
          'id': 'wisher-1',
          'user_id': 'user-1',
          'first_name': 'Updated',
          'last_name': 'User',
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-02T00:00:00Z',
        };

        final wisher = repository.wishers.first.copyWith(firstName: 'Updated');

        await repository.updateWisher(wisher);

        expect(notified, isTrue);
      });
    });

    group('DeleteWisher', () {
      test('returns Ok on successful deletion', () async {
        mockDataSource.fetchWishersResult = [
          {
            'id': 'wisher-1',
            'user_id': 'user-1',
            'first_name': 'To',
            'last_name': 'Delete',
            'created_at': '2024-01-01T00:00:00Z',
            'updated_at': '2024-01-01T00:00:00Z',
          },
        ];
        await repository.fetchWishers();
        expect(repository.wishers.length, 1);

        final result = await repository.deleteWisher('wisher-1');

        expect(result, isA<Ok>());
        expect(repository.wishers.isEmpty, isTrue);
        expect(mockDataSource.deleteWisherCalled, isTrue);
      });

      test('removes wisher from local list', () async {
        mockDataSource.fetchWishersResult = [
          {
            'id': 'wisher-1',
            'user_id': 'user-1',
            'first_name': 'Keep',
            'last_name': 'Me',
            'created_at': '2024-01-01T00:00:00Z',
            'updated_at': '2024-01-01T00:00:00Z',
          },
          {
            'id': 'wisher-2',
            'user_id': 'user-1',
            'first_name': 'Delete',
            'last_name': 'Me',
            'created_at': '2024-01-02T00:00:00Z',
            'updated_at': '2024-01-02T00:00:00Z',
          },
        ];
        await repository.fetchWishers();
        expect(repository.wishers.length, 2);

        await repository.deleteWisher('wisher-2');

        expect(repository.wishers.length, 1);
        expect(repository.wishers.first.id, 'wisher-1');
      });

      test('returns Error on data source exception', () async {
        mockDataSource.deleteWisherError = Exception('Delete failed');

        final result = await repository.deleteWisher('wisher-1');

        expect(result, isA<Error>());
      });

      test('notifies listeners after deletion', () async {
        var notified = false;
        repository.addListener(() {
          notified = true;
        });

        await repository.deleteWisher('wisher-1');

        expect(notified, isTrue);
      });
    });

    group('ChangeNotifier Behavior', () {
      test('can remove listeners', () async {
        var notifyCount = 0;
        void listener() {
          notifyCount++;
        }

        repository.addListener(listener);
        await repository.fetchWishers();
        expect(notifyCount, 2);

        repository.removeListener(listener);
        await repository.fetchWishers();
        expect(notifyCount, 2);
      });

      test('can have multiple listeners', () async {
        var listener1Count = 0;
        var listener2Count = 0;

        repository.addListener(() {
          listener1Count++;
        });
        repository.addListener(() {
          listener2Count++;
        });

        await repository.fetchWishers();

        expect(listener1Count, 2);
        expect(listener2Count, 2);
      });
    });

    group(TestGroups.stateChanges, () {
      test('full CRUD flow works correctly', () async {
        // Fetch (empty)
        mockDataSource.fetchWishersResult = [];
        await repository.fetchWishers();
        expect(repository.wishers, isEmpty);

        // Create
        mockDataSource.createWisherResult = {
          'id': 'wisher-1',
          'user_id': 'user-1',
          'first_name': 'First',
          'last_name': 'Wisher',
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-01T00:00:00Z',
        };
        await repository.createWisher(
          userId: 'user-1',
          firstName: 'First',
          lastName: 'Wisher',
        );
        expect(repository.wishers.length, 1);

        // Update
        mockDataSource.updateWisherResult = {
          'id': 'wisher-1',
          'user_id': 'user-1',
          'first_name': 'Updated',
          'last_name': 'Wisher',
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-02T00:00:00Z',
        };
        await repository.updateWisher(
          repository.wishers.first.copyWith(firstName: 'Updated'),
        );
        expect(repository.wishers.first.firstName, 'Updated');

        // Delete
        await repository.deleteWisher('wisher-1');
        expect(repository.wishers, isEmpty);
      });

      test(
        'error state is cleared on subsequent successful operation',
        () async {
          mockDataSource.fetchWishersError = Exception('First error');
          await repository.fetchWishers();
          expect(repository.error, isNotNull);

          mockDataSource.fetchWishersError = null;
          mockDataSource.fetchWishersResult = [];
          await repository.fetchWishers();
          expect(repository.error, isNull);
        },
      );
    });
  });
}

/// A mock data source that introduces a delay to test loading states.
class _SlowMockWisherDataSource extends MockWisherDataSource {
  @override
  Future<List<Map<String, dynamic>>> fetchWishers() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return super.fetchWishers();
  }
}
