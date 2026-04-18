import 'dart:io';

import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/image/image_repository.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_import.dart';
import 'package:wishing_well/utils/app_logger.dart';
import 'package:wishing_well/utils/result.dart';

typedef AddWisherContactPhotoTempDirectoryFactory =
    Future<Directory> Function();

class AddWisherContactPhotoFileBridge {
  AddWisherContactPhotoFileBridge({
    AddWisherContactPhotoTempDirectoryFactory? tempDirectoryFactory,
  }) : _tempDirectoryFactory =
           tempDirectoryFactory ?? _createTemporaryDirectory;

  final AddWisherContactPhotoTempDirectoryFactory _tempDirectoryFactory;

  Future<File?> createTemporaryFile(
    AddWisherContactImageReference imageReference,
  ) async {
    if (!imageReference.hasBytes) return null;

    final tempDirectory = await _tempDirectoryFactory();
    final sanitizedIdentifier = imageReference.identifier.replaceAll(
      RegExp(r'[^a-zA-Z0-9._-]'),
      '_',
    );
    final file = File(
      '${tempDirectory.path}/'
      '$sanitizedIdentifier.${imageReference.fileExtension}',
    );
    await file.writeAsBytes(imageReference.bytes!, flush: true);
    return file;
  }

  Future<void> deleteTemporaryFile(File? tempImageFile) async {
    if (tempImageFile == null) return;

    try {
      if (await tempImageFile.exists()) {
        await tempImageFile.delete();
      }
    } on Exception {
      AppLogger.warning(
        'Failed to clean up temporary contact photo ${tempImageFile.path}.',
        context: 'AddWisherContactPhotoFileBridge.deleteTemporaryFile',
      );
    }
  }

  static Future<Directory> _createTemporaryDirectory() =>
      Directory.systemTemp.createTemp('wishing_well_contact_photo_');
}

class AddWisherContactBatchImporter {
  AddWisherContactBatchImporter({
    required AuthRepository authRepository,
    required WisherRepository wisherRepository,
    required ImageRepository imageRepository,
    AddWisherContactPhotoFileBridge? photoFileBridge,
    String profilePicturesBucketName = 'profile-pictures',
  }) : _authRepository = authRepository,
       _wisherRepository = wisherRepository,
       _imageRepository = imageRepository,
       _photoFileBridge = photoFileBridge ?? AddWisherContactPhotoFileBridge(),
       _profilePicturesBucketName = profilePicturesBucketName;

  final AuthRepository _authRepository;
  final WisherRepository _wisherRepository;
  final ImageRepository _imageRepository;
  final AddWisherContactPhotoFileBridge _photoFileBridge;
  final String _profilePicturesBucketName;

  AddWisherContactDuplicateReport detectDuplicates(
    List<AddWisherContactImportDraft> drafts,
  ) {
    final existingWishersByName =
        <AddWisherContactNormalizedFullName, List<Wisher>>{};

    for (final wisher in _wisherRepository.wishers) {
      final normalizedName = AddWisherContactNormalizedFullName.maybeFromWisher(
        wisher,
      );
      if (normalizedName == null) continue;

      final matchingWishers = existingWishersByName.putIfAbsent(
        normalizedName,
        () => [],
      );
      matchingWishers.add(wisher);
    }

    final duplicates = <AddWisherContactDuplicateMatch>[];
    final nonDuplicates = <AddWisherContactImportDraft>[];

    for (final draft in drafts) {
      final normalizedName = AddWisherContactNormalizedFullName.maybeFromDraft(
        draft,
      );
      if (normalizedName == null) {
        nonDuplicates.add(draft);
        continue;
      }

      final matchingWishers = existingWishersByName[normalizedName];
      if (matchingWishers == null || matchingWishers.isEmpty) {
        nonDuplicates.add(draft);
        continue;
      }

      duplicates.add(
        AddWisherContactDuplicateMatch(
          draft: draft,
          existingWishers: matchingWishers,
          normalizedFullName: normalizedName,
        ),
      );
    }

    return AddWisherContactDuplicateReport(
      duplicates: duplicates,
      nonDuplicates: nonDuplicates,
    );
  }

  Future<AddWisherContactImportResult> importDrafts(
    List<AddWisherContactImportDraft> drafts,
  ) async {
    const logContext = 'AddWisherContactBatchImporter.importDrafts';
    final userId = _authRepository.currentUserId;

    if (drafts.isEmpty) {
      AppLogger.info('No contact drafts to import.', context: logContext);
      return AddWisherContactImportResult(entries: const []);
    }

    if (userId == null) {
      AppLogger.error(
        'Cannot import contact drafts without an authenticated user.',
        context: logContext,
      );
      return AddWisherContactImportResult(
        entries: drafts
            .map(
              (draft) => AddWisherContactImportResultEntry(
                draft: draft,
                status: AddWisherContactImportResultStatus.failed,
                message: 'No authenticated user.',
              ),
            )
            .toList(growable: false),
      );
    }

    final entries = <AddWisherContactImportResultEntry>[];

    for (final draft in drafts) {
      try {
        final profilePictureUrl = await _uploadProfilePicture(
          draft: draft,
          userId: userId,
          logContext: logContext,
        );
        final response = await _wisherRepository.createWisher(
          userId: userId,
          firstName: draft.firstName,
          lastName: draft.lastName,
          profilePicture: profilePictureUrl,
        );

        switch (response) {
          case Ok(:final value):
            AppLogger.info(
              'Imported contact draft ${draft.sourceId} as wisher ${value.id}.',
              context: logContext,
            );
            entries.add(
              AddWisherContactImportResultEntry(
                draft: draft,
                status: AddWisherContactImportResultStatus.imported,
                createdWisherId: value.id,
              ),
            );
          case Error(:final error):
            AppLogger.error(
              'Failed to import contact draft ${draft.sourceId}.',
              context: logContext,
              error: error,
            );
            entries.add(
              AddWisherContactImportResultEntry(
                draft: draft,
                status: AddWisherContactImportResultStatus.failed,
                message: error.toString(),
              ),
            );
        }
      } on Exception catch (error, stackTrace) {
        AppLogger.error(
          'Failed to import contact draft ${draft.sourceId}.',
          context: logContext,
          error: error,
          stackTrace: stackTrace,
        );
        entries.add(
          AddWisherContactImportResultEntry(
            draft: draft,
            status: AddWisherContactImportResultStatus.failed,
            message: error.toString(),
          ),
        );
      }
    }

    return AddWisherContactImportResult(entries: entries);
  }

  Future<String?> _uploadProfilePicture({
    required AddWisherContactImportDraft draft,
    required String userId,
    required String logContext,
  }) async {
    final imageReference = draft.imageReference;
    if (imageReference == null) return null;

    File? tempImageFile;
    try {
      tempImageFile = await _photoFileBridge.createTemporaryFile(
        imageReference,
      );
      if (tempImageFile == null) return null;

      final profilePictureUrl = await _imageRepository.uploadImage(
        filePath: tempImageFile.path,
        bucketName: _profilePicturesBucketName,
        folder: userId,
      );

      if (profilePictureUrl == null) {
        AppLogger.warning(
          'Failed to upload contact photo for ${draft.sourceId}, '
          'continuing without it.',
          context: logContext,
        );
      }

      return profilePictureUrl;
    } on Exception catch (error, stackTrace) {
      AppLogger.error(
        'Failed to upload contact photo for ${draft.sourceId}, '
        'continuing without it.',
        context: logContext,
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    } finally {
      await _photoFileBridge.deleteTemporaryFile(tempImageFile);
    }
  }
}
