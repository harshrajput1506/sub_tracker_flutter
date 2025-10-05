import 'package:dio/dio.dart';
import 'package:sub/core/error/failures.dart';

/// Exception handler utility
class ExceptionHandler {
  ExceptionHandler._();

  /// Convert exception to failure
  static Failure handleException(dynamic error) {
    if (error is DioException) {
      return _handleDioException(error);
    } else if (error is Failure) {
      return error;
    } else {
      return GeneralFailure(message: error.toString(), error: error);
    }
  }

  /// Handle Dio exceptions
  static Failure _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure.timeout();

      case DioExceptionType.connectionError:
        return NetworkFailure.noInternet();

      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode);

      case DioExceptionType.cancel:
        return const NetworkFailure(
          message: 'Request cancelled',
          code: 'CANCELLED',
        );

      case DioExceptionType.unknown:
        return NetworkFailure(
          message: 'Network error: ${error.message}',
          code: 'UNKNOWN',
          error: error,
        );

      default:
        return NetworkFailure(message: 'Network error occurred', error: error);
    }
  }

  /// Handle HTTP status codes
  static Failure _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return const NetworkFailure(
          message: 'Bad request',
          code: 'BAD_REQUEST',
        );
      case 401:
        return const NetworkFailure(
          message: 'Unauthorized',
          code: 'UNAUTHORIZED',
        );
      case 403:
        return const NetworkFailure(message: 'Forbidden', code: 'FORBIDDEN');
      case 404:
        return const NetworkFailure(message: 'Not found', code: 'NOT_FOUND');
      case 500:
        return const NetworkFailure(
          message: 'Internal server error',
          code: 'SERVER_ERROR',
        );
      case 503:
        return const NetworkFailure(
          message: 'Service unavailable',
          code: 'SERVICE_UNAVAILABLE',
        );
      default:
        return NetworkFailure(
          message: 'HTTP error: $statusCode',
          code: 'HTTP_ERROR',
        );
    }
  }
}
