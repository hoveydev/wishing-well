import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart' as logging;

/// Log levels for safe logging.
enum LogLevel { debug, info, warning, error }

/// Extension to convert LogLevel to logging.Level
extension LogLevelExtension on LogLevel {
  logging.Level get toLoggingLevel {
    switch (this) {
      case LogLevel.debug:
        return logging.Level.ALL;
      case LogLevel.info:
        return logging.Level.INFO;
      case LogLevel.warning:
        return logging.Level.WARNING;
      case LogLevel.error:
        return logging.Level.SEVERE;
    }
  }
}

/// Log level styling configuration.
class _LogStyle {
  const _LogStyle({required this.emoji, required this.label});

  final String emoji;
  final String label;

  static const _LogStyle debug = _LogStyle(emoji: '🔍', label: 'DEBUG');
  static const _LogStyle info = _LogStyle(emoji: '💡', label: 'INFO');
  static const _LogStyle warning = _LogStyle(emoji: '⚠️', label: 'WARN');
  static const _LogStyle error = _LogStyle(emoji: '❌', label: 'ERROR');
}

/// A production-ready logging utility for the Wishing Well app.
///
/// This logger provides structured logging with:
/// - Different log levels (debug, info, warning, error)
/// - **Configurable log level at runtime** via [setLogLevel]
/// - Context-aware logging for better traceability
/// - Automatic suppression in release builds by default
/// - Formatted output with timestamps and source context
/// - Error and stack trace support for error logging
/// - Emoji indicators for easy visual scanning
///
/// Usage:
/// ```dart
/// // Initialize in main.dart before runApp()
/// AppLogger.init();
///
/// // Change log level at runtime (e.g., from settings screen)
/// AppLogger.setLogLevel(LogLevel.debug); // Show all logs
/// AppLogger.setLogLevel(LogLevel.warning); // Only warnings and errors
///
/// // Log with context
/// AppLogger.info('User logged in', context: 'AuthRepository.login');
///
/// // Log errors with stack traces
/// try {
///   // ...
/// } catch (e, stackTrace) {
///   AppLogger.error(
///     'Failed to authenticate user',
///     context: 'AuthRepository.login',
///     error: e,
///     stackTrace: stackTrace,
///   );
/// }
/// ```
class AppLogger {
  static final logging.Logger _logger = logging.Logger('WishingWell');
  static bool _initialized = false;

  /// Current log level setting (can be changed at runtime).
  ///
  /// Defaults to:
  /// - [LogLevel.debug] in debug mode (shows all logs)
  /// - [LogLevel.warning] in release mode (shows warnings and above)
  ///
  /// Use [setLogLevel] to change this at runtime.
  static LogLevel _currentLogLevel = LogLevel.warning;

  /// Get the current log level.
  static LogLevel get logLevel => _currentLogLevel;

  /// Set the log level at runtime.
  ///
  /// This allows dynamically adjusting verbosity without rebuilding.
  /// Useful for:
  /// - Debug screens in production
  /// - Remote config integration
  /// - User preference settings
  ///
  /// Example:
  /// ```dart
  /// // Enable debug logging
  /// AppLogger.setLogLevel(LogLevel.debug);
  ///
  /// // Silence all logs in production
  /// AppLogger.setLogLevel(LogLevel.error);
  /// ```
  static void setLogLevel(LogLevel level) {
    _currentLogLevel = level;
    _logger.level = level.toLoggingLevel;
    // Also update root level to filter at the root level
    logging.Logger.root.level = level.toLoggingLevel;
  }

