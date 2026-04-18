import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/data/repositories/image/image_repository_impl.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('ImageRepositoryImpl', () {
    group('ImageValidationException', () {
      group(TestGroups.initialState, () {
        test('stores message', () {
          const msg = 'test error';
          final exception = ImageValidationException(msg);

          expect(exception.message, msg);
        });

        test('implements Exception', () {
          final exception = ImageValidationException('error');

          expect(exception, isA<Exception>());
        });
      });

      group(TestGroups.behavior, () {
        test('toString includes class name and message', () {
          const msg = 'Invalid file type';
          final exception = ImageValidationException(msg);

          expect(exception.toString(), 'ImageValidationException: $msg');
        });

        test('toString with empty message', () {
          final exception = ImageValidationException('');

          expect(exception.toString(), 'ImageValidationException: ');
        });

        test('two exceptions with same message have same toString', () {
          const msg = 'file too large';
          final a = ImageValidationException(msg);
          final b = ImageValidationException(msg);

          expect(a.toString(), b.toString());
        });

        test(
          'two exceptions with different messages have different toString',
          () {
            final a = ImageValidationException('error A');
            final b = ImageValidationException('error B');

            expect(a.toString(), isNot(b.toString()));
          },
        );

        test('can be caught as Exception', () {
          expect(
            () => throw ImageValidationException('caught'),
            throwsA(isA<ImageValidationException>()),
          );
        });

        test('can be caught as generic Exception', () {
          expect(
            () => throw ImageValidationException('caught'),
            throwsA(isA<Exception>()),
          );
        });
      });
    });
  });
}
