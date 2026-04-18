import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';

void main() {
  group('MockImageRepository', () {
    late MockImageRepository repository;

    setUp(() {
      repository = MockImageRepository();
    });

    tearDown(() {
      repository.dispose();
    });

    group(TestGroups.initialState, () {
      test('is a ChangeNotifier', () {
        expect(repository, isA<ChangeNotifier>());
      });

      test('uploadResult is null by default', () {
        expect(repository.uploadResult, isNull);
      });

      test('deleteResult is true by default', () {
        expect(repository.deleteResult, isTrue);
      });

      test('delay is zero by default', () {
        expect(repository.delay, Duration.zero);
      });
    });

    group(TestGroups.behavior, () {
      test('uploadImage returns fake URL when uploadResult is null', () async {
        final url = await repository.uploadImage(
          filePath: '/path/to/image.jpg',
          bucketName: 'profile-pictures',
        );

        expect(url, isNotNull);
        expect(url, contains('https://example.com/storage'));
        expect(url, contains('profile-pictures'));
      });

      test('uploadImage returns configured uploadResult when set', () async {
        const expected = 'https://my-cdn.com/image.jpg';
        repository = MockImageRepository(uploadResult: expected);

        final url = await repository.uploadImage(
          filePath: '/path/to/image.jpg',
          bucketName: 'profile-pictures',
        );

        expect(url, expected);
      });

      test(
        'uploadImage returns fake URL when uploadResult default is used',
        () async {
          repository = MockImageRepository();

          final url = await repository.uploadImage(
            filePath: '/path/to/image.jpg',
            bucketName: 'profile-pictures',
          );

          expect(url, isNotNull);
        },
      );

      test(
        'uploadImage uses folder in default URL when folder is provided',
        () async {
          final url = await repository.uploadImage(
            filePath: '/path/to/image.jpg',
            bucketName: 'profile-pictures',
            folder: 'avatars',
          );

          expect(url, contains('avatars'));
        },
      );

      test(
        'uploadImage accepts precompressedFile param and returns URL',
        () async {
          final tmpFile = File(
            '${Directory.systemTemp.path}/test_mock_precompressed.webp',
          );
          tmpFile.createSync();
          addTearDown(tmpFile.deleteSync);

          final url = await repository.uploadImage(
            filePath: '/path/to/image.jpg',
            bucketName: 'profile-pictures',
            precompressedFile: tmpFile,
          );

          expect(url, isNotNull);
        },
      );

      test('compressImage returns null', () async {
        final result = await repository.compressImage('/path/to/image.jpg');

        expect(result, isNull);
      });

      test('deleteImage returns true by default', () async {
        final result = await repository.deleteImage(
          url: 'https://example.com/image.jpg',
          bucketName: 'profile-pictures',
        );

        expect(result, isTrue);
      });

      test('deleteImage returns configured deleteResult', () async {
        repository = MockImageRepository(deleteResult: false);

        final result = await repository.deleteImage(
          url: 'https://example.com/image.jpg',
          bucketName: 'profile-pictures',
        );

        expect(result, isFalse);
      });

      test('getAuthHeaders returns map with Authorization key', () {
        final headers = repository.getAuthHeaders();

        expect(headers, isA<Map<String, String>>());
        expect(headers.containsKey('Authorization'), isTrue);
      });

      test('preloadImages completes without error', () async {
        await expectLater(
          repository.preloadImages([
            'https://example.com/a.jpg',
            'https://example.com/b.jpg',
          ]),
          completes,
        );
      });

      test('uploadImage with delay waits before returning', () async {
        const delay = Duration(milliseconds: 50);
        repository = MockImageRepository(delay: delay);

        final stopwatch = Stopwatch()..start();
        await repository.uploadImage(
          filePath: '/path/to/image.jpg',
          bucketName: 'bucket',
        );
        stopwatch.stop();

        expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(50));
      });
    });
  });
}
