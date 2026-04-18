import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/data/repositories/image/image_repository.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_batch_importer.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_import.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/utils/result.dart';

void main() {
  group('AddWisherContactBatchImporter', () {
    group(TestGroups.behavior, () {
      test('detects duplicates by normalized first and last name '
          'against existing wishers', () async {
        final authRepository = MockAuthRepository(userId: 'user-1');
        await authRepository.login(email: 'test@example.com', password: 'pw');
        final importer = AddWisherContactBatchImporter(
          authRepository: authRepository,
          wisherRepository: MockWisherRepository(
            initialWishers: [
              Wisher(
                id: 'existing-1',
                userId: 'user-1',
                firstName: 'Alex',
                lastName: 'Morgan',
                createdAt: DateTime(2024),
                updatedAt: DateTime(2024),
              ),
              Wisher(
                id: 'existing-2',
                userId: 'user-1',
                firstName: 'Jordan',
                lastName: 'Lee',
                createdAt: DateTime(2024, 1, 2),
                updatedAt: DateTime(2024, 1, 2),
              ),
            ],
          ),
          imageRepository: _RecordingImageRepository(),
        );

        final report = importer.detectDuplicates([
          const AddWisherContactImportDraft(
            sourceId: 'contact-1',
            firstName: ' alex ',
            lastName: ' MORGAN ',
            sourceDisplayName: 'Alex Morgan',
          ),
          const AddWisherContactImportDraft(
            sourceId: 'contact-2',
            firstName: 'Taylor',
            lastName: 'Swift',
            sourceDisplayName: 'Taylor Swift',
          ),
        ]);

        expect(report.hasDuplicates, isTrue);
        expect(report.duplicateCount, 1);
        expect(report.duplicates.single.draft.sourceId, 'contact-1');
        expect(
          report.duplicates.single.existingWishers.single.id,
          'existing-1',
        );
        expect(report.nonDuplicates.single.sourceId, 'contact-2');
      });

      test('ignores duplicate detection when a draft or existing wisher '
          'lacks a full name', () async {
        final authRepository = MockAuthRepository(userId: 'user-1');
        await authRepository.login(email: 'test@example.com', password: 'pw');
        final importer = AddWisherContactBatchImporter(
          authRepository: authRepository,
          wisherRepository: MockWisherRepository(
            initialWishers: [
              Wisher(
                id: 'existing-1',
                userId: 'user-1',
                firstName: 'Alex',
                lastName: '',
                createdAt: DateTime(2024),
                updatedAt: DateTime(2024),
              ),
              Wisher(
                id: 'existing-2',
                userId: 'user-1',
                firstName: 'Taylor',
                lastName: 'Swift',
                createdAt: DateTime(2024, 1, 2),
                updatedAt: DateTime(2024, 1, 2),
              ),
            ],
          ),
          imageRepository: _RecordingImageRepository(),
        );

        final report = importer.detectDuplicates([
          const AddWisherContactImportDraft(
            sourceId: 'contact-1',
            firstName: 'Alex',
            lastName: '',
            sourceDisplayName: 'Alex',
          ),
          const AddWisherContactImportDraft(
            sourceId: 'contact-2',
            firstName: 'Taylor',
            lastName: 'Swift',
            sourceDisplayName: 'Taylor Swift',
          ),
        ]);

        expect(report.hasDuplicates, isTrue);
        expect(report.duplicateCount, 1);
        expect(report.duplicates.single.draft.sourceId, 'contact-2');
        expect(report.nonDuplicates.map((draft) => draft.sourceId), [
          'contact-1',
        ]);
      });

      test(
        'continues importing remaining drafts when createWisher throws',
        () async {
          final authRepository = MockAuthRepository(userId: 'user-1');
          await authRepository.login(email: 'test@example.com', password: 'pw');
          final importer = AddWisherContactBatchImporter(
            authRepository: authRepository,
            wisherRepository: _ThrowingOnceWisherRepository(),
            imageRepository: _RecordingImageRepository(),
          );

          final result = await importer.importDrafts([
            const AddWisherContactImportDraft(
              sourceId: 'contact-1',
              firstName: 'Alex',
              lastName: 'Morgan',
              sourceDisplayName: 'Alex Morgan',
            ),
            const AddWisherContactImportDraft(
              sourceId: 'contact-2',
              firstName: 'Taylor',
              lastName: 'Swift',
              sourceDisplayName: 'Taylor Swift',
            ),
          ]);

          expect(result.isPartialSuccess, isTrue);
          expect(result.importedCount, 1);
          expect(result.failedCount, 1);
          expect(result.failedEntries.single.draft.sourceId, 'contact-1');
          expect(result.importedEntries.single.draft.sourceId, 'contact-2');
        },
      );

      test(
        'uploads a contact photo and saves it on the imported wisher',
        () async {
          final authRepository = MockAuthRepository(userId: 'user-1');
          await authRepository.login(email: 'test@example.com', password: 'pw');
          final wisherRepository = MockWisherRepository(initialWishers: []);
          final imageRepository = _RecordingImageRepository(
            uploadResult: 'https://example.com/profile.jpg',
          );
          final photoFileBridge = _FakePhotoFileBridge();
          final importer = AddWisherContactBatchImporter(
            authRepository: authRepository,
            wisherRepository: wisherRepository,
            imageRepository: imageRepository,
            photoFileBridge: photoFileBridge,
          );
          final imageReference = AddWisherContactImageReference(
            identifier: 'flutter_contacts:contact-1',
            bytes: Uint8List.fromList([1, 2, 3]),
          );

          final result = await importer.importDrafts([
            AddWisherContactImportDraft(
              sourceId: 'contact-1',
              firstName: 'Alex',
              lastName: 'Morgan',
              sourceDisplayName: 'Alex Morgan',
              imageReference: imageReference,
            ),
          ]);

          expect(result.isFullSuccess, isTrue);
          expect(imageRepository.uploadCalls, 1);
          expect(imageRepository.lastUpload, (
            filePath: '/mock/contact-photo.jpg',
            bucketName: 'profile-pictures',
            folder: 'user-1',
          ));
          expect(photoFileBridge.lastReference, imageReference);
          expect(
            wisherRepository.wishers.single.profilePicture,
            'https://example.com/profile.jpg',
          );
        },
      );

      test('continues importing when contact photo upload throws', () async {
        final authRepository = MockAuthRepository(userId: 'user-1');
        await authRepository.login(email: 'test@example.com', password: 'pw');
        final wisherRepository = MockWisherRepository(initialWishers: []);
        final importer = AddWisherContactBatchImporter(
          authRepository: authRepository,
          wisherRepository: wisherRepository,
          imageRepository: _RecordingImageRepository(throwOnUpload: true),
          photoFileBridge: _FakePhotoFileBridge(),
        );

        final result = await importer.importDrafts([
          AddWisherContactImportDraft(
            sourceId: 'contact-1',
            firstName: 'Alex',
            lastName: 'Morgan',
            sourceDisplayName: 'Alex Morgan',
            imageReference: AddWisherContactImageReference(
              identifier: 'flutter_contacts:contact-1',
              bytes: Uint8List.fromList([1, 2, 3]),
            ),
          ),
        ]);

        expect(result.isFullSuccess, isTrue);
        expect(wisherRepository.wishers.single.profilePicture, isNull);
      });
    });
  });
}

