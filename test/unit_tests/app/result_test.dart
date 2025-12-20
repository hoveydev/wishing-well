import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/utils/result.dart';

void main() {
  group('Result', () {
    group('Ok', () {
      test('creates Ok result with value', () {
        const Result result = Result<int>.ok(42);

        expect(result, isA<Ok<int>>());
        expect((result as Ok<int>).value, 42);
      });

      test('creates Ok result with String value', () {
        const Result result = Result<String>.ok('success');

        expect(result, isA<Ok<String>>());
        expect((result as Ok<String>).value, 'success');
      });

      test('creates Ok result with null value', () {
        const Result result = Result<String?>.ok(null);

        expect(result, isA<Ok<String?>>());
        expect((result as Ok<String?>).value, null);
      });

      test('creates Ok result with custom object', () {
        final user = _TestUser(id: 1, name: 'John');
        final result = Result<_TestUser>.ok(user);

        expect(result, isA<Ok<_TestUser>>());
        expect((result as Ok<_TestUser>).value, user);
        expect(result.value.id, 1);
        expect(result.value.name, 'John');
      });

      test('creates Ok result with List', () {
        const Result result = Result<List<int>>.ok([1, 2, 3]);

        expect(result, isA<Ok<List<int>>>());
        expect((result as Ok<List<int>>).value, [1, 2, 3]);
      });

      test('toString returns correct format', () {
        const Result result = Result<int>.ok(42);

        expect(result.toString(), 'Result<int>.ok(42)');
      });

      test('Ok preserves type information', () {
        const Result result = Result<int>.ok(42);

        expect(result, isA<Result<int>>());
        expect(result, isA<Ok<int>>());
        expect(result, isNot(isA<Error<int>>()));
      });
    });

    group('Error', () {
      test('creates Error result with exception', () {
        final exception = Exception('Something went wrong');
        final result = Result<int>.error(exception);

        expect(result, isA<Error<int>>());
        expect((result as Error<int>).error, exception);
      });

      test('creates Error result with custom exception', () {
        final exception = _CustomException('Custom error');
        final result = Result<String>.error(exception);

        expect(result, isA<Error<String>>());
        expect((result as Error<String>).error, exception);
        expect((result.error as _CustomException).message, 'Custom error');
      });

      test('toString returns correct format', () {
        final exception = Exception('Test error');
        final result = Result<int>.error(exception);

        expect(
          result.toString(),
          contains('Result<int>.error(Exception: Test error)'),
        );
      });

      test('Error preserves type information', () {
        final exception = Exception('Error');
        final result = Result<String>.error(exception);

        expect(result, isA<Result<String>>());
        expect(result, isA<Error<String>>());
        expect(result, isNot(isA<Ok<String>>()));
      });

      test('Error instances with same exception are not equal', () {
        final exception = Exception('Error');
        final result1 = Result<int>.error(exception);
        final result2 = Result<int>.error(exception);

        expect(identical(result1, result2), false);
      });
    });

    group('Pattern Matching / Type Checking', () {
      test('can switch on Result type', () {
        const Result<int> okResult = Result<int>.ok(42);
        final errorResult = Result<int>.error(Exception('Error'));

        String handleResult(Result<int> result) => switch (result) {
          Ok(value: final v) => 'Success: $v',
          Error(error: final e) => 'Error: $e',
        };

        expect(handleResult(okResult), 'Success: 42');
        expect(handleResult(errorResult), contains('Error:'));
      });

      test('can use is checks', () {
        const Result okResult = Result<int>.ok(42);
        final errorResult = Result<int>.error(Exception('Error'));

        expect(okResult is Ok<int>, true);
        expect(okResult is Error<int>, false);
        expect(errorResult is Error<int>, true);
        expect(errorResult is Ok<int>, false);
      });

      test('can use as casting', () {
        const Result result = Result<int>.ok(42);

        if (result is Ok<int>) {
          expect(result.value, 42);
        }

        final Result<int> errorResult = Result<int>.error(Exception('Error'));

        if (errorResult is Error<int>) {
          expect(errorResult.error, isA<Exception>());
        }
      });
    });

    group('Use Cases', () {
      test('handles async operation success', () async {
        Future<Result<String>> fetchData() async {
          await Future.delayed(const Duration(milliseconds: 10));
          return const Result<String>.ok('data');
        }

        final result = await fetchData();

        expect(result, isA<Ok<String>>());
        expect((result as Ok<String>).value, 'data');
      });

      test('handles async operation failure', () async {
        Future<Result<String>> fetchData() async {
          await Future.delayed(const Duration(milliseconds: 10));
          return Result<String>.error(Exception('Network error'));
        }

        final result = await fetchData();

        expect(result, isA<Error<String>>());
        expect(
          (result as Error<String>).error.toString(),
          contains('Network error'),
        );
      });

      test('works with different return types', () {
        Result<int> parseNumber(String input) {
          final parsed = int.tryParse(input);
          if (parsed != null) {
            return Result<int>.ok(parsed);
          }
          return Result<int>.error(Exception('Invalid number'));
        }

        final success = parseNumber('42');
        final failure = parseNumber('not a number');

        expect(success, isA<Ok<int>>());
        expect((success as Ok<int>).value, 42);

        expect(failure, isA<Error<int>>());
        expect(
          (failure as Error<int>).error.toString(),
          contains('Invalid number'),
        );
      });

      test('can chain operations', () {
        Result<int> divide(int a, int b) {
          if (b == 0) {
            return Result<int>.error(Exception('Division by zero'));
          }
          return Result<int>.ok(a ~/ b);
        }

        String processResult(Result<int> result) => switch (result) {
          Ok(value: final v) => 'Result: $v',
          Error(error: final e) => 'Failed: $e',
        };

        expect(processResult(divide(10, 2)), 'Result: 5');
        expect(processResult(divide(10, 0)), contains('Failed:'));
      });
    });

    group('Edge Cases', () {
      test('Ok with empty string', () {
        const Result result = Result<String>.ok('');

        expect(result, isA<Ok<String>>());
        expect((result as Ok<String>).value, '');
      });

      test('Ok with zero', () {
        const Result result = Result<int>.ok(0);

        expect(result, isA<Ok<int>>());
        expect((result as Ok<int>).value, 0);
      });

      test('Ok with empty list', () {
        const Result result = Result<List<int>>.ok([]);

        expect(result, isA<Ok<List<int>>>());
        expect((result as Ok<List<int>>).value, isEmpty);
      });

      test('Ok with negative number', () {
        const Result result = Result<int>.ok(-42);

        expect(result, isA<Ok<int>>());
        expect((result as Ok<int>).value, -42);
      });

      test('different generic types are incompatible', () {
        const Result intResult = Result<int>.ok(42);
        const Result stringResult = Result<String>.ok('42');

        expect(intResult, isNot(isA<Ok<String>>()));
        expect(stringResult, isNot(isA<Ok<int>>()));
      });
    });
  });
}

// Test helpers
class _TestUser {
  final int id;
  final String name;

  _TestUser({required this.id, required this.name});
}

class _CustomException implements Exception {
  final String message;

  _CustomException(this.message);

  @override
  String toString() => 'CustomException: $message';
}
