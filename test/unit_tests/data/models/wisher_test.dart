import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/data/models/wisher.dart';

void main() {
  group('Wisher Model', () {
    test('creates Wisher with name', () {
      const wisher = Wisher('Alice');
      expect(wisher.name, 'Alice');
    });

    test('creates Wisher with empty name', () {
      const wisher = Wisher('');
      expect(wisher.name, '');
    });

    test('creates Wisher with whitespace name', () {
      const wisher = Wisher('  Alice Smith  ');
      expect(wisher.name, '  Alice Smith  ');
    });

    test('creates Wisher with special characters', () {
      const wisher = Wisher('Alice-123_!@#');
      expect(wisher.name, 'Alice-123_!@#');
    });

    test('creates Wisher with numbers', () {
      const wisher = Wisher('User123');
      expect(wisher.name, 'User123');
    });

    test('creates Wisher with very long name', () {
      const longName =
          'VeryLongNameThatExceedsNormalLengthExpectationsAndGoesOnAndOn';
      const wisher = Wisher(longName);
      expect(wisher.name, longName);
    });

    test('creates Wisher with unicode characters', () {
      const wisher = Wisher('Àlice Ñiño');
      expect(wisher.name, 'Àlice Ñiño');
    });

    test('creates Wisher with emoji characters', () {
      const wisher = Wisher('Alice 😊');
      expect(wisher.name, 'Alice 😊');
    });

    test('equals works for same name', () {
      const wisher1 = Wisher('Alice');
      const wisher2 = Wisher('Alice');
      expect(wisher1, equals(wisher2));
    });

    test('equals fails for different names', () {
      const wisher1 = Wisher('Alice');
      const wisher2 = Wisher('Bob');
      expect(wisher1, isNot(equals(wisher2)));
    });

    test('equals fails for different casing', () {
      const wisher1 = Wisher('Alice');
      const wisher2 = Wisher('alice');
      expect(wisher1, isNot(equals(wisher2)));
    });

    test('hashCode is same for same name', () {
      const wisher1 = Wisher('Alice');
      const wisher2 = Wisher('Alice');
      expect(wisher1.hashCode, equals(wisher2.hashCode));
    });

    test('hashCode is different for different names', () {
      const wisher1 = Wisher('Alice');
      const wisher2 = Wisher('Bob');
      expect(wisher1.hashCode, isNot(equals(wisher2.hashCode)));
    });

    test('toString returns instance description', () {
      const wisher = Wisher('Alice');
      expect(wisher.toString(), contains('Wisher'));
    });

    test('handles null-like strings correctly', () {
      const wisher1 = Wisher('null');
      const wisher2 = Wisher('undefined');
      expect(wisher1.name, 'null');
      expect(wisher2.name, 'undefined');
    });

    test('name property is immutable', () {
      const wisher = Wisher('Alice');
      // Since name is final, this should not compile if we try to change it
      // This test ensures the property is properly declared as final
      expect(wisher.name, 'Alice');
    });

    test('constructor accepts const values', () {
      const wisher = Wisher('Alice');
      expect(wisher, isA<Wisher>());
      expect(wisher.name, 'Alice');
    });

    test('multiple instances with same name are equal', () {
      const wisher1 = Wisher('Test User');
      const wisher2 = Wisher('Test User');
      const wisher3 = Wisher('Test User');

      expect(wisher1, equals(wisher2));
      expect(wisher2, equals(wisher3));
      expect(wisher1, equals(wisher3));
    });

    test('can be used as Map key', () {
      const wisher1 = Wisher('Alice');
      const wisher2 = Wisher('Bob');

      final wisherMap = <Wisher, String>{wisher1: 'first', wisher2: 'second'};

      expect(wisherMap[wisher1], 'first');
      expect(wisherMap[wisher2], 'second');
    });

    test('handles edge case names', () {
      final edgeCases = [
        '',
        ' ',
        '\t',
        '\n',
        '  ',
        'a',
        'A',
        '1',
        '!',
        '@',
        '#',
        '\$',
        '%',
        '^',
        '&',
        '*',
        '(',
        ')',
        '-',
        '_',
        '+',
        '=',
        '[',
        ']',
        '{',
        '}',
        '|',
        '\\',
        ':',
        ';',
        '"',
        "'",
        '<',
        '>',
        ',',
        '.',
        '?',
        '/',
      ];

      for (final name in edgeCases) {
        final wisher = Wisher(name);
        expect(wisher.name, name);
      }
    });

    test('realistic names work correctly', () {
      const realisticNames = [
        'John Doe',
        'Jane Smith',
        'Alice Johnson',
        'Bob Wilson',
        'Charlie Brown',
        'Diana Prince',
        'John Smith Jr.',
        'Dr. Jane Smith',
        'Prof. Alan Turing',
        'Mr. John Doe',
        'Ms. Alice Johnson',
        'O\'Connor',
        'Van der Waals',
        'Jean-Luc Picard',
        'Mary Anne Smith',
        'John-Paul Jones',
      ];

      for (final name in realisticNames) {
        final wisher = Wisher(name);
        expect(wisher.name, name);
      }
    });
  });
}
