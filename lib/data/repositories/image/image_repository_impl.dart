import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:wishing_well/data/repositories/image/image_repository.dart';
import 'package:wishing_well/utils/app_logger.dart';

/// Allowed image extensions for profile pictures
const _allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

/// Maximum file size for profile pictures (5MB)
const _maxFileSizeBytes = 5 * 1024 * 1024; // 5MB

/// Target width for image compression (maintains aspect ratio)
const _targetWidth = 512;

/// Compression quality (0-100)
const _compressQuality = 80;

/// Custom exception for storage validation errors
class ImageValidationException implements Exception {
  ImageValidationException(this.message);
  final String message;

  @override
  String toString() => 'ImageValidationException: $message';
}

/// Implementation of [ImageRepository] using Supabase Storage.
///
/// This class handles image uploads to Supabase Storage buckets,
/// generates unique file paths using UUID, and manages public URLs.
class ImageRepositoryImpl extends ImageRepository {
  ImageRepositoryImpl({required SupabaseClient supabase})
    : _supabase = supabase;

  final SupabaseClient _supabase;
  final Uuid _uuid = const Uuid();

  /// Constructs an authenticated URL for accessing a private storage file.
  String _getAuthenticatedUrl(String bucketName, String path) {
    // Get the public URL and replace /object/public/ with /object/authenticated/
    // This allows authenticated access to private buckets
    final publicUrl = _supabase.storage.from(bucketName).getPublicUrl(path);
    return publicUrl.replaceAll('/object/public/', '/object/authenticated/');
  }

  /// Validates the file before upload
  void _validateFile(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();

    // Check file extension
    if (!_allowedExtensions.contains(extension)) {
      throw ImageValidationException(
        'Invalid file type. Allowed types: ${_allowedExtensions.join(", ")}',
      );
    }

    // Check file size
    final file = File(filePath);
    if (file.existsSync()) {
      final fileSize = file.lengthSync();
      if (fileSize > _maxFileSizeBytes) {
        const maxSizeMB = _maxFileSizeBytes ~/ (1024 * 1024);
        throw ImageValidationException(
          'File too large. Maximum size is $maxSizeMB MB',
        );
      }
    }
  }

  /// Compresses an image file to reduce file size while maintaining quality.
  /// Returns the compressed [File], or null if compression fails.
  @override
  Future<File?> compressImage(String filePath) async {
    try {
      // Always convert to WebP for best compression across all input formats
      const outputExtension = 'webp';
      const format = CompressFormat.webp;

      AppLogger.debug(
        'Compressing image: $filePath',
        context: 'ImageRepositoryImpl.compressImage',
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        '${filePath}_compressed.$outputExtension',
        quality: _compressQuality,
        minWidth: _targetWidth,
        minHeight: _targetWidth,
        format: format,
      );

      if (result != null) {
        final compressedFile = File(result.path);
        final originalSize = File(filePath).lengthSync();
        final compressedSize = compressedFile.lengthSync();

        final reductionPercent = ((1 - compressedSize / originalSize) * 100)
            .toStringAsFixed(0);
        AppLogger.info(
          'Image compressed: ${(originalSize / 1024).toStringAsFixed(1)}KB'
          ' -> ${(compressedSize / 1024).toStringAsFixed(1)}KB'
          ' ($reductionPercent% reduction)',
          context: 'ImageRepositoryImpl.compressImage',
        );

        return compressedFile;
      }

      return null;
    } catch (e) {
      AppLogger.warning(
        'Image compression failed: $e',
        context: 'ImageRepositoryImpl.compressImage',
      );
      return null;
    }
  }

