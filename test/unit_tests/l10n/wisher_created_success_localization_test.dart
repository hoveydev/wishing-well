import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/l10n/app_localizations_en.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('AppLocalizations - wisherCreatedSuccess', () {
    late AppLocalizationsEn l10n;

    setUp(() {
      l10n = AppLocalizationsEn();
    });

    group(TestGroups.behavior, () {
      test('wisherCreatedSuccess returns correct format', () {
        final result = l10n.wisherCreatedSuccess('John Doe');
        expect(result, 'John Doe has been added!');
      });

      test('wisherCreatedSuccess works with different names', () {
        expect(l10n.wisherCreatedSuccess('Alice'), 'Alice has been added!');
        expect(
          l10n.wisherCreatedSuccess('Bob Smith'),
          'Bob Smith has been added!',
        );
        expect(l10n.wisherCreatedSuccess('María'), 'María has been added!');
      });

      test('wisherCreatedSuccess works with empty name edge case', () {
        // Even with empty string, it should produce valid output
        final result = l10n.wisherCreatedSuccess('');
        expect(result, ' has been added!');
      });

      test('wisherCreatedSuccess works with special characters', () {
        final result = l10n.wisherCreatedSuccess('José García');
        expect(result, 'José García has been added!');
      });

      test('wisherCreatedSuccess works with long names', () {
        const longName = 'Christopher Jonathan Haberman';
        final result = l10n.wisherCreatedSuccess(longName);
        expect(result, '$longName has been added!');
      });

      test('wisherCreatedSuccess name is at start of message', () {
        const name = 'John';
        final result = l10n.wisherCreatedSuccess(name);

        // Name should be at the start
        expect(result.startsWith(name), isTrue);
        // Should contain the rest of the message
        expect(result.contains(' has been added!'), isTrue);
      });
    });

    group(TestGroups.initialState, () {
      test('wisherCreatedSuccess is callable', () {
        expect(l10n.wisherCreatedSuccess, isA<dynamic Function(String)>());
      });

      test('returns String type', () {
        final result = l10n.wisherCreatedSuccess('Test');
        expect(result, isA<String>());
      });
    });
  });
}