class _ThrowingOnceWisherRepository extends MockWisherRepository {
  int createCalls = 0;

  @override
  Future<Result<Wisher>> createWisher({
    required String userId,
    required String firstName,
    required String lastName,
    String? profilePicture,
  }) async {
    createCalls += 1;
    if (createCalls == 1) {
      throw Exception('create failed');
    }

    return super.createWisher(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      profilePicture: profilePicture,
    );
  }
}

class _RecordingImageRepository extends ImageRepository {
  _RecordingImageRepository({this.uploadResult, this.throwOnUpload = false});

  final String? uploadResult;
  final bool throwOnUpload;
  int uploadCalls = 0;
  ({String filePath, String bucketName, String? folder})? lastUpload;

  @override
  Future<String?> uploadImage({
    required String filePath,
    required String bucketName,
    String? folder,
    File? precompressedFile,
  }) async {
    uploadCalls += 1;
    lastUpload = (filePath: filePath, bucketName: bucketName, folder: folder);

    if (throwOnUpload) {
      throw Exception('upload failed');
    }

    return uploadResult;
  }

  @override
  Future<File?> compressImage(String filePath) async => null;

  @override
  Future<bool> deleteImage({
    required String url,
    required String bucketName,
  }) async => true;

  @override
  Map<String, String> getAuthHeaders() => const {};

  @override
  Future<void> preloadImages(List<String> urls) async {}
}

class _FakePhotoFileBridge extends AddWisherContactPhotoFileBridge {
  _FakePhotoFileBridge();

  AddWisherContactImageReference? lastReference;

  @override
  Future<File?> createTemporaryFile(
    AddWisherContactImageReference imageReference,
  ) async {
    lastReference = imageReference;
    return File('/mock/contact-photo.jpg');
  }
}