  /// Initialize the logging system.
  ///
  /// Should be called once in main.dart before runApp().
  /// Configures log levels and output handlers based on build mode.
  ///
  /// To change the log level at runtime, use [setLogLevel].
  static void init() {
    if (_initialized) return;
    _initialized = true;

    // Enable hierarchical logging to allow setting level on our logger
    logging.hierarchicalLoggingEnabled = true;

    // Set default log level based on build mode
    // This can be overridden at runtime via setLogLevel()
    _currentLogLevel = kDebugMode ? LogLevel.debug : LogLevel.warning;
    _logger.level = _currentLogLevel.toLoggingLevel;

    // Configure log output handler
    logging.Logger.root.onRecord.listen((record) {
      // Skip verbose third-party library logs in debug mode
      // Only show FINEST/FINER logs from our own logger
      if (kDebugMode &&
          record.level < logging.Level.FINE &&
          !record.loggerName.startsWith('WishingWell')) {
        return;
      }

      // SANITIZE ALL LOG MESSAGES to prevent sensitive data leaks
      final sanitizedMessage = _sanitize(record.message);
      final style = _getStyleForLevel(record.level);
      final isOurApp = record.loggerName.startsWith('WishingWell');

      if (kDebugMode) {
        _printFormattedLog(
          record: record,
          message: sanitizedMessage,
          style: style,
          isOurApp: isOurApp,
        );
      }

      // In production builds, you could send severe logs to crash reporting
      // Uncomment and configure when adding crash reporting
      // (e.g., Sentry, Firebase Crashlytics)
      // if (record.level >= logging.Level.SEVERE && !kDebugMode) {
      //   _sendToCrashReporting(record);
      // }
    });
  }

  /// Print a formatted log message with clear visual structure.
  static void _printFormattedLog({
    required logging.LogRecord record,
    required String message,
    required _LogStyle style,
    required bool isOurApp,
  }) {
    final buffer = StringBuffer();

    // Timestamp
    buffer.write('${_formatTimestamp(record.time)} ');

    // Level emoji and label
    buffer.write('${style.emoji} ${style.label.padRight(5)} ');

    // Source - simplified
    if (isOurApp) {
      // Our app logs - context is already in the message
      // No need to show "WishingWell"
    } else {
      // Third-party - show shortened logger name
      final shortName = _shortenLoggerName(record.loggerName);
      buffer.write('$shortName › ');
    }

    // Message
    buffer.write(message);

    debugPrint(buffer.toString());

    // Error details with clear formatting
    if (record.error != null) {
      final sanitizedError = _sanitize(record.error.toString());
      debugPrint('         ⚠ $sanitizedError');
    }

    // Stack trace with indentation
    if (record.stackTrace != null) {
      _printStackTrace(record.stackTrace!);
    }
  }

  /// Shorten third-party logger names for cleaner output.
  static String _shortenLoggerName(String name) {
    // e.g., "supabase.supabase_flutter" -> "supabase"
    // e.g., "supabase.auth" -> "supabase.auth"
    final parts = name.split('.');
    if (parts.length <= 2) return name;
    // Keep first part if it's descriptive enough
    return parts.first;
  }

  /// Get the appropriate style for a log level.
  static _LogStyle _getStyleForLevel(logging.Level level) {
    if (level >= logging.Level.SEVERE) {
      return _LogStyle.error;
    } else if (level >= logging.Level.WARNING) {
      return _LogStyle.warning;
    } else if (level >= logging.Level.INFO) {
      return _LogStyle.info;
    } else {
      return _LogStyle.debug;
    }
  }

  /// Log a debug-level message.
  ///
  /// Use for detailed diagnostic information during development.
  /// Automatically suppressed in release builds.
  static void debug(String message, {String? context}) {
    _logger.fine(_formatMessage(message, context));
  }

  /// Log an info-level message.
  ///
  /// Use for general information about app operation
  /// (user actions, navigation, etc.).
  static void info(String message, {String? context}) {
    _logger.info(_formatMessage(message, context));
  }

  /// Log a warning-level message.
  ///
  /// Use for potentially problematic situations that aren't errors.
  static void warning(String message, {String? context}) {
    _logger.warning(_formatMessage(message, context));
  }

