import 'package:equatable/equatable.dart';

/// Base class for all subscription events
abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all subscriptions
class LoadSubscriptionsEvent extends SubscriptionEvent {
  const LoadSubscriptionsEvent();
}

/// Event to load a single subscription by ID
class LoadSubscriptionByIdEvent extends SubscriptionEvent {
  final String id;

  const LoadSubscriptionByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to add a new subscription
class AddSubscriptionEvent extends SubscriptionEvent {
  final String name;
  final double price;
  final String currency;
  final String category;
  final DateTime startDate;
  final String recurringPeriod;
  final int? customDays;
  final String? paymentMethodId;
  final String? notes;

  const AddSubscriptionEvent({
    required this.name,
    required this.price,
    required this.currency,
    required this.category,
    required this.startDate,
    required this.recurringPeriod,
    this.customDays,
    this.paymentMethodId,
    this.notes,
  });

  @override
  List<Object?> get props => [
    name,
    price,
    currency,
    category,
    startDate,
    recurringPeriod,
    customDays,
    paymentMethodId,
    notes,
  ];
}

/// Event to update an existing subscription
class UpdateSubscriptionEvent extends SubscriptionEvent {
  final String id;
  final String name;
  final double price;
  final String currency;
  final String category;
  final DateTime startDate;
  final String recurringPeriod;
  final int? customDays;
  final String? paymentMethodId;
  final String? notes;

  const UpdateSubscriptionEvent({
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
  });

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    currency,
    category,
    startDate,
    recurringPeriod,
    customDays,
    paymentMethodId,
    notes,
  ];
}

/// Event to delete a subscription
class DeleteSubscriptionEvent extends SubscriptionEvent {
  final String id;

  const DeleteSubscriptionEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to search subscriptions by query
class SearchSubscriptionsEvent extends SubscriptionEvent {
  final String query;

  const SearchSubscriptionsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event to filter subscriptions by category
class FilterByCategoryEvent extends SubscriptionEvent {
  final String category;

  const FilterByCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

/// Event to filter subscriptions by payment method
class FilterByPaymentMethodEvent extends SubscriptionEvent {
  final String paymentMethodId;

  const FilterByPaymentMethodEvent(this.paymentMethodId);

  @override
  List<Object?> get props => [paymentMethodId];
}

/// Event to filter subscriptions by currency
class FilterByCurrencyEvent extends SubscriptionEvent {
  final String currency;

  const FilterByCurrencyEvent(this.currency);

  @override
  List<Object?> get props => [currency];
}

/// Event to get upcoming renewals
class LoadUpcomingRenewalsEvent extends SubscriptionEvent {
  final int days;

  const LoadUpcomingRenewalsEvent(this.days);

  @override
  List<Object?> get props => [days];
}

/// Event to refresh subscriptions
class RefreshSubscriptionsEvent extends SubscriptionEvent {
  const RefreshSubscriptionsEvent();
}
