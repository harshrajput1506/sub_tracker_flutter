import 'package:hive/hive.dart';

part 'currency_rates_model.g.dart';

@HiveType(typeId: 3)
class CurrencyRatesModel extends HiveObject {
  @HiveField(0)
  final Map<String, double> rates;

  @HiveField(1)
  final DateTime lastUpdated;

  CurrencyRatesModel({required this.rates, required this.lastUpdated});

  /// Convert amount from one currency to another
  double convert({
    required double amount,
    required String from,
    required String to,
  }) {
    if (from == to) return amount;

    final fromRate = rates[from.toUpperCase()];
    final toRate = rates[to.toUpperCase()];

    if (fromRate == null || toRate == null) {
      throw Exception('Currency rate not found');
    }

    // Convert to USD first, then to target currency
    final amountInUSD = amount / fromRate;
    return amountInUSD * toRate;
  }

  CurrencyRatesModel copyWith({
    Map<String, double>? rates,
    DateTime? lastUpdated,
  }) {
    return CurrencyRatesModel(
      rates: rates ?? this.rates,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {'rates': rates, 'lastUpdated': lastUpdated.toIso8601String()};
  }

  factory CurrencyRatesModel.fromJson(Map<String, dynamic> json) {
    return CurrencyRatesModel(
      rates: Map<String, double>.from(
        json['rates'].map((key, value) => MapEntry(key, value.toDouble())),
      ),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}
