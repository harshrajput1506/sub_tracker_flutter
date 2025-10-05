/// API constants
class ApiConstants {
  ApiConstants._();

  // Currency API
  static const String currencyApiBaseUrl =
      'https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies';

  // Timeout durations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}

/// Hive box names
class HiveBoxNames {
  HiveBoxNames._();

  static const String subscriptions = 'subscriptions';
  static const String paymentMethods = 'payment_methods';
  static const String settings = 'settings';
  static const String currencyRates = 'currency_rates';
}

/// Hive type IDs
class HiveTypeIds {
  HiveTypeIds._();

  static const int subscription = 0;
  static const int paymentMethod = 1;
  static const int settings = 2;
  static const int currencyRates = 3;
}

/// App settings keys
class SettingsKeys {
  SettingsKeys._();

  static const String themeMode = 'theme_mode';
  static const String globalCurrency = 'global_currency';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String reminderDays = 'reminder_days';
}

/// Notification IDs
class NotificationIds {
  NotificationIds._();

  static const String renewalChannel = 'renewal_reminders';
  static const int renewalNotificationId = 1;
}

/// Supported currencies
class Currencies {
  Currencies._();

  static const String usd = 'USD';
  static const String inr = 'INR';
  static const String eur = 'EUR';

  static const List<String> supported = [usd, inr, eur];

  static String getSymbol(String currency) {
    switch (currency) {
      case usd:
        return '\$';
      case inr:
        return '₹';
      case eur:
        return '€';
      default:
        return currency;
    }
  }
}

/// Subscription categories
class SubscriptionCategories {
  SubscriptionCategories._();

  static const String entertainment = 'Entertainment';
  static const String productivity = 'Productivity';
  static const String utilities = 'Utilities';
  static const String education = 'Education';
  static const String fitness = 'Fitness';
  static const String finance = 'Finance';
  static const String shopping = 'Shopping';
  static const String other = 'Other';

  static const List<String> all = [
    entertainment,
    productivity,
    utilities,
    education,
    fitness,
    finance,
    shopping,
    other,
  ];
}

/// Recurring periods
class RecurringPeriod {
  RecurringPeriod._();

  static const String monthly = 'Monthly';
  static const String quarterly = 'Quarterly';
  static const String yearly = 'Yearly';
  static const String custom = 'Custom';

  static const List<String> all = [monthly, quarterly, yearly, custom];
}
