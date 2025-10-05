import 'package:intl/intl.dart';

/// Date formatter utilities
class DateFormatter {
  DateFormatter._();

  /// Format date to dd MMM yyyy (e.g., 05 Oct 2025)
  static String format(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Format date to dd/MM/yyyy
  static String formatSlash(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Format date to MMM dd, yyyy (e.g., Oct 05, 2025)
  static String formatLong(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format date to relative time (e.g., 2 days ago, in 3 days)
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes.abs()} minutes ${difference.isNegative ? 'ago' : 'from now'}';
      }
      return '${difference.inHours.abs()} hours ${difference.isNegative ? 'ago' : 'from now'}';
    } else if (difference.inDays.abs() < 7) {
      return '${difference.inDays.abs()} days ${difference.isNegative ? 'ago' : 'from now'}';
    } else if (difference.inDays.abs() < 30) {
      final weeks = (difference.inDays.abs() / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ${difference.isNegative ? 'ago' : 'from now'}';
    } else if (difference.inDays.abs() < 365) {
      final months = (difference.inDays.abs() / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ${difference.isNegative ? 'ago' : 'from now'}';
    } else {
      final years = (difference.inDays.abs() / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ${difference.isNegative ? 'ago' : 'from now'}';
    }
  }

  /// Calculate next renewal date based on period
  static DateTime calculateNextRenewal(
    DateTime startDate,
    String period, {
    int? customDays,
  }) {
    final now = DateTime.now();
    DateTime nextRenewal = startDate;

    switch (period.toLowerCase()) {
      case 'monthly':
        while (nextRenewal.isBefore(now)) {
          nextRenewal = DateTime(
            nextRenewal.year,
            nextRenewal.month + 1,
            nextRenewal.day,
          );
        }
        break;
      case 'quarterly':
        while (nextRenewal.isBefore(now)) {
          nextRenewal = DateTime(
            nextRenewal.year,
            nextRenewal.month + 3,
            nextRenewal.day,
          );
        }
        break;
      case 'yearly':
        while (nextRenewal.isBefore(now)) {
          nextRenewal = DateTime(
            nextRenewal.year + 1,
            nextRenewal.month,
            nextRenewal.day,
          );
        }
        break;
      case 'custom':
        if (customDays != null) {
          while (nextRenewal.isBefore(now)) {
            nextRenewal = nextRenewal.add(Duration(days: customDays));
          }
        }
        break;
    }

    return nextRenewal;
  }
}

/// Currency formatter utilities
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Format amount with currency symbol
  static String format(double amount, String currency) {
    final symbol = _getCurrencySymbol(currency);
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  /// Format amount with full currency code
  static String formatWithCode(double amount, String currency) {
    return '${amount.toStringAsFixed(2)} $currency';
  }

  /// Format large numbers (e.g., 1.5K, 2.3M)
  static String formatCompact(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(2);
  }

  static String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'INR':
        return '₹';
      case 'EUR':
        return '€';
      default:
        return currency;
    }
  }
}
