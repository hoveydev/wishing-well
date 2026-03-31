import 'package:flutter/foundation.dart';

/// Abstract repository for managing image uploads to Supabase Storage.
///
/// This repository handles uploading images (like profile pictures)
/// to Supabase Storage buckets and returns the public URL.
abstract class ImageRepository extends ChangeNotifier {
  /// Uploads an image file to Supabase Storage.
  ///
  /// [filePath] is the local path to the file.
  /// [bucketName] is the name of the storage bucket.
  /// [folder] is an optional folder path within the bucket.
  ///
  /// Returns the public URL of the uploaded file, or null if upload fails.
  Future<String?> uploadImage({
    required String filePath,
    required String bucketName,
    String? folder,
  });

  /// Deletes a file from Supabase Storage.
  ///
  /// [url] is the public URL or path of the file to delete.
  /// [bucketName] is the name of the storage bucket.
  ///
  /// Returns true if deletion was successful.
  Future<bool> deleteImage({required String url, required String bucketName});

  /// Returns the authorization headers needed to access private storage files.
  ///
  /// Use these headers with NetworkImage to load authenticated images:
  /// ```dart
  /// NetworkImage(
  ///   url,
  ///   headers: imageRepository.getAuthHeaders(),
  /// )
  /// ```
  Map<String, String> getAuthHeaders();

  /// Preloads multiple images into the cache.
  ///
  /// [urls] is a list of image URLs to preload.
  /// Returns after all images have been loaded/cached.
  Future<void> preloadImages(List<String> urls);
}
