import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { test, development, production }

class AppConfig {
  AppConfig._();

  static Environment _environment = Environment.development;

  static Future<void> initialize({
    Environment environment = Environment.development,
  }) async {
    _environment = environment;

    switch (environment) {
      case Environment.test:
        await dotenv.load(fileName: '.env.test');
        break;
      case Environment.development:
        await dotenv.load(fileName: '.env.development');
        break;
      case Environment.production:
        await dotenv.load(fileName: '.env.prod');
        break;
    }

    validate();
  }

  static String get supabaseUrl => _getOrThrow('SUPABASE_URL');
  static String get supabaseSecret => _getOrThrow('SUPABASE_SECRET');
  static String get accountConfirmUrl => _getOrThrow('ACCOUNT_CONFIRM_URL');
  static String get passwordResetUrl => _getOrThrow('PASSWORD_RESET_URL');

  static Environment get environment => _environment;
  static bool get isTest => _environment == Environment.test;
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

  // ignore: unused_element
  static String _getOrDefault(String key, String defaultValue) =>
      dotenv.env[key] ?? defaultValue;

  static void validate() {
    // This will throw if any required key is missing
    // if a default is provided, it will never throw
    supabaseUrl;
    supabaseSecret;
    accountConfirmUrl;
    passwordResetUrl;

    log('✅ All environment variables are present for ${_environment.name}');
  }
}
