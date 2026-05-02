import 'dart:typed_data';

import 'package:flutter_contacts/flutter_contacts.dart' as contacts;
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_access.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_import.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('AddWisherContactSelectionMapper', () {
    group(TestGroups.behavior, () {
      const mapper = AddWisherContactSelectionMapper();

      test('maps structured plugin contact data into a selection', () {
        final photoBytes = Uint8List.fromList([4, 5, 6]);
        final selection = mapper.map(
          contacts.Contact(
            id: 'contact-1',
            displayName: 'Jane Doe',
            name: const contacts.Name(
              first: 'Jane',
              middle: 'Anne',
              last: 'Doe',
            ),
            photo: contacts.Photo(
              thumbnail: Uint8List.fromList([1, 2, 3]),
              fullSize: photoBytes,
            ),
          ),
        );

        expect(selection.sourceId, 'contact-1');
        expect(selection.firstName, 'Jane');
        expect(selection.lastName, 'Anne Doe');
        expect(selection.originalDisplayName, 'Jane Doe');
        expect(
          selection.imageReference,
          AddWisherContactImageReference(
            identifier: 'flutter_contacts:contact-1',
            bytes: photoBytes,
          ),
        );
      });

      test(
        'falls back to display name parsing when structured names are absent',
        () {
          final selection = mapper.map(
            const contacts.Contact(id: 'contact-2', displayName: 'Mary Anne'),
          );

          expect(selection.firstName, 'Mary');
          expect(selection.lastName, 'Anne');
          expect(selection.summaryLabel, 'Mary Anne');
          expect(selection.imageReference, isNull);
        },
      );

      test('throws when plugin output is missing a contact id', () {
        expect(
          () => mapper.map(
            const contacts.Contact(
              id: '   ',
              displayName: 'Missing Identifier',
            ),
          ),
          throwsA(isA<AddWisherContactAccessException>()),
        );
      });

      test('extracts birthday from contact events', () {
        final selection = mapper.map(
          const contacts.Contact(
            id: 'contact-bday',
            displayName: 'Jane Doe',
            name: contacts.Name(first: 'Jane', last: 'Doe'),
            events: [
              contacts.Event(
                year: 1990,
                month: 6,
                day: 15,
                label: contacts.Label(contacts.EventLabel.birthday),
              ),
            ],
          ),
        );

        expect(selection.birthday, DateTime(1990, 6, 15));
      });

      test('falls back to current year when birthday year is null', () {
        final currentYear = DateTime.now().year;
        final selection = mapper.map(
          const contacts.Contact(
            id: 'contact-noyear',
            displayName: 'Jane Doe',
            name: contacts.Name(first: 'Jane', last: 'Doe'),
            events: [
              contacts.Event(
                month: 3,
                day: 20,
                label: contacts.Label(contacts.EventLabel.birthday),
              ),
            ],
          ),
        );

        expect(selection.birthday, DateTime(currentYear, 3, 20));
      });

      test('has null birthday when no birthday event exists', () {
        final selection = mapper.map(
          const contacts.Contact(
            id: 'contact-noevent',
            displayName: 'Jane Doe',
            name: contacts.Name(first: 'Jane', last: 'Doe'),
          ),
        );

        expect(selection.birthday, isNull);
      });
    });
  });

  group('AddWisherContactAccess', () {
    group(TestGroups.behavior, () {
      test(
        'returns permission denied when read access is not granted',
        () async {
          var pickerCalls = 0;
          var loaderCalls = 0;
          final access = AddWisherContactAccess(
            requestPermission: () async => false,
            pickContactId: () async {
              pickerCalls += 1;
              return 'contact-1';
            },
            loadContact: (_) async {
              loaderCalls += 1;
              return const contacts.Contact(id: 'contact-1');
            },
          );

          final result = await access.selectContacts();

          expect(result, isA<AddWisherContactAccessPermissionDenied>());
          expect(pickerCalls, 0);
          expect(loaderCalls, 0);
        },
      );

      test('returns cancelled when the native picker is dismissed', () async {
        var loaderCalls = 0;
        final access = AddWisherContactAccess(
          requestPermission: () async => true,
          pickContactId: () async => null,
          loadContact: (_) async {
            loaderCalls += 1;
            return const contacts.Contact(id: 'contact-1');
          },
        );

        final result = await access.selectContacts();

        expect(result, isA<AddWisherContactAccessCancelled>());
        expect(loaderCalls, 0);
      });

      test(
        'returns mapped selections and drafts for a picked contact',
        () async {
          final access = AddWisherContactAccess(
            requestPermission: () async => true,
            pickContactId: () async => 'contact-3',
            loadContact: (_) async => const contacts.Contact(
              id: 'contact-3',
              displayName: 'Alex Morgan',
              name: contacts.Name(first: 'Alex', last: 'Morgan'),
            ),
          );

          final result = await access.selectContacts();

          expect(result, isA<AddWisherContactAccessSelection>());
          final selectionResult = result as AddWisherContactAccessSelection;
          expect(selectionResult.selections, const [
            AddWisherContactSelection(
              sourceId: 'contact-3',
              firstName: 'Alex',
              lastName: 'Morgan',
              originalDisplayName: 'Alex Morgan',
            ),
          ]);
          expect(selectionResult.drafts, const [
            AddWisherContactImportDraft(
              sourceId: 'contact-3',
              firstName: 'Alex',
              lastName: 'Morgan',
              sourceDisplayName: 'Alex Morgan',
            ),
          ]);
        },
      );
    });

    group(TestGroups.errorHandling, () {
      test(
        'throws a typed exception when the selected contact cannot be loaded',
        () async {
          final access = AddWisherContactAccess(
            requestPermission: () async => true,
            pickContactId: () async => 'contact-4',
            loadContact: (_) async => null,
          );

          expect(
            access.selectContacts,
            throwsA(
              isA<AddWisherContactAccessException>().having(
                (error) => error.message,
                'message',
                'Selected contact could not be loaded.',
              ),
            ),
          );
        },
      );

      test('wraps unexpected plugin failures in a typed exception', () async {
        final access = AddWisherContactAccess(
          requestPermission: () async => true,
          pickContactId: () async => throw Exception('picker exploded'),
          loadContact: (_) async => const contacts.Contact(id: 'contact-5'),
        );

        expect(
          access.selectContacts,
          throwsA(
            isA<AddWisherContactAccessException>().having(
              (error) => error.message,
              'message',
              'Failed to access contacts.',
            ),
          ),
        );
      });
    });
  });
}
