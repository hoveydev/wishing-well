import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { development, production }

class AppConfig {
  AppConfig._();

  static Environment _environment = Environment.development;

  static Future<void> initialize({
    Environment environment = Environment.development,
  }) async {
    _environment = environment;

    switch (environment) {
      case Environment.development:
        await dotenv.load(fileName: '.env.development');
        break;
      case Environment.production:
        await dotenv.load(fileName: '.env.prod');
        break;
    }

    validate();
  }

  static String get testToken => _getOrThrow('TEST_TOKEN');
  static String get unavailableToken =>
      _getOrDefault('UNAVAILABLE', 'unavailable token');

  static Environment get environment => _environment;
  static bool get isDevelopment => _environment == Environment.development;
  static bool get isProduction => _environment == Environment.production;

  static String _getOrThrow(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw Exception(
        'Missing required environment variable: $key\n'
        'Please check your .env file.',
      );
    }
    return value;
  }

  static String _getOrDefault(String key, String defaultValue) =>
      dotenv.env[key] ?? defaultValue;

  static void validate() {
    // This will throw if any required key is missing
    // if a default is provided, it will never throw
    testToken;
    unavailableToken;

    log(
      '✅ All required environment variables are present for ${_environment.name}',
    );
  }
}
