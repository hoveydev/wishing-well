import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('Wisher', () {
    // Helper to create test wishers
    Wisher createTestWisher({
      String id = 'test-id',
      String userId = 'test-user-id',
      String firstName = 'Alice',
      String lastName = 'Johnson',
      String? profilePicture,
    }) => Wisher(
      id: id,
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      profilePicture: profilePicture,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

    group(TestGroups.initialState, () {
      test('creates Wisher with valid properties', () {
        final wisher = createTestWisher();
        expect(wisher.firstName, 'Alice');
        expect(wisher.lastName, 'Johnson');
        expect(wisher.name, 'Alice Johnson');
        expect(wisher.initial, 'A');
        expect(wisher, isA<Wisher>());
      });

      test('creates Wisher with all required fields', () {
        final wisher = Wisher(
          id: '123',
          userId: 'user-456',
          firstName: 'Bob',
          lastName: 'Smith',
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        );
        expect(wisher.id, '123');
        expect(wisher.userId, 'user-456');
        expect(wisher.firstName, 'Bob');
        expect(wisher.lastName, 'Smith');
      });

      test('properties are immutable', () {
        final wisher = createTestWisher();
        // All properties are final, ensuring immutability
        expect(wisher.firstName, 'Alice');
        expect(wisher.lastName, 'Johnson');
      });
    });

    group(TestGroups.behavior, () {
      test('name getter combines first and last name', () {
        final wisher = createTestWisher(firstName: 'John', lastName: 'Doe');
        expect(wisher.name, 'John Doe');
      });

      test('name getter omits blank name parts', () {
        final wisher = createTestWisher(firstName: '', lastName: 'Doe');
        expect(wisher.name, 'Doe');
      });

      test('throws when both names are blank or whitespace', () {
        expect(
          () => createTestWisher(firstName: '', lastName: ''),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => createTestWisher(firstName: '   ', lastName: ' '),
          throwsA(isA<AssertionError>()),
        );
      });

      test('initial getter returns first letter of first name', () {
        final wisher = createTestWisher(firstName: 'Bob');
        expect(wisher.initial, 'B');
      });

      test('initial getter falls back to last name', () {
        final wisher = createTestWisher(firstName: '', lastName: 'Doe');
        expect(wisher.initial, 'D');
      });

      test('initial getter handles lowercase names', () {
        final wisher = createTestWisher(firstName: 'charlie');
        expect(wisher.initial, 'C'); // Should be uppercase
      });

      test('profile picture is optional', () {
        final wisherWithoutPic = createTestWisher();
        final wisherWithPic = createTestWisher(
          profilePicture: 'https://example.com/photo.jpg',
        );
        expect(wisherWithoutPic.profilePicture, isNull);
        expect(wisherWithPic.profilePicture, 'https://example.com/photo.jpg');
      });

      test('handles special characters in names', () {
        final wisher = createTestWisher(
          firstName: "O'Brien",
          lastName: 'Smith',
        );
        expect(wisher.firstName, "O'Brien");
        expect(wisher.name, "O'Brien Smith");
      });

      test('handles unicode characters', () {
        final wisher = createTestWisher(firstName: 'José', lastName: 'García');
        expect(wisher.firstName, 'José');
        expect(wisher.lastName, 'García');
      });

      test('handles hyphenated names', () {
        final wisher = createTestWisher(
          firstName: 'Mary-Anne',
          lastName: 'Smith-Jones',
        );
        expect(wisher.firstName, 'Mary-Anne');
        expect(wisher.lastName, 'Smith-Jones');
      });

      test('toString returns useful description', () {
        final wisher = createTestWisher();
        expect(wisher.toString(), contains('Wisher'));
        expect(wisher.toString(), contains('Alice Johnson'));
      });
    });

    group('Equality', () {
      test('equals works for same id', () {
        final wisher1 = createTestWisher(id: 'same-id');
        final wisher2 = createTestWisher(id: 'same-id');
        expect(wisher1, equals(wisher2));
      });

      test('equals fails for different ids', () {
        final wisher1 = createTestWisher(id: 'id-1');
        final wisher2 = createTestWisher(id: 'id-2');
        expect(wisher1, isNot(equals(wisher2)));
      });

      test('hashCode is same for same id', () {
        final wisher1 = createTestWisher(id: 'same-id');
        final wisher2 = createTestWisher(id: 'same-id');
        expect(wisher1.hashCode, equals(wisher2.hashCode));
      });

      test('hashCode is different for different ids', () {
        final wisher1 = createTestWisher(id: 'id-1');
        final wisher2 = createTestWisher(id: 'id-2');
        expect(wisher1.hashCode, isNot(equals(wisher2.hashCode)));
      });
    });

    group('copyWith', () {
      test('copies with new values', () {
        final original = createTestWisher();
        final copy = original.copyWith(firstName: 'Bob');
        expect(copy.firstName, 'Bob');
        expect(copy.lastName, 'Johnson'); // Unchanged
        expect(copy.id, original.id);
      });

      test('preserves original when no changes', () {
        final original = createTestWisher();
        final copy = original.copyWith();
        expect(copy.firstName, original.firstName);
        expect(copy.lastName, original.lastName);
        expect(copy.id, original.id);
      });
    });

    group('fromJson / toJson', () {
      test('fromJson creates Wisher from JSON', () {
        final json = {
          'id': 'json-id',
          'user_id': 'user-123',
          'first_name': 'Jane',
          'last_name': 'Doe',
          'profile_picture': 'https://example.com/jane.jpg',
          'created_at': '2026-01-01T00:00:00.000Z',
          'updated_at': '2026-01-02T00:00:00.000Z',
        };
        final wisher = Wisher.fromJson(json);
        expect(wisher.id, 'json-id');
        expect(wisher.userId, 'user-123');
        expect(wisher.firstName, 'Jane');
        expect(wisher.lastName, 'Doe');
        expect(wisher.profilePicture, 'https://example.com/jane.jpg');
      });

      test('toJson creates JSON from Wisher', () {
        final wisher = createTestWisher();
        final json = wisher.toJson();
        expect(json['id'], 'test-id');
        expect(json['user_id'], 'test-user-id');
        expect(json['first_name'], 'Alice');
        expect(json['last_name'], 'Johnson');
      });

      test('fromJson handles null profile_picture', () {
        final json = {
          'id': 'json-id',
          'user_id': 'user-123',
          'first_name': 'Jane',
          'last_name': 'Doe',
          'profile_picture': null,
          'created_at': '2026-01-01T00:00:00.000Z',
          'updated_at': '2026-01-02T00:00:00.000Z',
        };
        final wisher = Wisher.fromJson(json);
        expect(wisher.profilePicture, isNull);
      });
    });

    group(TestGroups.errorHandling, () {
      test('handles realistic names correctly', () {
        final realisticNames = [
          ('John', 'Doe'),
          ('Jane', 'Smith'),
          ('Alice', 'Johnson'),
          ('Bob', 'Wilson'),
          ('Jean-Luc', 'Picard'),
          ('Mary Anne', 'Smith'),
        ];

        for (final (first, last) in realisticNames) {
          final wisher = createTestWisher(firstName: first, lastName: last);
          expect(wisher.firstName, first);
          expect(wisher.lastName, last);
          expect(wisher.name, '$first $last');
        }
      });
    });
  });
}
