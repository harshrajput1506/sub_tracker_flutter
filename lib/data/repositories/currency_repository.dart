import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sub/core/error/failures.dart';
import 'package:sub/core/utils/logger.dart';
import 'package:sub/data/datasources/remote/currency_remote_datasource.dart';
import 'package:sub/data/models/currency_rates_model.dart';

/// Repository for currency operations
@lazySingleton
class CurrencyRepository {
  final CurrencyRemoteDataSource _remoteDataSource;

  CurrencyRepository(this._remoteDataSource);

  /// Get latest currency rates (with cache fallback)
  Future<Either<Failure, CurrencyRatesModel>> getRates() async {
    try {
      AppLogger.operation('CurrencyRepository', 'getRates');

      final rates = await _remoteDataSource.getRatesWithFallback();

      AppLogger.operationSuccess('CurrencyRepository', 'getRates');
      return Right(rates);
    } catch (e, stackTrace) {
      AppLogger.operationError('CurrencyRepository', 'getRates', e, stackTrace);
      return Left(
        NetworkFailure(message: 'Failed to fetch currency rates', error: e),
      );
    }
  }

  /// Get cached currency rates
  Future<Either<Failure, CurrencyRatesModel>> getCachedRates() async {
    try {
      AppLogger.operation('CurrencyRepository', 'getCachedRates');

      final rates = await _remoteDataSource.getCachedRates();

      if (rates == null) {
        return Left(
          CacheFailure(
            message: 'No cached currency rates available',
            code: 'NOT_FOUND',
          ),
        );
      }

      AppLogger.operationSuccess('CurrencyRepository', 'getCachedRates');
      return Right(rates);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'CurrencyRepository',
        'getCachedRates',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(message: 'Failed to get cached currency rates', error: e),
      );
    }
  }

  /// Refresh currency rates from API
  Future<Either<Failure, CurrencyRatesModel>> refreshRates() async {
    try {
      AppLogger.operation('CurrencyRepository', 'refreshRates');

      final rates = await _remoteDataSource.fetchRates();

      AppLogger.operationSuccess('CurrencyRepository', 'refreshRates');
      return Right(rates);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'CurrencyRepository',
        'refreshRates',
        e,
        stackTrace,
      );
      return Left(
        NetworkFailure(message: 'Failed to refresh currency rates', error: e),
      );
    }
  }

  /// Check if cached rates are fresh
  Future<bool> isCacheFresh() async {
    try {
      return await _remoteDataSource.isCacheFresh();
    } catch (e) {
      AppLogger.error('Error checking cache freshness', e);
      return false;
    }
  }

  /// Convert amount between currencies
  Future<Either<Failure, double>> convert({
    required double amount,
    required String from,
    required String to,
  }) async {
    try {
      AppLogger.operation(
        'CurrencyRepository',
        'convert',
        data: '$amount $from -> $to',
      );

      // Get rates (with cache fallback)
      final ratesResult = await getRates();

      return ratesResult.fold((failure) => Left(failure), (rates) {
        try {
          final convertedAmount = rates.convert(
            amount: amount,
            from: from,
            to: to,
          );

          AppLogger.operationSuccess(
            'CurrencyRepository',
            'convert',
            data: 'Converted: $amount $from = $convertedAmount $to',
          );

          return Right(convertedAmount);
        } catch (e) {
          AppLogger.error('Currency conversion failed', e);
          return Left(
            GeneralFailure(message: 'Currency conversion failed', error: e),
          );
        }
      });
    } catch (e, stackTrace) {
      AppLogger.operationError('CurrencyRepository', 'convert', e, stackTrace);
      return Left(
        GeneralFailure(message: 'Failed to convert currency', error: e),
      );
    }
  }

  /// Get exchange rate between two currencies
  Future<Either<Failure, double>> getExchangeRate({
    required String from,
    required String to,
  }) async {
    try {
      AppLogger.operation(
        'CurrencyRepository',
        'getExchangeRate',
        data: '$from -> $to',
      );

      final ratesResult = await getRates();

      return ratesResult.fold((failure) => Left(failure), (rates) {
        try {
          // Convert 1 unit of from currency to to currency
          final rate = rates.convert(amount: 1.0, from: from, to: to);

          AppLogger.operationSuccess(
            'CurrencyRepository',
            'getExchangeRate',
            data: '1 $from = $rate $to',
          );

          return Right(rate);
        } catch (e) {
          AppLogger.error('Failed to get exchange rate', e);
          return Left(
            GeneralFailure(message: 'Failed to get exchange rate', error: e),
          );
        }
      });
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'CurrencyRepository',
        'getExchangeRate',
        e,
        stackTrace,
      );
      return Left(
        GeneralFailure(message: 'Failed to get exchange rate', error: e),
      );
    }
  }

  /// Get last update time of rates
  Future<Either<Failure, DateTime>> getLastUpdateTime() async {
    try {
      AppLogger.operation('CurrencyRepository', 'getLastUpdateTime');

      final ratesResult = await getCachedRates();

      return ratesResult.fold((failure) => Left(failure), (rates) {
        AppLogger.operationSuccess('CurrencyRepository', 'getLastUpdateTime');
        return Right(rates.lastUpdated);
      });
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'CurrencyRepository',
        'getLastUpdateTime',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(message: 'Failed to get last update time', error: e),
      );
    }
  }
}