  /// Log an error-level message.
  ///
  /// Use for error conditions that need investigation.
  /// Optionally include error object and stack trace for debugging.
  static void error(
    String message, {
    String? context,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (error != null && stackTrace != null) {
      _logger.severe(_formatMessage(message, context), error, stackTrace);
    } else if (error != null) {
      _logger.severe(_formatMessage(message, context), error);
    } else {
      _logger.severe(_formatMessage(message, context));
    }
  }

  /// Log a message with sensitive data automatically redacted.
  ///
  /// This method sanitizes strings containing patterns that look like API keys,
  /// tokens, passwords, or other sensitive information.
  static void safe(
    String message, {
    String? context,
    LogLevel level = LogLevel.info,
  }) {
    final sanitizedMessage = _sanitize(message);
    switch (level) {
      case LogLevel.debug:
        debug(sanitizedMessage, context: context);
      case LogLevel.info:
        info(sanitizedMessage, context: context);
      case LogLevel.warning:
        warning(sanitizedMessage, context: context);
      case LogLevel.error:
        error(sanitizedMessage, context: context);
    }
  }

  /// Sanitize a message by redacting sensitive patterns.
  static String _sanitize(String message) {
    // Redact common sensitive patterns
    final patterns = [
      // JWT tokens (most common format - base64.base64.base64)
      RegExp(r'eyJ[A-Za-z0-9\-_]+\.eyJ[A-Za-z0-9\-_]+\.[A-Za-z0-9\-_]+'),
      // API keys in various formats (with or without quotes)
      RegExp(
        r'(apikey|api[_-]?key)["\s:=]+["\x27]?[\w\-]{20,}["\x27]?',
        caseSensitive: false,
      ),
      // Bearer tokens and authorization headers
      RegExp(
        r'(bearer|authorization|token)["\s:=]+["\x27]?[\w\.\-]{20,}["\x27]?',
        caseSensitive: false,
      ),
      // Passwords in logs
      RegExp(
        r'(password|passwd|pwd)["\s:=]+["\x27]?[^\s"\x27]{8,}["\x27]?',
        caseSensitive: false,
      ),
      // Secrets and private keys
      RegExp(
        r'(secret|private[_-]?key|access[_-]?key)["\s:=]+["\x27]?[\w\-]{20,}["\x27]?',
        caseSensitive: false,
      ),
      // Generic long alphanumeric strings that look like keys (in headers/params)
      RegExp(r'(apikey|token|secret)["\s:]+[\w\-]{30,}', caseSensitive: false),
    ];

    var sanitized = message;
    for (final pattern in patterns) {
      sanitized = sanitized.replaceAll(pattern, '[REDACTED]');
    }
    return sanitized;
  }

  /// Format a message with optional context.
  static String _formatMessage(String message, String? context) {
    if (context == null) return message;
    return '[$context] $message';
  }

  /// Format timestamp for consistent log output.
  static String _formatTimestamp(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final second = time.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  /// Print stack trace in a readable format.
  static void _printStackTrace(StackTrace stackTrace) {
    final lines = stackTrace.toString().split('\n');
    // Only print first 5 lines to avoid cluttering logs
    final relevantLines = lines.take(5);

    for (final line in relevantLines) {
      if (line.trim().isNotEmpty) {
        // Simplify the stack trace line
        final simplified = _simplifyStackLine(line);
        // Mark our app's code in the stack trace
        if (line.contains('wishing_well')) {
          debugPrint('         → $simplified');
        } else {
          debugPrint('           $simplified');
        }
      }
    }

    if (lines.length > 5) {
      final remaining = lines.length - 5;
      debugPrint('           ... +$remaining');
    }
  }

  /// Simplify a stack trace line for readability.
  static String _simplifyStackLine(String line) {
    // Remove "package:" prefix and extra whitespace
    var simplified = line.trim();
    if (simplified.startsWith('#')) {
      // Keep the frame number but clean up the rest
      simplified = simplified.replaceAll(RegExp(r'\s+'), ' ');
    }
    return simplified;
  }

  // Uncomment and implement when adding crash reporting service
  // static void _sendToCrashReporting(logging.LogRecord record) {
  //   // Example for Sentry:
  //   Sentry.captureException(
  //     record.error ?? Exception(record.message),
  //     stackTrace: record.stackTrace,
  //   );
  //
  //   // Example for Firebase Crashlytics:
  //   FirebaseCrashlytics.instance.recordError(
  //     record.error ?? record.message,
  //     record.stackTrace,
  //   );
  // }
}
