import 'package:hive/hive.dart';

part 'subscription_model.g.dart';

@HiveType(typeId: 0)
class SubscriptionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String currency;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final DateTime startDate;

  @HiveField(6)
  final String recurringPeriod;

  @HiveField(7)
  final int? customDays;

  @HiveField(8)
  final String? paymentMethodId;

  @HiveField(9)
  final String? notes;

  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  final DateTime updatedAt;

  SubscriptionModel({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.category,
    required this.startDate,
    required this.recurringPeriod,
    this.customDays,
    this.paymentMethodId,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculate next renewal date
  DateTime get nextRenewal {
    final now = DateTime.now();
    DateTime nextDate = startDate;

    switch (recurringPeriod.toLowerCase()) {
      case 'monthly':
        while (nextDate.isBefore(now)) {
          nextDate = DateTime(nextDate.year, nextDate.month + 1, nextDate.day);
        }
        break;
      case 'quarterly':
        while (nextDate.isBefore(now)) {
          nextDate = DateTime(nextDate.year, nextDate.month + 3, nextDate.day);
        }
        break;
      case 'yearly':
        while (nextDate.isBefore(now)) {
          nextDate = DateTime(nextDate.year + 1, nextDate.month, nextDate.day);
        }
        break;
      case 'custom':
        if (customDays != null) {
          while (nextDate.isBefore(now)) {
            nextDate = nextDate.add(Duration(days: customDays!));
          }
        }
        break;
    }

    return nextDate;
  }

  /// Days until next renewal
  int get daysUntilRenewal {
    return nextRenewal.difference(DateTime.now()).inDays;
  }

  /// Copy with method
  SubscriptionModel copyWith({
    String? id,
    String? name,
    double? price,
    String? currency,
    String? category,
    DateTime? startDate,
    String? recurringPeriod,
    int? customDays,
    String? paymentMethodId,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      recurringPeriod: recurringPeriod ?? this.recurringPeriod,
      customDays: customDays ?? this.customDays,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'currency': currency,
      'category': category,
      'startDate': startDate.toIso8601String(),
      'recurringPeriod': recurringPeriod,
      'customDays': customDays,
      'paymentMethodId': paymentMethodId,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      currency: json['currency'],
      category: json['category'],
      startDate: DateTime.parse(json['startDate']),
      recurringPeriod: json['recurringPeriod'],
      customDays: json['customDays'],
      paymentMethodId: json['paymentMethodId'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
