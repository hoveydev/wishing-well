import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/utils/result.dart';

void main() {
  group('MockWisherRepository', () {
    group(TestGroups.initialState, () {
      test('default updateWisherResult is null', () {
        final repository = MockWisherRepository();
        expect(repository.updateWisherResult, isNull);
      });

      test('default wishers list has four entries', () {
        final repository = MockWisherRepository();
        expect(repository.wishers.length, 4);
      });

      test('default isLoading is false', () {
        final repository = MockWisherRepository();
        expect(repository.isLoading, isFalse);
      });

      test('default error is null', () {
        final repository = MockWisherRepository();
        expect(repository.error, isNull);
      });
    });

    group(TestGroups.behavior, () {
      test(
        'updateWisher succeeds and mutates list when result override is null',
        () async {
          final repository = MockWisherRepository();
          final original = repository.wishers.first;
          final updated = Wisher(
            id: original.id,
            userId: original.userId,
            firstName: 'Updated',
            lastName: original.lastName,
            createdAt: original.createdAt,
            updatedAt: DateTime.now(),
          );

          final result = await repository.updateWisher(updated);

          expect(result, isA<Ok<Wisher>>());
          expect(repository.wishers.first.firstName, 'Updated');
        },
      );

      test('updateWisher returns override result when set', () async {
        final error = Exception('Update failed');
        final repository = MockWisherRepository(
          updateWisherResult: Result.error(error),
        );
        final wisher = repository.wishers.first;

        final result = await repository.updateWisher(wisher);

        expect(result, isA<Error<Wisher>>());
      });

      test('updateWisher override does not mutate list', () async {
        final repository = MockWisherRepository(
          updateWisherResult: Result.error(Exception('fail')),
        );
        final originalFirst = repository.wishers.first;
        final updated = Wisher(
          id: originalFirst.id,
          userId: originalFirst.userId,
          firstName: 'ShouldNotChange',
          lastName: originalFirst.lastName,
          createdAt: originalFirst.createdAt,
          updatedAt: DateTime.now(),
        );

        await repository.updateWisher(updated);

        expect(repository.wishers.first.firstName, originalFirst.firstName);
      });

      test('updateWisher notifies listeners on success', () async {
        final repository = MockWisherRepository();
        var notified = false;
        void listener() => notified = true;
        repository.addListener(listener);

        final wisher = repository.wishers.first;
        await repository.updateWisher(wisher);

        expect(notified, isTrue);
        repository.removeListener(listener);
      });

      test('deleteWisher removes wisher from list on success', () async {
        final repository = MockWisherRepository();
        final initialCount = repository.wishers.length;

        await repository.deleteWisher('1');

        expect(repository.wishers.length, initialCount - 1);
        expect(repository.wishers.any((w) => w.id == '1'), isFalse);
      });

      test('deleteWisher with error result does not remove wisher', () async {
        final repository = MockWisherRepository(
          deleteWisherResult: Result.error(Exception('fail')),
        );
        final initialCount = repository.wishers.length;

        await repository.deleteWisher('1');

        expect(repository.wishers.length, initialCount);
      });

      test('updateWisher with custom override returns that result', () async {
        final existingWisher = Wisher(
          id: '1',
          userId: 'u',
          firstName: 'A',
          lastName: 'B',
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024),
        );
        final successResult = Result<Wisher>.ok(existingWisher);
        final repository = MockWisherRepository(
          updateWisherResult: successResult,
        );

        final result = await repository.updateWisher(existingWisher);
        expect(result, isA<Ok<Wisher>>());
      });

      test('fetchWishers success updates isLoading to false', () async {
        final repository = MockWisherRepository();
        expect(repository.isLoading, isFalse);

        final future = repository.fetchWishers();
        expect(repository.isLoading, isTrue);

        await future;
        expect(repository.isLoading, isFalse);
        expect(repository.error, isNull);
      });

      test('fetchWishers with error result sets error', () async {
        final error = Exception('fetch failed');
        final repository = MockWisherRepository(
          fetchWishersResult: Result.error(error),
        );

        await repository.fetchWishers();

        expect(repository.error, isNotNull);
        expect(repository.isLoading, isFalse);
      });

      test('fetchWishers notifies listeners', () async {
        final repository = MockWisherRepository();
        var notifyCount = 0;
        repository.addListener(() => notifyCount++);

        await repository.fetchWishers();

        expect(notifyCount, greaterThan(0));
      });

      test('createWisher success adds wisher to list', () async {
        final repository = MockWisherRepository();
        final initialCount = repository.wishers.length;

        final result = await repository.createWisher(
          userId: 'test-user',
          firstName: 'Eve',
          lastName: 'New',
        );

        expect(result, isA<Ok<Wisher>>());
        expect(repository.wishers.length, initialCount + 1);
        expect(repository.wishers.first.firstName, 'Eve');
      });

      test('createWisher success with profilePicture adds it', () async {
        final repository = MockWisherRepository();

        final result = await repository.createWisher(
          userId: 'test-user',
          firstName: 'Eve',
          lastName: 'New',
          profilePicture: 'https://example.com/pic.jpg',
        );

        expect(result, isA<Ok<Wisher>>());
        final created = (result as Ok<Wisher>).value;
        expect(created.profilePicture, 'https://example.com/pic.jpg');
      });

      test('createWisher error result does not add to list', () async {
        final error = Exception('create failed');
        final repository = MockWisherRepository(
          createWisherResult: Result.error(error),
        );
        final initialCount = repository.wishers.length;

        final result = await repository.createWisher(
          userId: 'test-user',
          firstName: 'Eve',
          lastName: 'New',
        );

        expect(result, isA<Error<Wisher>>());
        expect(repository.wishers.length, initialCount);
      });

      test('deleteWisher notifies listeners on success', () async {
        final repository = MockWisherRepository();
        var notified = false;
        repository.addListener(() => notified = true);

        await repository.deleteWisher('1');

        expect(notified, isTrue);
      });

      test('initialWishers parameter overrides default wishers', () {
        final custom = [
          Wisher(
            id: 'custom-1',
            userId: 'u',
            firstName: 'Custom',
            lastName: 'User',
            createdAt: DateTime(2024),
            updatedAt: DateTime(2024),
          ),
        ];
        final repository = MockWisherRepository(initialWishers: custom);

        expect(repository.wishers.length, 1);
        expect(repository.wishers.first.firstName, 'Custom');
      });
    });
  });
}
