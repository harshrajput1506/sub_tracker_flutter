import 'package:equatable/equatable.dart';
import 'package:sub/data/models/subscription_model.dart';

/// Base class for all subscription states
abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial();
}

/// Loading state
class SubscriptionLoading extends SubscriptionState {
  const SubscriptionLoading();
}

/// State when subscriptions are loaded successfully
class SubscriptionsLoaded extends SubscriptionState {
  final List<SubscriptionModel> subscriptions;
  final bool isFiltered;
  final String? filterType;

  const SubscriptionsLoaded({
    required this.subscriptions,
    this.isFiltered = false,
    this.filterType,
  });

  @override
  List<Object?> get props => [subscriptions, isFiltered, filterType];

  /// Copy with method
  SubscriptionsLoaded copyWith({
    List<SubscriptionModel>? subscriptions,
    bool? isFiltered,
    String? filterType,
  }) {
    return SubscriptionsLoaded(
      subscriptions: subscriptions ?? this.subscriptions,
      isFiltered: isFiltered ?? this.isFiltered,
      filterType: filterType ?? this.filterType,
    );
  }
}

/// State when a single subscription is loaded
class SubscriptionDetailLoaded extends SubscriptionState {
  final SubscriptionModel subscription;

  const SubscriptionDetailLoaded(this.subscription);

  @override
  List<Object?> get props => [subscription];
}

/// State when subscription operation is successful
class SubscriptionOperationSuccess extends SubscriptionState {
  final String message;
  final SubscriptionOperationType operationType;

  const SubscriptionOperationSuccess({
    required this.message,
    required this.operationType,
  });

  @override
  List<Object?> get props => [message, operationType];
}

/// State when an error occurs
class SubscriptionError extends SubscriptionState {
  final String message;
  final String? code;

  const SubscriptionError({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// State when subscriptions are empty
class SubscriptionsEmpty extends SubscriptionState {
  final String message;
  final bool isFiltered;

  const SubscriptionsEmpty({
    this.message = 'No subscriptions found. Add your first subscription!',
    this.isFiltered = false,
  });

  @override
  List<Object?> get props => [message, isFiltered];
}

/// Enum for operation types
enum SubscriptionOperationType { add, update, delete }