  @override
  Future<String?> uploadImage({
    required String filePath,
    required String bucketName,
    String? folder,
    File? precompressedFile,
  }) async {
    try {
      // Validate file before upload
      _validateFile(filePath);

      var file = File(filePath);
      if (!await file.exists()) {
        AppLogger.error(
          'File does not exist: $filePath',
          context: 'ImageRepositoryImpl.uploadImage',
        );
        return null;
      }

      // Use pre-compressed file if provided, otherwise compress now
      File? compressedFile;
      if (precompressedFile != null) {
        file = precompressedFile;
      } else {
        compressedFile = await compressImage(filePath);
        if (compressedFile != null) {
          file = compressedFile;
        }
      }

      // Generate a unique filename to avoid collisions
      // Use the actual file's extension (may differ if converted to webp)
      final fileName = _uuid.v4();
      final extension = file.path.split('.').last.toLowerCase();
      final fullPath = folder != null
          ? '$folder/$fileName.$extension'
          : '$fileName.$extension';

      AppLogger.debug(
        'Uploading image to bucket: $bucketName, path: $fullPath',
        context: 'ImageRepositoryImpl.uploadImage',
      );

      // Upload the file to Supabase Storage
      final response = await _supabase.storage
          .from(bucketName)
          .upload(fullPath, file);

      if (response.isEmpty) {
        AppLogger.error(
          'Upload returned empty response',
          context: 'ImageRepositoryImpl.uploadImage',
        );
        return null;
      }

      // Clean up internally-compressed file if one was created here
      if (compressedFile != null) {
        try {
          await compressedFile.delete();
        } catch (_) {
          // Ignore cleanup errors
        }
      }

      // Get the authenticated URL instead of public URL
      // The bucket is not public, so we use the authenticated endpoint
      final url = _getAuthenticatedUrl(bucketName, fullPath);

      AppLogger.info(
        'Image uploaded successfully: $url',
        context: 'ImageRepositoryImpl.uploadImage',
      );

      return url;
    } on ImageValidationException catch (e) {
      AppLogger.warning(
        'File validation failed: ${e.message}',
        context: 'ImageRepositoryImpl.uploadImage',
      );
      rethrow; // Re-throw so the caller can handle the user-friendly message
    } on StorageException catch (e) {
      AppLogger.error(
        'Storage exception during upload: ${e.message}',
        context: 'ImageRepositoryImpl.uploadImage',
        error: e,
      );
      return null;
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'Failed to upload image: $e',
        context: 'ImageRepositoryImpl.uploadImage',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  @override
  Future<bool> deleteImage({
    required String url,
    required String bucketName,
  }) async {
    try {
      // Extract the path from the URL
      // Supabase storage URLs are typically: {supabaseUrl}/storage/v1/object/public/{bucketName}/{path}
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;

      // Find the bucket name position and extract the file path
      final bucketIndex = pathSegments.indexOf(bucketName);
      if (bucketIndex == -1 || bucketIndex >= pathSegments.length - 1) {
        AppLogger.error(
          'Invalid storage URL: $url',
          context: 'ImageRepositoryImpl.deleteImage',
        );
        return false;
      }

      final filePath = pathSegments.sublist(bucketIndex + 1).join('/');

      AppLogger.debug(
        'Deleting image: bucket: $bucketName, path: $filePath',
        context: 'ImageRepositoryImpl.deleteImage',
      );

      await _supabase.storage.from(bucketName).remove([filePath]);

      AppLogger.info(
        'Image deleted successfully: $filePath',
        context: 'ImageRepositoryImpl.deleteImage',
      );

      return true;
    } on StorageException catch (e) {
      AppLogger.error(
        'Storage exception during delete: ${e.message}',
        context: 'ImageRepositoryImpl.deleteImage',
        error: e,
      );
      return false;
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete image: $e',
        context: 'ImageRepositoryImpl.deleteImage',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  @override
  Map<String, String> getAuthHeaders() {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      return {'Authorization': 'Bearer ${session.accessToken}'};
    }
    return {};
  }

  @override
  Future<void> preloadImages(List<String> urls) async {
    if (urls.isEmpty) return;

    final headers = getAuthHeaders();

    // Load all images into cache in parallel
    await Future.wait(
      urls.map((url) async {
        try {
          // Use DefaultCacheManager to preload into disk cache
          await DefaultCacheManager().getSingleFile(url, headers: headers);
        } catch (e) {
          // Silently ignore preload failures
          AppLogger.debug(
            'Preload failed for $url: $e',
            context: 'ImageRepositoryImpl.preloadImages',
          );
        }
      }),
    );

    AppLogger.info(
      'Preloaded ${urls.length} images',
      context: 'ImageRepositoryImpl.preloadImages',
    );
  }
}
