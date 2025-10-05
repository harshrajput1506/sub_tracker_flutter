import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:sub/core/constants/constants.dart';
import 'package:sub/core/utils/logger.dart';
import 'package:sub/data/models/payment_method_model.dart';

/// Local data source for payment methods using Hive
@lazySingleton
class PaymentMethodLocalDataSource {
  final Box<PaymentMethodModel> _box;

  PaymentMethodLocalDataSource()
    : _box = Hive.box<PaymentMethodModel>(HiveBoxNames.paymentMethods);

  /// Get all payment methods
  Future<List<PaymentMethodModel>> getAll() async {
    try {
      AppLogger.operation('PaymentMethodLocalDataSource', 'getAll');
      final paymentMethods = _box.values.toList();
      AppLogger.operationSuccess(
        'PaymentMethodLocalDataSource',
        'getAll',
        data: 'Found ${paymentMethods.length} payment methods',
      );
      return paymentMethods;
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'PaymentMethodLocalDataSource',
        'getAll',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Get payment method by ID
  Future<PaymentMethodModel?> getById(String id) async {
    try {
      AppLogger.operation('PaymentMethodLocalDataSource', 'getById', data: id);
      final paymentMethod = _box.values.firstWhere(
        (pm) => pm.id == id,
        orElse: () => throw Exception('Payment method not found'),
      );
      AppLogger.operationSuccess('PaymentMethodLocalDataSource', 'getById');
      return paymentMethod;
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'PaymentMethodLocalDataSource',
        'getById',
        e,
        stackTrace,
      );
      return null;
    }
  }

  /// Get payment methods by type
  Future<List<PaymentMethodModel>> getByType(String type) async {
    try {
      AppLogger.operation(
        'PaymentMethodLocalDataSource',
        'getByType',
        data: type,
      );
      final paymentMethods = _box.values
          .where((pm) => pm.type == type)
          .toList();
      AppLogger.operationSuccess(
        'PaymentMethodLocalDataSource',
        'getByType',
        data: 'Found ${paymentMethods.length} payment methods',
      );
      return paymentMethods;
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'PaymentMethodLocalDataSource',
        'getByType',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Add payment method
  Future<void> add(PaymentMethodModel paymentMethod) async {
    try {
      AppLogger.operation(
        'PaymentMethodLocalDataSource',
        'add',
        data: paymentMethod.name,
      );
      await _box.put(paymentMethod.id, paymentMethod);
      AppLogger.operationSuccess('PaymentMethodLocalDataSource', 'add');
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'PaymentMethodLocalDataSource',
        'add',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Update payment method
  Future<void> update(PaymentMethodModel paymentMethod) async {
    try {
      AppLogger.operation(
        'PaymentMethodLocalDataSource',
        'update',
        data: paymentMethod.name,
      );
      await _box.put(paymentMethod.id, paymentMethod);
      AppLogger.operationSuccess('PaymentMethodLocalDataSource', 'update');
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'PaymentMethodLocalDataSource',
        'update',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Delete payment method by ID
  Future<void> delete(String id) async {
    try {
      AppLogger.operation('PaymentMethodLocalDataSource', 'delete', data: id);
      await _box.delete(id);
      AppLogger.operationSuccess('PaymentMethodLocalDataSource', 'delete');
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'PaymentMethodLocalDataSource',
        'delete',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Delete all payment methods
  Future<void> deleteAll() async {
    try {
      AppLogger.operation('PaymentMethodLocalDataSource', 'deleteAll');
      await _box.clear();
      AppLogger.operationSuccess('PaymentMethodLocalDataSource', 'deleteAll');
    } catch (e, stackTrace) {
      AppLogger.operationError(
        'PaymentMethodLocalDataSource',
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

  /// Check if payment method exists
  bool exists(String id) {
    return _box.containsKey(id);
  }
}
