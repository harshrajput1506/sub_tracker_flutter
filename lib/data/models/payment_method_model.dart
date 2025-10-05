import 'package:hive/hive.dart';

part 'payment_method_model.g.dart';

@HiveType(typeId: 1)
class PaymentMethodModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type; // Card, UPI, PayPal, etc.

  @HiveField(3)
  final String? lastFourDigits;

  @HiveField(4)
  final String? notes;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.type,
    this.lastFourDigits,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  PaymentMethodModel copyWith({
    String? id,
    String? name,
    String? type,
    String? lastFourDigits,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'lastFourDigits': lastFourDigits,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      lastFourDigits: json['lastFourDigits'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
