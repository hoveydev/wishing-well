import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart' as logging;
import 'package:wishing_well/utils/app_logger.dart';

void main() {
  group('AppLogger', () {
    setUp(() {
      // Initialize logger before each test
      // This enables hierarchicalLoggingRequired and sets up the logger
      AppLogger.init();
      // Then set to warning level for test isolation
      AppLogger.setLogLevel(LogLevel.warning);
    });

    tearDown(() {
      // Reset to warning level after each test
      AppLogger.setLogLevel(LogLevel.warning);
    });

    group('LogLevel Extension', () {
      test('toLoggingLevel converts debug to ALL', () {
        expect(LogLevel.debug.toLoggingLevel, equals(logging.Level.ALL));
      });

      test('toLoggingLevel converts info to INFO', () {
        expect(LogLevel.info.toLoggingLevel, equals(logging.Level.INFO));
      });

      test('toLoggingLevel converts warning to WARNING', () {
        expect(LogLevel.warning.toLoggingLevel, equals(logging.Level.WARNING));
      });

      test('toLoggingLevel converts error to SEVERE', () {
        expect(LogLevel.error.toLoggingLevel, equals(logging.Level.SEVERE));
      });
    });

    group('setLogLevel', () {
      test('setLogLevel changes log level to debug', () {
        AppLogger.setLogLevel(LogLevel.debug);

        expect(AppLogger.logLevel, equals(LogLevel.debug));
      });

      test('setLogLevel changes log level to info', () {
        AppLogger.setLogLevel(LogLevel.info);

        expect(AppLogger.logLevel, equals(LogLevel.info));
      });

      test('setLogLevel changes log level to warning', () {
        AppLogger.setLogLevel(LogLevel.warning);

        expect(AppLogger.logLevel, equals(LogLevel.warning));
      });

      test('setLogLevel changes log level to error', () {
        AppLogger.setLogLevel(LogLevel.error);

        expect(AppLogger.logLevel, equals(LogLevel.error));
      });

      test('setLogLevel updates the underlying logger level', () {
        AppLogger.setLogLevel(LogLevel.debug);

        // The internal logger should be updated to ALL (debug)
        final internalLogger = logging.Logger('WishingWell');
        expect(internalLogger.level, equals(logging.Level.ALL));
      });
    });

    group('logLevel getter', () {
      test('logLevel returns current log level', () {
        AppLogger.setLogLevel(LogLevel.info);

        expect(AppLogger.logLevel, equals(LogLevel.info));
      });

      test('logLevel returns warning by default after setUp', () {
        // Due to setUp resetting to warning
        expect(AppLogger.logLevel, equals(LogLevel.warning));
      });
    });

    group('init', () {
      test('init can be called multiple times without error', () {
        AppLogger.init();
        AppLogger.init();
        AppLogger.init();

        // Should not throw and should maintain level
        expect(AppLogger.logLevel, isNotNull);
      });
    });

    group('Log level behavior', () {
      test('setLogLevel to error suppresses info logs', () {
        AppLogger.setLogLevel(LogLevel.error);

        // Should only show errors - info should be filtered
        final internalLogger = logging.Logger('WishingWell');
        expect(internalLogger.level, equals(logging.Level.SEVERE));
      });

      test('setLogLevel to warning shows warnings and errors', () {
        AppLogger.setLogLevel(LogLevel.warning);

        final internalLogger = logging.Logger('WishingWell');
        expect(internalLogger.level, equals(logging.Level.WARNING));
      });

      test('setLogLevel to info shows info, warning, and error', () {
        AppLogger.setLogLevel(LogLevel.info);

        final internalLogger = logging.Logger('WishingWell');
        expect(internalLogger.level, equals(logging.Level.INFO));
      });

      test('setLogLevel to debug shows all logs', () {
        AppLogger.setLogLevel(LogLevel.debug);

        final internalLogger = logging.Logger('WishingWell');
        expect(internalLogger.level, equals(logging.Level.ALL));
      });
    });
  });
}
