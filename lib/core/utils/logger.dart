import 'package:logger/logger.dart';

/// App logger for consistent logging
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// Log debug message
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log info message
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning message
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error message
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log API request
  static void apiRequest(String method, String endpoint, {dynamic data}) {
    _logger.i('🌐 [REQUEST] $method $endpoint', error: data);
  }

  /// Log API response
  static void apiResponse(int statusCode, String endpoint, {dynamic data}) {
    _logger.i('✅ [RESPONSE] $statusCode $endpoint', error: data);
  }

  /// Log API error
  static void apiError(
    String endpoint,
    dynamic error, [
    StackTrace? stackTrace,
  ]) {
    _logger.e('❌ [API ERROR] $endpoint', error: error, stackTrace: stackTrace);
  }

  /// Log operation
  static void operation(String feature, String action, {dynamic data}) {
    _logger.i('⚙️  [OPERATION] $feature - $action', error: data);
  }

  /// Log operation success
  static void operationSuccess(String feature, String action, {dynamic data}) {
    _logger.i('✅ [SUCCESS] $feature - $action', error: data);
  }

  /// Log operation error
  static void operationError(
    String feature,
    String action,
    dynamic error, [
    StackTrace? stackTrace,
  ]) {
    _logger.e(
      '❌ [ERROR] $feature - $action',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
