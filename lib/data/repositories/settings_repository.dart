import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sub/core/error/failures.dart';
import 'package:sub/core/utils/logger.dart';
import 'package:sub/data/datasources/local/settings_local_datasource.dart';
import 'package:sub/data/models/settings_model.dart';

/// Repository for app settings operations
@lazySingleton
class SettingsRepository {
  final SettingsLocalDataSource _localDataSource;

  SettingsRepository(this._localDataSource);

  /// Get app settings
  Future<Either<Failure, SettingsModel>> getSettings() async {
    try {
      AppLogger.operation('SettingsRepository', 'getSettings');
      final settings = await _localDataSource.getSettings();
      AppLogger.operationSuccess('SettingsRepository', 'getSettings');
      return Right(settings);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SettingsRepository',
        'getSettings',
        e,
        stackTrace,
      );
      return Left(CacheFailure(message: 'Failed to load settings', error: e));
    }
  }

  /// Save settings
  Future<Either<Failure, void>> saveSettings(SettingsModel settings) async {
    try {
      AppLogger.operation('SettingsRepository', 'saveSettings');
      await _localDataSource.saveSettings(settings);
      AppLogger.operationSuccess('SettingsRepository', 'saveSettings');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SettingsRepository',
        'saveSettings',
        e,
        stackTrace,
      );
      return Left(CacheFailure(message: 'Failed to save settings', error: e));
    }
  }

  /// Update global currency
  Future<Either<Failure, void>> updateGlobalCurrency(String currency) async {
    try {
      AppLogger.operation(
        'SettingsRepository',
        'updateGlobalCurrency',
        data: currency,
      );

      // Validate currency
      if (!['USD', 'INR', 'EUR'].contains(currency.toUpperCase())) {
        return Left(
          ValidationFailure(
            message: 'Invalid currency. Supported: USD, INR, EUR',
          ),
        );
      }

      await _localDataSource.updateGlobalCurrency(currency.toUpperCase());
      AppLogger.operationSuccess('SettingsRepository', 'updateGlobalCurrency');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SettingsRepository',
        'updateGlobalCurrency',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(message: 'Failed to update global currency', error: e),
      );
    }
  }

  /// Update theme mode
  Future<Either<Failure, void>> updateThemeMode(String themeMode) async {
    try {
      AppLogger.operation(
        'SettingsRepository',
        'updateThemeMode',
        data: themeMode,
      );

      // Validate theme mode
      if (!['light', 'dark', 'system'].contains(themeMode.toLowerCase())) {
        return Left(
          ValidationFailure(
            message: 'Invalid theme mode. Supported: light, dark, system',
          ),
        );
      }

      await _localDataSource.updateThemeMode(themeMode.toLowerCase());
      AppLogger.operationSuccess('SettingsRepository', 'updateThemeMode');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SettingsRepository',
        'updateThemeMode',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(message: 'Failed to update theme mode', error: e),
      );
    }
  }

  /// Update notifications enabled
  Future<Either<Failure, void>> updateNotificationsEnabled(bool enabled) async {
    try {
      AppLogger.operation(
        'SettingsRepository',
        'updateNotificationsEnabled',
        data: enabled,
      );
      await _localDataSource.updateNotificationsEnabled(enabled);
      AppLogger.operationSuccess(
        'SettingsRepository',
        'updateNotificationsEnabled',
      );
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SettingsRepository',
        'updateNotificationsEnabled',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(
          message: 'Failed to update notifications setting',
          error: e,
        ),
      );
    }
  }

  /// Update reminder days
  Future<Either<Failure, void>> updateReminderDays(List<int> days) async {
    try {
      AppLogger.operation(
        'SettingsRepository',
        'updateReminderDays',
        data: days,
      );

      // Validate reminder days
      if (days.isEmpty) {
        return Left(
          ValidationFailure(message: 'At least one reminder day is required'),
        );
      }

      if (days.any((day) => day < 0 || day > 30)) {
        return Left(
          ValidationFailure(message: 'Reminder days must be between 0 and 30'),
        );
      }

      // Sort and remove duplicates
      final uniqueDays = days.toSet().toList()..sort((a, b) => b.compareTo(a));

      await _localDataSource.updateReminderDays(uniqueDays);
      AppLogger.operationSuccess('SettingsRepository', 'updateReminderDays');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SettingsRepository',
        'updateReminderDays',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(message: 'Failed to update reminder days', error: e),
      );
    }
  }

  /// Reset to default settings
  Future<Either<Failure, void>> resetToDefaults() async {
    try {
      AppLogger.operation('SettingsRepository', 'resetToDefaults');
      await _localDataSource.resetToDefaults();
      AppLogger.operationSuccess('SettingsRepository', 'resetToDefaults');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SettingsRepository',
        'resetToDefaults',
        e,
        stackTrace,
      );
      return Left(CacheFailure(message: 'Failed to reset settings', error: e));
    }
  }
}
