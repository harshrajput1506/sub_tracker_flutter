import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sub/core/error/failures.dart';
import 'package:sub/core/utils/logger.dart';
import 'package:sub/data/models/subscription_model.dart';
import 'package:sub/data/repositories/subscription_repository.dart';
import 'package:sub/features/subscriptions/bloc/subscription_event.dart';
import 'package:sub/features/subscriptions/bloc/subscription_state.dart';

/// BLoC for managing subscription state
@injectable
class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository _repository;

  SubscriptionBloc(this._repository) : super(const SubscriptionInitial()) {
    on<LoadSubscriptionsEvent>(_onLoadSubscriptions);
    on<LoadSubscriptionByIdEvent>(_onLoadSubscriptionById);
    on<AddSubscriptionEvent>(_onAddSubscription);
    on<UpdateSubscriptionEvent>(_onUpdateSubscription);
    on<DeleteSubscriptionEvent>(_onDeleteSubscription);
    on<SearchSubscriptionsEvent>(_onSearchSubscriptions);
    on<FilterByCategoryEvent>(_onFilterByCategory);
    on<FilterByPaymentMethodEvent>(_onFilterByPaymentMethod);
    on<FilterByCurrencyEvent>(_onFilterByCurrency);
    on<LoadUpcomingRenewalsEvent>(_onLoadUpcomingRenewals);
    on<RefreshSubscriptionsEvent>(_onRefreshSubscriptions);
  }

  /// Load all subscriptions
  Future<void> _onLoadSubscriptions(
    LoadSubscriptionsEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    AppLogger.operation('SubscriptionBloc', 'LoadSubscriptions');
    emit(const SubscriptionLoading());

    final result = await _repository.getAll();

    result.fold(
      (failure) {
        AppLogger.error('Failed to load subscriptions', failure);
        emit(SubscriptionError(message: _mapFailureToMessage(failure)));
      },
      (subscriptions) {
        if (subscriptions.isEmpty) {
          emit(const SubscriptionsEmpty(isFiltered: false));
        } else {
          emit(SubscriptionsLoaded(subscriptions: subscriptions));
        }
        AppLogger.operationSuccess(
          'SubscriptionBloc',
          'LoadSubscriptions',
          data: '${subscriptions.length} subscriptions loaded',
        );
      },
    );
  }

  /// Load subscription by ID
  Future<void> _onLoadSubscriptionById(
    LoadSubscriptionByIdEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    AppLogger.operation(
      'SubscriptionBloc',
      'LoadSubscriptionById',
      data: event.id,
    );
    emit(const SubscriptionLoading());

    final result = await _repository.getById(event.id);

    result.fold(
      (failure) {
        AppLogger.error('Failed to load subscription', failure);
        emit(SubscriptionError(message: _mapFailureToMessage(failure)));
      },
      (subscription) {
        emit(SubscriptionDetailLoaded(subscription));
        AppLogger.operationSuccess('SubscriptionBloc', 'LoadSubscriptionById');
      },
    );
  }

  /// Add new subscription
  Future<void> _onAddSubscription(
    AddSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    AppLogger.operation(
      'SubscriptionBloc',
      'AddSubscription',
      data: event.name,
    );
    emit(const SubscriptionLoading());

    final result = await _repository.add(
      name: event.name,
      price: event.price,
      currency: event.currency,
      category: event.category,
      startDate: event.startDate,
      recurringPeriod: event.recurringPeriod,
      customDays: event.customDays,
      paymentMethodId: event.paymentMethodId,
      notes: event.notes,
    );

    result.fold(
      (failure) {
        AppLogger.error('Failed to add subscription', failure);
        emit(SubscriptionError(message: _mapFailureToMessage(failure)));
      },
      (_) {
        AppLogger.operationSuccess('SubscriptionBloc', 'AddSubscription');
        emit(
          const SubscriptionOperationSuccess(
            message: 'Subscription added successfully',
            operationType: SubscriptionOperationType.add,
          ),
        );
        // Reload subscriptions
        add(const LoadSubscriptionsEvent());
      },
    );
  }

  /// Update existing subscription
  Future<void> _onUpdateSubscription(
    UpdateSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    AppLogger.operation(
      'SubscriptionBloc',
      'UpdateSubscription',
      data: event.id,
    );
    emit(const SubscriptionLoading());

    // Get existing subscription to preserve createdAt
    final existingResult = await _repository.getById(event.id);

    await existingResult.fold(
      (failure) async {
        AppLogger.error('Failed to find subscription', failure);
        emit(SubscriptionError(message: _mapFailureToMessage(failure)));
      },
      (existing) async {
        final updatedSubscription = SubscriptionModel(
          id: event.id,
          name: event.name,
          price: event.price,
          currency: event.currency,
          category: event.category,
          startDate: event.startDate,
          recurringPeriod: event.recurringPeriod,
          customDays: event.customDays,
          paymentMethodId: event.paymentMethodId,
          notes: event.notes,
          createdAt: existing.createdAt,
          updatedAt: DateTime.now(),
        );

        final result = await _repository.update(updatedSubscription);

        result.fold(
          (failure) {
            AppLogger.error('Failed to update subscription', failure);
            emit(SubscriptionError(message: _mapFailureToMessage(failure)));
          },
          (_) {
            AppLogger.operationSuccess(
              'SubscriptionBloc',
              'UpdateSubscription',
            );
            emit(
              const SubscriptionOperationSuccess(
                message: 'Subscription updated successfully',
                operationType: SubscriptionOperationType.update,
              ),
            );
            // Reload subscriptions
            add(const LoadSubscriptionsEvent());
          },
        );
      },
    );
  }

  /// Delete subscription
  Future<void> _onDeleteSubscription(
    DeleteSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    AppLogger.operation(
      'SubscriptionBloc',
      'DeleteSubscription',
      data: event.id,
    );
    emit(const SubscriptionLoading());

    final result = await _repository.delete(event.id);

    result.fold(
      (failure) {
        AppLogger.error('Failed to delete subscription', failure);
        emit(SubscriptionError(message: _mapFailureToMessage(failure)));
      },
      (_) {
        AppLogger.operationSuccess('SubscriptionBloc', 'DeleteSubscription');
        emit(
          const SubscriptionOperationSuccess(
            message: 'Subscription deleted successfully',
            operationType: SubscriptionOperationType.delete,
          ),
        );
        // Reload subscriptions
        add(const LoadSubscriptionsEvent());
      },
    );
  }

  /// Search subscriptions
  Future<void> _onSearchSubscriptions(
    SearchSubscriptionsEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    AppLogger.operation(
      'SubscriptionBloc',
      'SearchSubscriptions',
      data: event.query,
    );
    emit(const SubscriptionLoading());

    if (event.query.trim().isEmpty) {
      // If search query is empty, load all subscriptions
      add(const LoadSubscriptionsEvent());
      return;
    }

    final result = await _repository.search(event.query);

    result.fold(
      (failure) {
        AppLogger.error('Failed to search subscriptions', failure);
        emit(SubscriptionError(message: _mapFailureToMessage(failure)));
      },
      (subscriptions) {
        if (subscriptions.isEmpty) {
          emit(
            const SubscriptionsEmpty(
              message: 'No subscriptions found matching your search',
              isFiltered: true,
            ),
          );
        } else {
          emit(
            SubscriptionsLoaded(
              subscriptions: subscriptions,
              isFiltered: true,
              filterType: 'search',
            ),
          );
        }
        AppLogger.operationSuccess('SubscriptionBloc', 'SearchSubscriptions');
      },
    );
  }

  /// Filter by category
  Future<void> _onFilterByCategory(
    FilterByCategoryEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    AppLogger.operation(
      'SubscriptionBloc',
      'FilterByCategory',
      data: event.category,
    );
    emit(const SubscriptionLoading());

    final result = await _repository.getByCategory(event.category);

    result.fold(
      (failure) {
        AppLogger.error('Failed to filter by category', failure);
        emit(SubscriptionError(message: _mapFailureToMessage(failure)));
      },
      (subscriptions) {
        if (subscriptions.isEmpty) {
          emit(
            SubscriptionsEmpty(
              message: 'No subscriptions found in ${event.category} category',
              isFiltered: true,
            ),
          );
        } else {
          emit(
            SubscriptionsLoaded(
              subscriptions: subscriptions,
              isFiltered: true,
              filterType: 'category',
            ),
          );
        }
        AppLogger.operationSuccess('SubscriptionBloc', 'FilterByCategory');
      },
    );
  }

  /// Filter by payment method
  Future<void> _onFilterByPaymentMethod(
    FilterByPaymentMethodEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    AppLogger.operation(
      'SubscriptionBloc',
      'FilterByPaymentMethod',
      data: event.paymentMethodId,
    );
    emit(const SubscriptionLoading());

    final result = await _repository.getByPaymentMethod(event.paymentMethodId);

    result.fold(
      (failure) {
        AppLogger.error('Failed to filter by payment method', failure);
        emit(SubscriptionError(message: _mapFailureToMessage(failure)));
      },
      (subscriptions) {
        if (subscriptions.isEmpty) {
          emit(
            const SubscriptionsEmpty(
              message: 'No subscriptions found for this payment method',
              isFiltered: true,
            ),
          );
        } else {
          emit(
            SubscriptionsLoaded(
              subscriptions: subscriptions,
              isFiltered: true,
              filterType: 'payment_method',
            ),
          );
        }
        AppLogger.operationSuccess('SubscriptionBloc', 'FilterByPaymentMethod');
      },
    );
  }

  /// Filter by currency
  Future<void> _onFilterByCurrency(
    FilterByCurrencyEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    AppLogger.operation(
      'SubscriptionBloc',
      'FilterByCurrency',
      data: event.currency,
    );
    emit(const SubscriptionLoading());

    final result = await _repository.getByCurrency(event.currency);

    result.fold(
      (failure) {
        AppLogger.error('Failed to filter by currency', failure);
        emit(SubscriptionError(message: _mapFailureToMessage(failure)));
      },
      (subscriptions) {
        if (subscriptions.isEmpty) {
          emit(
            SubscriptionsEmpty(
              message: 'No subscriptions found in ${event.currency}',
              isFiltered: true,
            ),
          );
        } else {
          emit(
            SubscriptionsLoaded(
              subscriptions: subscriptions,
              isFiltered: true,
              filterType: 'currency',
            ),
          );
        }
        AppLogger.operationSuccess('SubscriptionBloc', 'FilterByCurrency');
      },
    );
  }

  /// Load upcoming renewals
  Future<void> _onLoadUpcomingRenewals(
    LoadUpcomingRenewalsEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    AppLogger.operation(
      'SubscriptionBloc',
      'LoadUpcomingRenewals',
      data: event.days,
    );
    emit(const SubscriptionLoading());

    final result = await _repository.getUpcomingRenewals(event.days);

    result.fold(
      (failure) {
        AppLogger.error('Failed to load upcoming renewals', failure);
        emit(SubscriptionError(message: _mapFailureToMessage(failure)));
      },
      (subscriptions) {
        if (subscriptions.isEmpty) {
          emit(
            SubscriptionsEmpty(
              message: 'No upcoming renewals in the next ${event.days} days',
              isFiltered: true,
            ),
          );
        } else {
          emit(
            SubscriptionsLoaded(
              subscriptions: subscriptions,
              isFiltered: true,
              filterType: 'upcoming_renewals',
            ),
          );
        }
        AppLogger.operationSuccess('SubscriptionBloc', 'LoadUpcomingRenewals');
      },
    );
  }

  /// Refresh subscriptions
  Future<void> _onRefreshSubscriptions(
    RefreshSubscriptionsEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    AppLogger.operation('SubscriptionBloc', 'RefreshSubscriptions');
    add(const LoadSubscriptionsEvent());
  }

  /// Map failure to user-friendly message
  String _mapFailureToMessage(Failure failure) {
    if (failure is ValidationFailure) {
      return failure.message;
    } else if (failure is CacheFailure) {
      return failure.getUserMessage();
    } else if (failure is NetworkFailure) {
      return failure.getUserMessage();
    } else {
      return failure.getUserMessage();
    }
  }
}
