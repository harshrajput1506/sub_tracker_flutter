import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 2)
class SettingsModel extends HiveObject {
  @HiveField(0)
  final String globalCurrency;

  @HiveField(1)
  final String themeMode; // 'light', 'dark', 'system'

  @HiveField(2)
  final bool notificationsEnabled;

  @HiveField(3)
  final List<int> reminderDays; // [3, 1] for 3 days and 1 day before

  SettingsModel({
    required this.globalCurrency,
    required this.themeMode,
    required this.notificationsEnabled,
    required this.reminderDays,
  });

  factory SettingsModel.defaultSettings() {
    return SettingsModel(
      globalCurrency: 'USD',
      themeMode: 'system',
      notificationsEnabled: true,
      reminderDays: [3, 1],
    );
  }

  SettingsModel copyWith({
    String? globalCurrency,
    String? themeMode,
    bool? notificationsEnabled,
    List<int>? reminderDays,
  }) {
    return SettingsModel(
      globalCurrency: globalCurrency ?? this.globalCurrency,
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      reminderDays: reminderDays ?? this.reminderDays,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'globalCurrency': globalCurrency,
      'themeMode': themeMode,
      'notificationsEnabled': notificationsEnabled,
      'reminderDays': reminderDays,
    };
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      globalCurrency: json['globalCurrency'],
      themeMode: json['themeMode'],
      notificationsEnabled: json['notificationsEnabled'],
      reminderDays: List<int>.from(json['reminderDays']),
    );
  }
}
