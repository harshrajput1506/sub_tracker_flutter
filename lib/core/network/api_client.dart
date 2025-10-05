import 'package:dio/dio.dart';
import 'package:sub/core/constants/constants.dart';
import 'package:sub/core/error/exception_handler.dart';
import 'package:sub/core/error/failures.dart';
import 'package:sub/core/utils/logger.dart';
import 'package:dartz/dartz.dart';

/// API client for network requests
class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: ApiConstants.connectTimeout,
              receiveTimeout: ApiConstants.receiveTimeout,
              sendTimeout: ApiConstants.sendTimeout,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          ) {
    _setupInterceptors();
  }

  /// Setup interceptors for logging and error handling
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogger.apiRequest(
            options.method,
            options.uri.toString(),
            data: options.data,
          );
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.apiResponse(
            response.statusCode ?? 0,
            response.requestOptions.uri.toString(),
            data: response.data,
          );
          return handler.next(response);
        },
        onError: (error, handler) {
          AppLogger.apiError(
            error.requestOptions.uri.toString(),
            error,
            error.stackTrace,
          );
          return handler.next(error);
        },
      ),
    );
  }

  /// GET request
  Future<Either<Failure, T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
      );

      if (parser != null) {
        return Right(parser(response.data));
      }
      return Right(response.data as T);
    } catch (e, stackTrace) {
      AppLogger.error('GET request failed: $url', e, stackTrace);
      return Left(ExceptionHandler.handleException(e));
    }
  }

  /// POST request
  Future<Either<Failure, T>> post<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      if (parser != null) {
        return Right(parser(response.data));
      }
      return Right(response.data as T);
    } catch (e, stackTrace) {
      AppLogger.error('POST request failed: $url', e, stackTrace);
      return Left(ExceptionHandler.handleException(e));
    }
  }

  /// PUT request
  Future<Either<Failure, T>> put<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      if (parser != null) {
        return Right(parser(response.data));
      }
      return Right(response.data as T);
    } catch (e, stackTrace) {
      AppLogger.error('PUT request failed: $url', e, stackTrace);
      return Left(ExceptionHandler.handleException(e));
    }
  }

  /// DELETE request
  Future<Either<Failure, T>> delete<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      if (parser != null) {
        return Right(parser(response.data));
      }
      return Right(response.data as T);
    } catch (e, stackTrace) {
      AppLogger.error('DELETE request failed: $url', e, stackTrace);
      return Left(ExceptionHandler.handleException(e));
    }
  }

  /// Download file
  Future<Either<Failure, void>> download(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await _dio.download(
        url,
        savePath,
        queryParameters: queryParameters,
        options: options,
        onReceiveProgress: onReceiveProgress,
      );
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Download failed: $url', e, stackTrace);
      return Left(ExceptionHandler.handleException(e));
    }
  }
}
