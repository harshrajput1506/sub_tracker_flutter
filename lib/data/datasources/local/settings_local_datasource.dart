import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:sub/core/constants/constants.dart';
import 'package:sub/core/utils/logger.dart';
import 'package:sub/data/models/settings_model.dart';

/// Local data source for app settings using Hive
@lazySingleton
class SettingsLocalDataSource {
  final Box _box;

  SettingsLocalDataSource(@Named('settingsBox') this._box);

  /// Get settings
  Future<SettingsModel> getSettings() async {
    try {
      AppLogger.operation('SettingsLocalDataSource', 'getSettings');

      // Check if settings exist
      final globalCurrency =
          _box.get(SettingsKeys.globalCurrency, defaultValue: 'USD') as String;

      final themeMode =
          _box.get(SettingsKeys.themeMode, defaultValue: 'system') as String;

      final notificationsEnabled =
          _box.get(SettingsKeys.notificationsEnabled, defaultValue: true)
              as bool;

      final reminderDays =
          _box.get(SettingsKeys.reminderDays, defaultValue: [3, 1])
              as List<dynamic>;

      final settings = SettingsModel(
        globalCurrency: globalCurrency,
        themeMode: themeMode,
        notificationsEnabled: notificationsEnabled,
        reminderDays: List<int>.from(reminderDays),
      );

      AppLogger.operationSuccess('SettingsLocalDataSource', 'getSettings');
      return settings;
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SettingsLocalDataSource',
        'getSettings',
        e,
        stackTrace,
      );
      // Return default settings on error
      return SettingsModel.defaultSettings();
    }
  }

  /// Save settings
  Future<void> saveSettings(SettingsModel settings) async {
    try {
      AppLogger.operation(
        'SettingsLocalDataSource',
        'saveSettings',
        data: settings.toJson(),
      );

      await _box.put(SettingsKeys.globalCurrency, settings.globalCurrency);
      await _box.put(SettingsKeys.themeMode, settings.themeMode);
      await _box.put(
        SettingsKeys.notificationsEnabled,
        settings.notificationsEnabled,
      );
      await _box.put(SettingsKeys.reminderDays, settings.reminderDays);

      AppLogger.operationSuccess('SettingsLocalDataSource', 'saveSettings');
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SettingsLocalDataSource',
        'saveSettings',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Update global currency
  Future<void> updateGlobalCurrency(String currency) async {
    try {
      AppLogger.operation(
        'SettingsLocalDataSource',
        'updateGlobalCurrency',
        data: currency,
      );
      await _box.put(SettingsKeys.globalCurrency, currency);
      AppLogger.operationSuccess(
        'SettingsLocalDataSource',
        'updateGlobalCurrency',
      );
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SettingsLocalDataSource',
        'updateGlobalCurrency',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Update theme mode
  Future<void> updateThemeMode(String themeMode) async {
    try {
      AppLogger.operation(
        'SettingsLocalDataSource',
        'updateThemeMode',
        data: themeMode,
      );
      await _box.put(SettingsKeys.themeMode, themeMode);
      AppLogger.operationSuccess('SettingsLocalDataSource', 'updateThemeMode');
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SettingsLocalDataSource',
        'updateThemeMode',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Update notifications enabled
  Future<void> updateNotificationsEnabled(bool enabled) async {
    try {
      AppLogger.operation(
        'SettingsLocalDataSource',
        'updateNotificationsEnabled',
        data: enabled,
      );
      await _box.put(SettingsKeys.notificationsEnabled, enabled);
      AppLogger.operationSuccess(
        'SettingsLocalDataSource',
        'updateNotificationsEnabled',
      );
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SettingsLocalDataSource',
        'updateNotificationsEnabled',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Update reminder days
  Future<void> updateReminderDays(List<int> days) async {
    try {
      AppLogger.operation(
        'SettingsLocalDataSource',
        'updateReminderDays',
        data: days,
      );
      await _box.put(SettingsKeys.reminderDays, days);
      AppLogger.operationSuccess(
        'SettingsLocalDataSource',
        'updateReminderDays',
      );
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SettingsLocalDataSource',
        'updateReminderDays',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Reset to default settings
  Future<void> resetToDefaults() async {
    try {
      AppLogger.operation('SettingsLocalDataSource', 'resetToDefaults');
      await saveSettings(SettingsModel.defaultSettings());
      AppLogger.operationSuccess('SettingsLocalDataSource', 'resetToDefaults');
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SettingsLocalDataSource',
        'resetToDefaults',
        e,
        stackTrace,
      );
      rethrow;
    }
  }
}
