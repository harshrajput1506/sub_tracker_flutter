// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:hive_flutter/hive_flutter.dart' as _i986;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/datasources/local/payment_method_local_datasource.dart'
    as _i813;
import '../../data/datasources/local/settings_local_datasource.dart' as _i246;
import '../../data/datasources/local/subscription_local_datasource.dart'
    as _i857;
import '../../data/datasources/remote/currency_remote_datasource.dart' as _i361;
import '../../data/models/payment_method_model.dart' as _i358;
import '../../data/models/subscription_model.dart' as _i515;
import '../../data/repositories/currency_repository.dart' as _i893;
import '../../data/repositories/payment_method_repository.dart' as _i1070;
import '../../data/repositories/settings_repository.dart' as _i373;
import '../../data/repositories/subscription_repository.dart' as _i167;
import '../network/api_client.dart' as _i557;
import 'injection.dart' as _i464;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i986.Box<_i515.SubscriptionModel>>(
        () => registerModule.subscriptionBox);
    gh.lazySingleton<_i986.Box<_i358.PaymentMethodModel>>(
        () => registerModule.paymentMethodBox);
    gh.lazySingleton<_i857.SubscriptionLocalDataSource>(
        () => _i857.SubscriptionLocalDataSource());
    gh.lazySingleton<_i813.PaymentMethodLocalDataSource>(
        () => _i813.PaymentMethodLocalDataSource());
    gh.lazySingleton<_i986.Box<dynamic>>(
      () => registerModule.currencyBox,
      instanceName: 'currencyBox',
    );
    gh.lazySingleton<_i986.Box<dynamic>>(
      () => registerModule.settingsBox,
      instanceName: 'settingsBox',
    );
    gh.lazySingleton<_i557.ApiClient>(
        () => _i557.ApiClient(dio: gh<_i361.Dio>()));
    gh.lazySingleton<_i246.SettingsLocalDataSource>(() =>
        _i246.SettingsLocalDataSource(
            gh<_i979.Box<dynamic>>(instanceName: 'settingsBox')));
    gh.lazySingleton<_i1070.PaymentMethodRepository>(
        () => _i1070.PaymentMethodRepository(
              gh<_i813.PaymentMethodLocalDataSource>(),
              gh<_i857.SubscriptionLocalDataSource>(),
            ));
    gh.lazySingleton<_i167.SubscriptionRepository>(() =>
        _i167.SubscriptionRepository(gh<_i857.SubscriptionLocalDataSource>()));
    gh.lazySingleton<_i361.CurrencyRemoteDataSource>(
        () => _i361.CurrencyRemoteDataSource(
              gh<_i557.ApiClient>(),
              gh<_i979.Box<dynamic>>(instanceName: 'currencyBox'),
            ));
    gh.lazySingleton<_i373.SettingsRepository>(
        () => _i373.SettingsRepository(gh<_i246.SettingsLocalDataSource>()));
    gh.lazySingleton<_i893.CurrencyRepository>(
        () => _i893.CurrencyRepository(gh<_i361.CurrencyRemoteDataSource>()));
    return this;
  }
}

class _$RegisterModule extends _i464.RegisterModule {}
