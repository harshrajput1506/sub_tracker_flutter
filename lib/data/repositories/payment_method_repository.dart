import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sub/core/error/failures.dart';
import 'package:sub/core/utils/logger.dart';
import 'package:sub/data/datasources/local/payment_method_local_datasource.dart';
import 'package:sub/data/datasources/local/subscription_local_datasource.dart';
import 'package:sub/data/models/payment_method_model.dart';
import 'package:uuid/uuid.dart';

/// Repository for payment method operations
@lazySingleton
class PaymentMethodRepository {
  final PaymentMethodLocalDataSource _localDataSource;
  final SubscriptionLocalDataSource _subscriptionDataSource;
  final Uuid _uuid = const Uuid();

  PaymentMethodRepository(this._localDataSource, this._subscriptionDataSource);

  /// Get all payment methods
  Future<Either<Failure, List<PaymentMethodModel>>> getAll() async {
    try {
      AppLogger.operation('PaymentMethodRepository', 'getAll');
      final paymentMethods = await _localDataSource.getAll();
      AppLogger.operationSuccess('PaymentMethodRepository', 'getAll');
      return Right(paymentMethods);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'PaymentMethodRepository',
        'getAll',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(message: 'Failed to load payment methods', error: e),
      );
    }
  }

  /// Get payment method by ID
  Future<Either<Failure, PaymentMethodModel>> getById(String id) async {
    try {
      AppLogger.operation('PaymentMethodRepository', 'getById', data: id);
      final paymentMethod = await _localDataSource.getById(id);

      if (paymentMethod == null) {
        return Left(
          CacheFailure(message: 'Payment method not found', code: 'NOT_FOUND'),
        );
      }

      AppLogger.operationSuccess('PaymentMethodRepository', 'getById');
      return Right(paymentMethod);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'PaymentMethodRepository',
        'getById',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(message: 'Failed to load payment method', error: e),
      );
    }
  }

  /// Get payment methods by type
  Future<Either<Failure, List<PaymentMethodModel>>> getByType(
    String type,
  ) async {
    try {
      AppLogger.operation('PaymentMethodRepository', 'getByType', data: type);
      final paymentMethods = await _localDataSource.getByType(type);
      AppLogger.operationSuccess('PaymentMethodRepository', 'getByType');
      return Right(paymentMethods);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'PaymentMethodRepository',
        'getByType',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(
          message: 'Failed to load payment methods by type',
          error: e,
        ),
      );
    }
  }

  /// Add payment method
  Future<Either<Failure, PaymentMethodModel>> add({
    required String name,
    required String type,
    String? lastFourDigits,
    String? notes,
  }) async {
    try {
      AppLogger.operation('PaymentMethodRepository', 'add', data: name);

      // Validate input
      if (name.trim().isEmpty) {
        return Left(
          ValidationFailure(message: 'Payment method name is required'),
        );
      }

      if (type.trim().isEmpty) {
        return Left(
          ValidationFailure(message: 'Payment method type is required'),
        );
      }

      final now = DateTime.now();
      final paymentMethod = PaymentMethodModel(
        id: _uuid.v4(),
        name: name.trim(),
        type: type.trim(),
        lastFourDigits: lastFourDigits?.trim(),
        notes: notes?.trim(),
        createdAt: now,
        updatedAt: now,
      );

      await _localDataSource.add(paymentMethod);
      AppLogger.operationSuccess('PaymentMethodRepository', 'add');
      return Right(paymentMethod);
    } catch (e, stackTrace) {
      AppLogger.operationError('PaymentMethodRepository', 'add', e, stackTrace);
      return Left(
        CacheFailure(message: 'Failed to add payment method', error: e),
      );
    }
  }

  /// Update payment method
  Future<Either<Failure, PaymentMethodModel>> update(
    PaymentMethodModel paymentMethod,
  ) async {
    try {
      AppLogger.operation(
        'PaymentMethodRepository',
        'update',
        data: paymentMethod.name,
      );

      // Validate input
      if (paymentMethod.name.trim().isEmpty) {
        return Left(
          ValidationFailure(message: 'Payment method name is required'),
        );
      }

      if (paymentMethod.type.trim().isEmpty) {
        return Left(
          ValidationFailure(message: 'Payment method type is required'),
        );
      }

      final updatedPaymentMethod = paymentMethod.copyWith(
        updatedAt: DateTime.now(),
      );

      await _localDataSource.update(updatedPaymentMethod);
      AppLogger.operationSuccess('PaymentMethodRepository', 'update');
      return Right(updatedPaymentMethod);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'PaymentMethodRepository',
        'update',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(message: 'Failed to update payment method', error: e),
      );
    }
  }

  /// Delete payment method
  Future<Either<Failure, void>> delete(String id) async {
    try {
      AppLogger.operation('PaymentMethodRepository', 'delete', data: id);

      // Check if payment method is linked to any subscriptions
      final linkedSubscriptions = await _subscriptionDataSource
          .getByPaymentMethod(id);
      if (linkedSubscriptions.isNotEmpty) {
        return Left(
          ValidationFailure(
            message:
                'Cannot delete payment method. It is linked to ${linkedSubscriptions.length} subscription(s)',
          ),
        );
      }

      await _localDataSource.delete(id);
      AppLogger.operationSuccess('PaymentMethodRepository', 'delete');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'PaymentMethodRepository',
        'delete',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(message: 'Failed to delete payment method', error: e),
      );
    }
  }

  /// Delete all payment methods
  Future<Either<Failure, void>> deleteAll() async {
    try {
      AppLogger.operation('PaymentMethodRepository', 'deleteAll');
      await _localDataSource.deleteAll();
      AppLogger.operationSuccess('PaymentMethodRepository', 'deleteAll');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'PaymentMethodRepository',
        'deleteAll',
        e,
        stackTrace,
      );
      return Left(
        CacheFailure(message: 'Failed to delete all payment methods', error: e),
      );
    }
  }

  /// Get total payment method count
  int getCount() {
    return _localDataSource.getCount();
  }

  /// Check if payment method exists
  bool exists(String id) {
    return _localDataSource.exists(id);
  }

  /// Get spending by payment method
  Future<Either<Failure, Map<String, double>>> getSpendingByPaymentMethod(
    String currency,
  ) async {
    try {
      AppLogger.operation(
        'PaymentMethodRepository',
        'getSpendingByPaymentMethod',
      );

      final paymentMethodsResult = await getAll();
      final allSubscriptions = await _subscriptionDataSource.getAll();

      return paymentMethodsResult.fold((failure) => Left(failure), (
        paymentMethods,
      ) {
        final Map<String, double> spending = {};

        for (final pm in paymentMethods) {
          double total = 0.0;

          // Get subscriptions for this payment method
          final subscriptions = allSubscriptions.where(
            (sub) => sub.paymentMethodId == pm.id,
          );

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
              total += monthlyCost;
            }
          }

          spending[pm.name] = total;
        }

        AppLogger.operationSuccess(
          'PaymentMethodRepository',
          'getSpendingByPaymentMethod',
        );
        return Right(spending);
      });
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'PaymentMethodRepository',
        'getSpendingByPaymentMethod',
        e,
        stackTrace,
      );
      return Left(
        GeneralFailure(
          message: 'Failed to calculate spending by payment method',
          error: e,
        ),
      );
    }
  }
}
