import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/utils/result.dart';

void main() {
  group('MockWisherRepository - delay feature', () {
    group(TestGroups.behavior, () {
      test('default delay is Duration.zero', () {
        final repository = MockWisherRepository();
        expect(repository.delay, Duration.zero);
      });

      test('custom delay is applied', () {
        const delay = Duration(seconds: 2);
        final repository = MockWisherRepository(delay: delay);
        expect(repository.delay, const Duration(seconds: 2));
      });

      test('createWisher respects delay parameter', () async {
        const delay = Duration(milliseconds: 100);
        final repository = MockWisherRepository(delay: delay);

        final stopwatch = Stopwatch()..start();
        final result = await repository.createWisher(
          userId: 'user-1',
          firstName: 'John',
          lastName: 'Doe',
        );
        stopwatch.stop();

        // Should have taken at least the delay duration
        expect(stopwatch.elapsed, greaterThanOrEqualTo(delay));
        expect(result, isA<Ok<Wisher>>());
      });

      test('createWisher with error result also respects delay', () async {
        const delay = Duration(milliseconds: 100);
        final repository = MockWisherRepository(
          createWisherResult: Result.error(Exception('Test error')),
          delay: delay,
        );

        final stopwatch = Stopwatch()..start();
        final result = await repository.createWisher(
          userId: 'user-1',
          firstName: 'John',
          lastName: 'Doe',
        );
        stopwatch.stop();

        // Should have taken at least the delay duration
        expect(stopwatch.elapsed, greaterThanOrEqualTo(delay));
        expect(result, isA<Error<Wisher>>());
      });

      test('zero delay executes quickly', () async {
        // Use default delay (Duration.zero)
        final repository = MockWisherRepository();

        final stopwatch = Stopwatch()..start();
        final result = await repository.createWisher(
          userId: 'user-1',
          firstName: 'John',
          lastName: 'Doe',
        );
        stopwatch.stop();

        // With zero delay, should be very fast (less than 50ms typically)
        expect(stopwatch.elapsed, lessThan(const Duration(milliseconds: 50)));
        expect(result, isA<Ok<Wisher>>());
      });

      test('long delay works correctly', () async {
        const delay = Duration(milliseconds: 500);
        final repository = MockWisherRepository(delay: delay);

        final stopwatch = Stopwatch()..start();
        await repository.createWisher(
          userId: 'user-1',
          firstName: 'John',
          lastName: 'Doe',
        );
        stopwatch.stop();

        // Should have taken approximately the delay duration
        expect(
          stopwatch.elapsed.inMilliseconds,
          greaterThanOrEqualTo(delay.inMilliseconds - 10),
        );
      });
    });

    group('delay with different scenarios', () {
      test('delay works with initial wishers', () async {
        const delay = Duration(milliseconds: 50);
        final initialWishers = [
          Wisher(
            id: '1',
            userId: 'test-user',
            firstName: 'Existing',
            lastName: 'Wisher',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];

        final repository = MockWisherRepository(
          initialWishers: initialWishers,
          delay: delay,
        );

        // Initial wishers should be available immediately
        expect(repository.wishers.length, 1);

        // But createWisher should still have delay
        final stopwatch = Stopwatch()..start();
        await repository.createWisher(
          userId: 'user-1',
          firstName: 'New',
          lastName: 'Wisher',
        );
        stopwatch.stop();

        expect(stopwatch.elapsed, greaterThanOrEqualTo(delay));
      });

      test(
        'delay works with null createWisherResult (loading scenario)',
        () async {
          // When createWisherResult is null (not provided), uses default
          final repository = MockWisherRepository();

          final stopwatch = Stopwatch()..start();
          final result = await repository.createWisher(
            userId: 'user-1',
            firstName: 'John',
            lastName: 'Doe',
          );
          stopwatch.stop();

          // Should have default delay (Duration.zero)
          expect(stopwatch.elapsed, lessThan(const Duration(milliseconds: 10)));
          // With null result, it returns the default success
          expect(result, isA<Ok<Wisher>>());
        },
      );
    });

    group('edge cases', () {
      test('very small delay (1ms) works', () async {
        const delay = Duration(milliseconds: 1);
        final repository = MockWisherRepository(delay: delay);

        final stopwatch = Stopwatch()..start();
        await repository.createWisher(
          userId: 'user-1',
          firstName: 'John',
          lastName: 'Doe',
        );
        stopwatch.stop();

        // Should complete (may or may not hit exactly 1ms)
        expect(stopwatch.elapsed, greaterThan(Duration.zero));
      });

      test('multiple concurrent calls each respect delay', () async {
        const delay = Duration(milliseconds: 50);
        final repository = MockWisherRepository(delay: delay);

        // Make multiple calls concurrently
        final futures = List.generate(
          3,
          (_) => repository.createWisher(
            userId: 'user-1',
            firstName: 'John',
            lastName: 'Doe',
          ),
        );

        final stopwatch = Stopwatch()..start();
        final results = await Future.wait(futures);
        stopwatch.stop();

        // All should succeed
        for (final result in results) {
          expect(result, isA<Ok<Wisher>>());
        }

        // Since they run concurrently, total time should be ~delay
        // (not delay * 3)
        expect(stopwatch.elapsed, lessThan(const Duration(milliseconds: 150)));
      });
    });
  });
}
