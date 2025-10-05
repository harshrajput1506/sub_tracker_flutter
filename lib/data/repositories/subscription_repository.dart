import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sub/core/error/failures.dart';
import 'package:sub/core/utils/logger.dart';
import 'package:sub/data/datasources/local/subscription_local_datasource.dart';
import 'package:sub/data/models/subscription_model.dart';
import 'package:uuid/uuid.dart';

/// Repository for subscription operations
@lazySingleton
class SubscriptionRepository {
  final SubscriptionLocalDataSource _localDataSource;
  final Uuid _uuid = const Uuid();

  SubscriptionRepository(this._localDataSource);

  /// Get all subscriptions
  Future<Either<Failure, List<SubscriptionModel>>> getAll() async {
    try {
      AppLogger.operation('SubscriptionRepository', 'getAll');
      final subscriptions = await _localDataSource.getAll();
      AppLogger.operationSuccess('SubscriptionRepository', 'getAll');
      return Right(subscriptions);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionRepository',
        'getAll',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(message: 'Failed to load subscriptions', error: e),
      );
    }
  }

  /// Get subscription by ID
  Future<Either<Failure, SubscriptionModel>> getById(String id) async {
    try {
      AppLogger.operation('SubscriptionRepository', 'getById', data: id);
      final subscription = await _localDataSource.getById(id);

      if (subscription == null) {
        return Left(
          CacheFailure(message: 'Subscription not found', code: 'NOT_FOUND'),
        );
      }

      AppLogger.operationSuccess('SubscriptionRepository', 'getById');
      return Right(subscription);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionRepository',
        'getById',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(message: 'Failed to load subscription', error: e),
      );
    }
  }

  /// Get subscriptions by category
  Future<Either<Failure, List<SubscriptionModel>>> getByCategory(
    String category,
  ) async {
    try {
      AppLogger.operation(
        'SubscriptionRepository',
        'getByCategory',
        data: category,
      );
      final subscriptions = await _localDataSource.getByCategory(category);
      AppLogger.operationSuccess('SubscriptionRepository', 'getByCategory');
      return Right(subscriptions);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionRepository',
        'getByCategory',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(
          message: 'Failed to load subscriptions by category',
          error: e,
        ),
      );
    }
  }

  /// Get subscriptions by payment method
  Future<Either<Failure, List<SubscriptionModel>>> getByPaymentMethod(
    String paymentMethodId,
  ) async {
    try {
      AppLogger.operation(
        'SubscriptionRepository',
        'getByPaymentMethod',
        data: paymentMethodId,
      );
      final subscriptions = await _localDataSource.getByPaymentMethod(
        paymentMethodId,
      );
      AppLogger.operationSuccess(
        'SubscriptionRepository',
        'getByPaymentMethod',
      );
      return Right(subscriptions);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionRepository',
        'getByPaymentMethod',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(
          message: 'Failed to load subscriptions by payment method',
          error: e,
        ),
      );
    }
  }

  /// Get subscriptions by currency
  Future<Either<Failure, List<SubscriptionModel>>> getByCurrency(
    String currency,
  ) async {
    try {
      AppLogger.operation(
        'SubscriptionRepository',
        'getByCurrency',
        data: currency,
      );
      final subscriptions = await _localDataSource.getByCurrency(currency);
      AppLogger.operationSuccess('SubscriptionRepository', 'getByCurrency');
      return Right(subscriptions);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionRepository',
        'getByCurrency',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(
          message: 'Failed to load subscriptions by currency',
          error: e,
        ),
      );
    }
  }

  /// Get upcoming renewals
  Future<Either<Failure, List<SubscriptionModel>>> getUpcomingRenewals(
    int days,
  ) async {
    try {
      AppLogger.operation(
        'SubscriptionRepository',
        'getUpcomingRenewals',
        data: days,
      );
      final subscriptions = await _localDataSource.getUpcomingRenewals(days);
      AppLogger.operationSuccess(
        'SubscriptionRepository',
        'getUpcomingRenewals',
      );
      return Right(subscriptions);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionRepository',
        'getUpcomingRenewals',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(message: 'Failed to load upcoming renewals', error: e),
      );
    }
  }

  /// Search subscriptions
  Future<Either<Failure, List<SubscriptionModel>>> search(String query) async {
    try {
      AppLogger.operation('SubscriptionRepository', 'search', data: query);
      final subscriptions = await _localDataSource.search(query);
      AppLogger.operationSuccess('SubscriptionRepository', 'search');
      return Right(subscriptions);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionRepository',
        'search',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(message: 'Failed to search subscriptions', error: e),
      );
    }
  }

  /// Add subscription
  Future<Either<Failure, SubscriptionModel>> add({
    required String name,
    required double price,
    required String currency,
    required String category,
    required DateTime startDate,
    required String recurringPeriod,
    int? customDays,
    String? paymentMethodId,
    String? notes,
  }) async {
    try {
      AppLogger.operation('SubscriptionRepository', 'add', data: name);

      // Validate input
      if (name.trim().isEmpty) {
        return Left(
          ValidationFailure(message: 'Subscription name is required'),
        );
      }

      if (price <= 0) {
        return Left(ValidationFailure(message: 'Price must be greater than 0'));
      }

      if (recurringPeriod.toLowerCase() == 'custom' && customDays == null) {
        return Left(
          ValidationFailure(
            message: 'Custom days required for custom recurring period',
          ),
        );
      }

      final now = DateTime.now();
      final subscription = SubscriptionModel(
        id: _uuid.v4(),
        name: name.trim(),
        price: price,
        currency: currency,
        category: category,
        startDate: startDate,
        recurringPeriod: recurringPeriod,
        customDays: customDays,
        paymentMethodId: paymentMethodId,
        notes: notes?.trim(),
        createdAt: now,
        updatedAt: now,
      );

      await _localDataSource.add(subscription);
      AppLogger.operationSuccess('SubscriptionRepository', 'add');
      return Right(subscription);
    } catch (e, stackTrace) {
      AppLogger.operationError('SubscriptionRepository', 'add', e, stackTrace);
      return Left(
        CacheFailure(message: 'Failed to add subscription', error: e),
      );
    }
  }

  /// Update subscription
  Future<Either<Failure, SubscriptionModel>> update(
    SubscriptionModel subscription,
  ) async {
    try {
      AppLogger.operation(
        'SubscriptionRepository',
        'update',
        data: subscription.name,
      );

      // Validate input
      if (subscription.name.trim().isEmpty) {
        return Left(
          ValidationFailure(message: 'Subscription name is required'),
        );
      }

      if (subscription.price <= 0) {
        return Left(ValidationFailure(message: 'Price must be greater than 0'));
      }

      final updatedSubscription = subscription.copyWith(
        updatedAt: DateTime.now(),
      );

      await _localDataSource.update(updatedSubscription);
      AppLogger.operationSuccess('SubscriptionRepository', 'update');
      return Right(updatedSubscription);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionRepository',
        'update',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(message: 'Failed to update subscription', error: e),
      );
    }
  }

  /// Delete subscription
  Future<Either<Failure, void>> delete(String id) async {
    try {
      AppLogger.operation('SubscriptionRepository', 'delete', data: id);
      await _localDataSource.delete(id);
      AppLogger.operationSuccess('SubscriptionRepository', 'delete');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionRepository',
        'delete',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(message: 'Failed to delete subscription', error: e),
      );
    }
  }

  /// Delete all subscriptions
  Future<Either<Failure, void>> deleteAll() async {
    try {
      AppLogger.operation('SubscriptionRepository', 'deleteAll');
      await _localDataSource.deleteAll();
      AppLogger.operationSuccess('SubscriptionRepository', 'deleteAll');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionRepository',
        'deleteAll',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(message: 'Failed to delete all subscriptions', error: e),
      );
    }
  }

  /// Get total subscription count
  int getCount() {
    return _localDataSource.getCount();
  }

  /// Calculate total monthly spending
  Future<Either<Failure, double>> getTotalMonthlySpending(
    String currency,
  ) async {
    try {
      AppLogger.operation('SubscriptionRepository', 'getTotalMonthlySpending');
      final subscriptionsResult = await getAll();

      return subscriptionsResult.fold((failure) => Left(failure), (
        subscriptions,
      ) {
        double total = 0.0;

        for (final sub in subscriptions) {
          // Convert all subscriptions to monthly cost
          double monthlyCost = sub.price;

          switch (sub.recurringPeriod.toLowerCase()) {
            case 'yearly':
              monthlyCost = sub.price / 12;
              break;
            case 'quarterly':
              monthlyCost = sub.price / 3;
              break;
            case 'custom':
              if (sub.customDays != null) {
                monthlyCost = (sub.price * 30) / sub.customDays!;
              }
              break;
          }

          // Note: Currency conversion will be handled by CurrencyRepository
          // For now, we sum all subscriptions (assuming same currency)
          if (sub.currency == currency) {
            total += monthlyCost;
          }
        }

        AppLogger.operationSuccess(
          'SubscriptionRepository',
          'getTotalMonthlySpending',
        );
        return Right(total);
      });
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionRepository',
        'getTotalMonthlySpending',
        e,
        stackTrace,
      );
      return Left(
        GeneralFailure(message: 'Failed to calculate total spending', error: e),
      );
    }
  }

  /// Get subscriptions grouped by category with totals
  Future<Either<Failure, Map<String, double>>> getSpendingByCategory(
    String currency,
  ) async {
    try {
      AppLogger.operation('SubscriptionRepository', 'getSpendingByCategory');
      final subscriptionsResult = await getAll();

      return subscriptionsResult.fold((failure) => Left(failure), (
        subscriptions,
      ) {
        final Map<String, double> categorySpending = {};

        for (final sub in subscriptions) {
          double monthlyCost = sub.price;

          switch (sub.recurringPeriod.toLowerCase()) {
            case 'yearly':
              monthlyCost = sub.price / 12;
              break;
            case 'quarterly':
              monthlyCost = sub.price / 3;
              break;
            case 'custom':
              if (sub.customDays != null) {
                monthlyCost = (sub.price * 30) / sub.customDays!;
              }
              break;
          }

          if (sub.currency == currency) {
            categorySpending[sub.category] =
                (categorySpending[sub.category] ?? 0) + monthlyCost;
          }
        }

        AppLogger.operationSuccess(
          'SubscriptionRepository',
          'getSpendingByCategory',
        );
        return Right(categorySpending);
      });
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionRepository',
        'getSpendingByCategory',
        e,
        stackTrace,
      );
      return Left(
        GeneralFailure(
          message: 'Failed to calculate spending by category',
          error: e,
        ),
      );
    }
  }
}
