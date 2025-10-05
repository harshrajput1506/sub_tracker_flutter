import 'package:dartz/dartz.dart';

/// Base class for all failures
abstract class Failure {
  final String message;
  final String? code;
  final dynamic error;

  const Failure({required this.message, this.code, this.error});

  /// Get user-friendly error message
  String getUserMessage() => message;

  @override
  String toString() => 'Failure: $message (code: $code)';
}

/// Network related failures
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code, super.error});

  factory NetworkFailure.noInternet() => const NetworkFailure(
    message: 'No internet connection. Please check your network.',
    code: 'NO_INTERNET',
  );

  factory NetworkFailure.timeout() => const NetworkFailure(
    message: 'Request timeout. Please try again.',
    code: 'TIMEOUT',
  );

  factory NetworkFailure.serverError() => const NetworkFailure(
    message: 'Server error. Please try again later.',
    code: 'SERVER_ERROR',
  );

  @override
  String getUserMessage() {
    switch (code) {
      case 'NO_INTERNET':
        return 'No internet connection';
      case 'TIMEOUT':
        return 'Connection timeout';
      case 'SERVER_ERROR':
        return 'Server error occurred';
      default:
        return 'Network error occurred';
    }
  }
}

/// Cache related failures
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code, super.error});

  factory CacheFailure.notFound() =>
      const CacheFailure(message: 'Data not found in cache', code: 'NOT_FOUND');

  factory CacheFailure.writeError() =>
      const CacheFailure(message: 'Failed to save data', code: 'WRITE_ERROR');

  @override
  String getUserMessage() => 'Failed to access local data';
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code, super.error});

  @override
  String getUserMessage() => message;
}

/// General/Unknown failures
class GeneralFailure extends Failure {
  const GeneralFailure({required super.message, super.code, super.error});

  @override
  String getUserMessage() => 'An unexpected error occurred';
}

/// Parse failures
class ParseFailure extends Failure {
  const ParseFailure({required super.message, super.code, super.error});

  @override
  String getUserMessage() => 'Failed to process data';
}

/// Type alias for Either with Failure
typedef FailureOr<T> = Either<Failure, T>;
