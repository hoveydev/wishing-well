import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_import.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('AddWisherContactSelection', () {
    group(TestGroups.initialState, () {
      test('keeps provided first and last names after normalization', () {
        final selection = AddWisherContactSelection.normalized(
          sourceId: ' contact-1 ',
          firstName: '  Jane ',
          lastName: '  Doe ',
          displayName: 'Jane D.',
        );

        expect(selection.sourceId, 'contact-1');
        expect(selection.firstName, 'Jane');
        expect(selection.lastName, 'Doe');
        expect(selection.originalDisplayName, 'Jane D.');
      });

      test('uses display name when structured names are missing', () {
        final selection = AddWisherContactSelection.normalized(
          sourceId: 'contact-2',
          displayName: '  Mary Anne Smith  ',
        );

        expect(selection.firstName, 'Mary');
        expect(selection.lastName, 'Anne Smith');
        expect(selection.name, 'Mary Anne Smith');
      });

      test('allows empty names when source has no usable name data', () {
        final selection = AddWisherContactSelection.normalized(
          sourceId: 'contact-3',
          firstName: '   ',
          displayName: '   ',
        );

        expect(selection.hasName, isFalse);
        expect(selection.firstName, isEmpty);
        expect(selection.lastName, isEmpty);
        expect(selection.summaryLabel, 'contact-3');
      });
    });

    group(TestGroups.behavior, () {
      test('toDraft maps the fields needed for wisher creation', () {
        const imageReference = AddWisherContactImageReference(
          identifier: 'image-1',
        );
        final selection = AddWisherContactSelection.normalized(
          sourceId: 'contact-4',
          firstName: 'Taylor',
          lastName: '',
          displayName: 'Taylor Swift',
          imageReference: imageReference,
        );

        final draft = selection.toDraft();

        expect(
          draft,
          const AddWisherContactImportDraft(
            sourceId: 'contact-4',
            firstName: 'Taylor',
            lastName: '',
            sourceDisplayName: 'Taylor Swift',
            imageReference: imageReference,
          ),
        );
        expect(draft.summaryLabel, 'Taylor');
      });

      test('toDraft propagates birthday into the draft', () {
        final birthday = DateTime(1990, 6, 15);
        final selection = AddWisherContactSelection.normalized(
          sourceId: 'contact-bday',
          firstName: 'Jane',
          lastName: 'Doe',
          birthday: birthday,
        );

        final draft = selection.toDraft();
        expect(draft.birthday, birthday);
      });

      test('toDraft has null birthday when selection has no birthday', () {
        final selection = AddWisherContactSelection.normalized(
          sourceId: 'contact-nobday',
          firstName: 'John',
          lastName: 'Smith',
        );

        final draft = selection.toDraft();
        expect(draft.birthday, isNull);
      });

      test('summaryLabel falls back to source display name when needed', () {
        const draft = AddWisherContactImportDraft(
          sourceId: 'contact-5',
          firstName: '',
          lastName: '',
          sourceDisplayName: 'Mom',
        );

        expect(draft.summaryLabel, 'Mom');
      });
    });
  });

  group('AddWisherContactImportResultEntry', () {
    test('tracks imported, skipped, and failed states', () {
      const draft = AddWisherContactImportDraft(
        sourceId: 'contact-6',
        firstName: 'Alex',
        lastName: 'Morgan',
        sourceDisplayName: 'Alex Morgan',
      );

      const importedEntry = AddWisherContactImportResultEntry(
        draft: draft,
        status: AddWisherContactImportResultStatus.imported,
        createdWisherId: 'wisher-1',
      );
      const skippedEntry = AddWisherContactImportResultEntry(
        draft: draft,
        status: AddWisherContactImportResultStatus.skipped,
        message: 'Already exists',
      );
      const failedEntry = AddWisherContactImportResultEntry(
        draft: draft,
        status: AddWisherContactImportResultStatus.failed,
        message: 'Upload failed',
      );

      expect(importedEntry.isImported, isTrue);
      expect(importedEntry.isSkipped, isFalse);
      expect(importedEntry.isFailed, isFalse);

      expect(skippedEntry.isImported, isFalse);
      expect(skippedEntry.isSkipped, isTrue);
      expect(skippedEntry.isFailed, isFalse);

      expect(failedEntry.isImported, isFalse);
      expect(failedEntry.isSkipped, isFalse);
      expect(failedEntry.isFailed, isTrue);
    });
  });

  group('AddWisherContactNormalizedFullName', () {
    test('normalizes trimmed names case-insensitively', () {
      final normalizedName = AddWisherContactNormalizedFullName.maybeFromParts(
        firstName: '  Jane ',
        lastName: ' DOE  ',
      );

      expect(normalizedName, isNotNull);
      expect(normalizedName?.firstName, 'jane');
      expect(normalizedName?.lastName, 'doe');
      expect(normalizedName?.fullName, 'jane doe');
    });

    test('returns null when either name part is blank', () {
      expect(
        AddWisherContactNormalizedFullName.maybeFromParts(
          firstName: 'Jane',
          lastName: '   ',
        ),
        isNull,
      );
      expect(
        AddWisherContactNormalizedFullName.maybeFromParts(
          firstName: '   ',
          lastName: 'Doe',
        ),
        isNull,
      );
    });
  });
}
