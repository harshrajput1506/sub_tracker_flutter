import 'package:injectable/injectable.dart';
import 'package:sub/core/constants/constants.dart';
import 'package:sub/core/network/api_client.dart';
import 'package:sub/core/utils/logger.dart';
import 'package:sub/data/models/currency_rates_model.dart';
import 'package:hive/hive.dart';

/// Remote data source for currency rates from GitHub API
@lazySingleton
class CurrencyRemoteDataSource {
  final ApiClient _apiClient;
  final Box _box;

  CurrencyRemoteDataSource(this._apiClient, @Named('currencyBox') this._box);

  /// Fetch latest currency rates from API
  Future<CurrencyRatesModel> fetchRates() async {
    try {
      AppLogger.operation('CurrencyRemoteDataSource', 'fetchRates');

      // Fetch rates for USD (base currency)
      final usdUrl = '${ApiConstants.currencyApiBaseUrl}/usd.json';
      final usdResult = await _apiClient.get(usdUrl);

      return usdResult.fold(
        (failure) {
          AppLogger.error('Failed to fetch USD rates', failure.message);
          throw Exception(failure.message);
        },
        (data) async {
          // Parse the response
          final Map<String, dynamic> json = data as Map<String, dynamic>;
          final usdRates = json['usd'] as Map<String, dynamic>;

          // Create rates map with USD as 1.0
          final rates = <String, double>{
            'USD': 1.0,
            'INR': (usdRates['inr'] as num?)?.toDouble() ?? 83.0,
            'EUR': (usdRates['eur'] as num?)?.toDouble() ?? 0.92,
          };

          final currencyRates = CurrencyRatesModel(
            rates: rates,
            lastUpdated: DateTime.now(),
          );

          // Cache the rates locally
          await _cacheRates(currencyRates);

          AppLogger.operationSuccess(
            'CurrencyRemoteDataSource',
            'fetchRates',
            data: rates,
          );

          return currencyRates;
        },
      );
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'CurrencyRemoteDataSource',
        'fetchRates',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Get cached rates from local storage
  Future<CurrencyRatesModel?> getCachedRates() async {
    try {
      AppLogger.operation('CurrencyRemoteDataSource', 'getCachedRates');

      final ratesJson = _box.get('rates') as Map<String, dynamic>?;
      final lastUpdatedStr = _box.get('lastUpdated') as String?;

      if (ratesJson == null || lastUpdatedStr == null) {
        AppLogger.info('No cached rates found');
        return null;
      }

      // Convert rates to Map<String, double>
      final rates = <String, double>{};
      ratesJson.forEach((key, value) {
        if (value is num) {
          rates[key] = value.toDouble();
        }
      });

      final currencyRates = CurrencyRatesModel(
        rates: rates,
        lastUpdated: DateTime.parse(lastUpdatedStr),
      );

      AppLogger.operationSuccess(
        'CurrencyRemoteDataSource',
        'getCachedRates',
        data: 'Last updated: $lastUpdatedStr',
      );

      return currencyRates;
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'CurrencyRemoteDataSource',
        'getCachedRates',
        e,
        stackTrace,
      );
      return null;
    }
  }

  /// Cache rates locally
  Future<void> _cacheRates(CurrencyRatesModel rates) async {
    try {
      AppLogger.operation('CurrencyRemoteDataSource', '_cacheRates');

      await _box.put('rates', rates.rates);
      await _box.put('lastUpdated', rates.lastUpdated.toIso8601String());

      AppLogger.operationSuccess('CurrencyRemoteDataSource', '_cacheRates');
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'CurrencyRemoteDataSource',
        '_cacheRates',
        e,
        stackTrace,
      );
      // Don't rethrow - caching failure shouldn't break the flow
    }
  }

  /// Check if cached rates are fresh (less than 24 hours old)
  Future<bool> isCacheFresh() async {
    try {
      final cachedRates = await getCachedRates();
      if (cachedRates == null) return false;

      final age = DateTime.now().difference(cachedRates.lastUpdated);
      final isFresh = age.inHours < 24;

      AppLogger.info('Cache age: ${age.inHours} hours, fresh: $isFresh');
      return isFresh;
    } catch (e) {
      return false;
    }
  }

  /// Get rates with automatic cache fallback
  Future<CurrencyRatesModel> getRatesWithFallback() async {
    try {
      // Try to fetch fresh rates
      return await fetchRates();
    } catch (e) {
      AppLogger.warning('Failed to fetch fresh rates, using cache', e);

      // Fallback to cached rates
      final cachedRates = await getCachedRates();
      if (cachedRates != null) {
        return cachedRates;
      }

      // If no cache available, return default rates
      AppLogger.warning('No cached rates available, using defaults');
      return CurrencyRatesModel(
        rates: {'USD': 1.0, 'INR': 83.0, 'EUR': 0.92},
        lastUpdated: DateTime.now(),
      );
    }
  }
}
