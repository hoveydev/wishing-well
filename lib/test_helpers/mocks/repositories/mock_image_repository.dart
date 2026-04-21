import 'dart:io';

import 'package:wishing_well/data/repositories/image/image_repository.dart';

/// Mock implementation of [ImageRepository] for testing.
///
/// This mock simulates successful uploads by returning a fake public URL.
class MockImageRepository extends ImageRepository {
  MockImageRepository({
    this.uploadResult,
    this.deleteResult = true,
    this.delay = Duration.zero,
  });

  /// Custom upload result to return (null for failure, URL for success)
  final String? uploadResult;

  /// Result of delete operation
  final bool deleteResult;

  /// Optional delay to simulate network latency
  final Duration delay;

  @override
  Future<String?> uploadImage({
    required String filePath,
    required String bucketName,
    String? folder,
    File? precompressedFile,
  }) async {
    await Future.delayed(delay);

    // Return the configured result or a fake URL
    return uploadResult ??
        'https://example.com/storage/$bucketName/${folder ?? 'uploads'}/mock-image.jpg';
  }

  @override
  Future<File?> compressImage(String filePath) async => null;

  @override
  Future<bool> deleteImage({
    required String url,
    required String bucketName,
  }) async {
    await Future.delayed(delay);
    return deleteResult;
  }

  @override
  Map<String, String> getAuthHeaders() =>
      {'Authorization': 'Bearer mock-token'};

  @override
  Future<void> preloadImages(List<String> urls) async {
    // No-op for mock
  }
}
