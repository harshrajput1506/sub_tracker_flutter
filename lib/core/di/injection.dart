import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:sub/core/constants/constants.dart';
import 'package:sub/core/di/injection.config.dart';
import 'package:sub/data/models/payment_method_model.dart';
import 'package:sub/data/models/subscription_model.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => getIt.init();

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  Box<SubscriptionModel> get subscriptionBox =>
      Hive.box<SubscriptionModel>(HiveBoxNames.subscriptions);

  @lazySingleton
  Box<PaymentMethodModel> get paymentMethodBox =>
      Hive.box<PaymentMethodModel>(HiveBoxNames.paymentMethods);

  @Named('settingsBox')
  @lazySingleton
  Box get settingsBox => Hive.box(HiveBoxNames.settings);

  @Named('currencyBox')
  @lazySingleton
  Box get currencyBox => Hive.box(HiveBoxNames.currencyRates);
}
