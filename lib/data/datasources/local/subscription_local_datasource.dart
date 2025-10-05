import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:sub/core/constants/constants.dart';
import 'package:sub/core/utils/logger.dart';
import 'package:sub/data/models/subscription_model.dart';

/// Local data source for subscriptions using Hive
@lazySingleton
class SubscriptionLocalDataSource {
  final Box<SubscriptionModel> _box;

  SubscriptionLocalDataSource()
    : _box = Hive.box<SubscriptionModel>(HiveBoxNames.subscriptions);

  /// Get all subscriptions
  Future<List<SubscriptionModel>> getAll() async {
    try {
      AppLogger.operation('SubscriptionLocalDataSource', 'getAll');
      final subscriptions = _box.values.toList();
      AppLogger.operationSuccess(
        'SubscriptionLocalDataSource',
        'getAll',
        data: 'Found ${subscriptions.length} subscriptions',
      );
      return subscriptions;
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionLocalDataSource',
        'getAll',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Get subscription by ID
  Future<SubscriptionModel?> getById(String id) async {
    try {
      AppLogger.operation('SubscriptionLocalDataSource', 'getById', data: id);
      final subscription = _box.values.firstWhere(
        (sub) => sub.id == id,
        orElse: () => throw Exception('Subscription not found'),
      );
      AppLogger.operationSuccess('SubscriptionLocalDataSource', 'getById');
      return subscription;
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionLocalDataSource',
        'getById',
        e,
        stackTrace,
      );
      return null;
    }
  }

  /// Get subscriptions by category
  Future<List<SubscriptionModel>> getByCategory(String category) async {
    try {
      AppLogger.operation(
        'SubscriptionLocalDataSource',
        'getByCategory',
        data: category,
      );
      final subscriptions = _box.values
          .where((sub) => sub.category == category)
          .toList();
      AppLogger.operationSuccess(
        'SubscriptionLocalDataSource',
        'getByCategory',
        data: 'Found ${subscriptions.length} subscriptions',
      );
      return subscriptions;
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionLocalDataSource',
        'getByCategory',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Get subscriptions by payment method
  Future<List<SubscriptionModel>> getByPaymentMethod(
    String paymentMethodId,
  ) async {
    try {
      AppLogger.operation(
        'SubscriptionLocalDataSource',
        'getByPaymentMethod',
        data: paymentMethodId,
      );
      final subscriptions = _box.values
          .where((sub) => sub.paymentMethodId == paymentMethodId)
          .toList();
      AppLogger.operationSuccess(
        'SubscriptionLocalDataSource',
        'getByPaymentMethod',
        data: 'Found ${subscriptions.length} subscriptions',
      );
      return subscriptions;
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionLocalDataSource',
        'getByPaymentMethod',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Get subscriptions by currency
  Future<List<SubscriptionModel>> getByCurrency(String currency) async {
    try {
      AppLogger.operation(
        'SubscriptionLocalDataSource',
        'getByCurrency',
        data: currency,
      );
      final subscriptions = _box.values
          .where((sub) => sub.currency == currency)
          .toList();
      AppLogger.operationSuccess(
        'SubscriptionLocalDataSource',
        'getByCurrency',
        data: 'Found ${subscriptions.length} subscriptions',
      );
      return subscriptions;
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionLocalDataSource',
        'getByCurrency',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Get upcoming renewals (within days)
  Future<List<SubscriptionModel>> getUpcomingRenewals(int days) async {
    try {
      AppLogger.operation(
        'SubscriptionLocalDataSource',
        'getUpcomingRenewals',
        data: days,
      );
      final now = DateTime.now();
      final subscriptions = _box.values.where((sub) {
        final daysUntilRenewal = sub.nextRenewal.difference(now).inDays;
        return daysUntilRenewal >= 0 && daysUntilRenewal <= days;
      }).toList();

      // Sort by next renewal date
      subscriptions.sort((a, b) => a.nextRenewal.compareTo(b.nextRenewal));

      AppLogger.operationSuccess(
        'SubscriptionLocalDataSource',
        'getUpcomingRenewals',
        data: 'Found ${subscriptions.length} subscriptions',
      );
      return subscriptions;
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionLocalDataSource',
        'getUpcomingRenewals',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Add subscription
  Future<void> add(SubscriptionModel subscription) async {
    try {
      AppLogger.operation(
        'SubscriptionLocalDataSource',
        'add',
        data: subscription.name,
      );
      await _box.put(subscription.id, subscription);
      AppLogger.operationSuccess('SubscriptionLocalDataSource', 'add');
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionLocalDataSource',
        'add',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Update subscription
  Future<void> update(SubscriptionModel subscription) async {
    try {
      AppLogger.operation(
        'SubscriptionLocalDataSource',
        'update',
        data: subscription.name,
      );
      await _box.put(subscription.id, subscription);
      AppLogger.operationSuccess('SubscriptionLocalDataSource', 'update');
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionLocalDataSource',
        'update',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Delete subscription by ID
  Future<void> delete(String id) async {
    try {
      AppLogger.operation('SubscriptionLocalDataSource', 'delete', data: id);
      await _box.delete(id);
      AppLogger.operationSuccess('SubscriptionLocalDataSource', 'delete');
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionLocalDataSource',
        'delete',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Delete all subscriptions
  Future<void> deleteAll() async {
    try {
      AppLogger.operation('SubscriptionLocalDataSource', 'deleteAll');
      await _box.clear();
      AppLogger.operationSuccess('SubscriptionLocalDataSource', 'deleteAll');
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionLocalDataSource',
        'deleteAll',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Get total count
  int getCount() {
    return _box.length;
  }

  /// Search subscriptions by name
  Future<List<SubscriptionModel>> search(String query) async {
    try {
      AppLogger.operation('SubscriptionLocalDataSource', 'search', data: query);
      final lowerQuery = query.toLowerCase();
      final subscriptions = _box.values
          .where((sub) => sub.name.toLowerCase().contains(lowerQuery))
          .toList();
      AppLogger.operationSuccess(
        'SubscriptionLocalDataSource',
        'search',
        data: 'Found ${subscriptions.length} subscriptions',
      );
      return subscriptions;
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'SubscriptionLocalDataSource',
        'search',
        e,
        stackTrace,
      );
      rethrow;
    }
  }
}
