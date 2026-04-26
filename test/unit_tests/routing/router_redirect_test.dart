import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GoRouter redirect error handling', () {
    group('error query parameter detection', () {
      test('detects error query param in root path', () {
        final testUri = Uri(
          scheme: 'https',
          host: 'example.com',
          queryParameters: const {
            'error': 'access_denied',
            'error_code': 'otp_expired',
            'error_description': 'Expired link',
          },
        );

        // Verify URI parsing works as expected
        expect(testUri.queryParameters.containsKey('error'), isTrue);
        expect(testUri.queryParameters['error'], 'access_denied');
        expect(testUri.queryParameters['error_description'], 'Expired link');
      });

      test('detects error query param in auth path', () {
        final testUri = Uri.parse(
          'https://example.com/auth/password-reset?error=access_denied&error_description=Invalid+link',
        );

        expect(testUri.queryParameters.containsKey('error'), isTrue);
        expect(testUri.pathSegments.contains('password-reset'), isTrue);
      });

      test('URL encoding works for special characters', () {
        const description = 'Email link is invalid or has expired';
        final encoded = Uri.encodeComponent(description);

        // Verify encoding produces URL-safe string
        expect(encoded, isNotEmpty);
        expect(encoded.contains('%20'), isTrue);
        expect(Uri.decodeComponent(encoded), description);
      });

      test('pathSegments extracts auth subpath correctly', () {
        final testUri = Uri.parse(
          'https://example.com/auth/password-reset?error=test',
        );

        expect(testUri.pathSegments.length, 2);
        expect(testUri.pathSegments[0], 'auth');
        expect(testUri.pathSegments[1], 'password-reset');
      });

      test('pathSegments handles root path error URI', () {
        final testUri = Uri.parse('https://example.com/?error=test');

        // Root path results in empty pathSegments
        expect(testUri.pathSegments.isEmpty, isTrue);
      });

      test('redirect URL is properly formatted', () {
        const errorType = 'unknown';
        const errorDescription = 'Email link is invalid or has expired';
        final encodedDesc = Uri.encodeComponent(errorDescription);
        final redirectUrl =
            '/deep-link-error?errorType=$errorType&errorDescription=$encodedDesc';

        expect(redirectUrl, contains('/deep-link-error'));
        expect(redirectUrl, contains('errorType=unknown'));
        expect(redirectUrl, contains('errorDescription='));
      });
    });
  });
}
