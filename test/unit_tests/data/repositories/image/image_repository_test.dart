import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';

/// Tests for the [ImageRepository] abstract interface.
///
/// The interface is exercised here through [MockImageRepository], which
/// provides a complete, in-memory implementation that satisfies the contract.
void main() {
  group('ImageRepository', () {
    late MockImageRepository repository;

    setUp(() {
      repository = MockImageRepository();
    });

    tearDown(() {
      repository.dispose();
    });

    group(TestGroups.initialState, () {
      test('extends ChangeNotifier', () {
        expect(repository, isA<ChangeNotifier>());
      });
    });

    group('uploadImage contract', () {
      test('returns a String URL on success', () async {
        final result = await repository.uploadImage(
          filePath: '/path/to/image.jpg',
          bucketName: 'profile-pictures',
        );

        expect(result, isA<String>());
      });

      test('accepts optional folder parameter', () async {
        final result = await repository.uploadImage(
          filePath: '/path/to/image.jpg',
          bucketName: 'profile-pictures',
          folder: 'subfolder',
        );

        expect(result, isNotNull);
      });

      test('accepts precompressedFile and returns a URL', () async {
        final tmpFile = File(
          '${Directory.systemTemp.path}/test_precompressed.webp',
        );
        tmpFile.createSync();
        addTearDown(tmpFile.deleteSync);

        final result = await repository.uploadImage(
          filePath: '/path/to/image.jpg',
          bucketName: 'profile-pictures',
          precompressedFile: tmpFile,
        );

        expect(result, isNotNull);
      });

      test('returns configured uploadResult URL', () async {
        const expectedUrl = 'https://example.com/mock.jpg';
        repository = MockImageRepository(uploadResult: expectedUrl);

        final result = await repository.uploadImage(
          filePath: '/path/to/image.jpg',
          bucketName: 'profile-pictures',
        );

        expect(result, expectedUrl);
      });

      test('can return null to signal upload failure', () async {
        // Stub that always returns null simulates a failed upload.
        final nullRepository = _NullUploadRepository();
        addTearDown(nullRepository.dispose);

        final result = await nullRepository.uploadImage(
          filePath: '/path/to/image.jpg',
          bucketName: 'profile-pictures',
        );

        expect(result, isNull);
      });
    });

    group('compressImage contract', () {
      test('returns Future<File?>', () {
        expect(repository.compressImage('/path/to/image.jpg'), isA<Future>());
      });

      test('resolves without throwing', () async {
        await expectLater(
          repository.compressImage('/path/to/image.jpg'),
          completes,
        );
      });
    });

    group('deleteImage contract', () {
      test('returns a bool', () async {
        final result = await repository.deleteImage(
          url: 'https://example.com/image.jpg',
          bucketName: 'profile-pictures',
        );

        expect(result, isA<bool>());
      });
    });

    group('getAuthHeaders contract', () {
      test('returns a Map<String, String>', () {
        final headers = repository.getAuthHeaders();

        expect(headers, isA<Map<String, String>>());
      });
    });

    group('preloadImages contract', () {
      test('accepts a list of URLs and completes', () async {
        await expectLater(
          repository.preloadImages(['https://example.com/a.jpg']),
          completes,
        );
      });

      test('accepts an empty list without throwing', () async {
        await expectLater(repository.preloadImages([]), completes);
      });
    });
  });
}

/// Stub that returns null from [uploadImage] to exercise the failure path.
class _NullUploadRepository extends MockImageRepository {
  @override
  Future<String?> uploadImage({
    required String filePath,
    required String bucketName,
    String? folder,
    File? precompressedFile,
  }) async => null;
}
