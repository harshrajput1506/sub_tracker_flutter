import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sub/core/constants/constants.dart';
import 'package:sub/core/di/injection.dart';
import 'package:sub/core/router/app_router.dart';
import 'package:sub/core/theme/theme.dart';
import 'package:sub/core/theme/util.dart';
import 'package:sub/core/utils/logger.dart';
import 'package:sub/data/models/subscription_model.dart';
import 'package:sub/data/models/payment_method_model.dart';
import 'package:sub/data/models/settings_model.dart';
import 'package:sub/data/models/currency_rates_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  AppLogger.info('🚀 Initializing Sub Tracker App');

  try {
    // Initialize Hive
    await Hive.initFlutter();
    AppLogger.info('✅ Hive initialized');

    // Register Hive adapters
    Hive.registerAdapter(SubscriptionModelAdapter());
    Hive.registerAdapter(PaymentMethodModelAdapter());
    Hive.registerAdapter(SettingsModelAdapter());
    Hive.registerAdapter(CurrencyRatesModelAdapter());
    AppLogger.info('✅ Hive adapters registered');

    // Open Hive boxes
    await Hive.openBox<SubscriptionModel>(HiveBoxNames.subscriptions);
    await Hive.openBox<PaymentMethodModel>(HiveBoxNames.paymentMethods);
    await Hive.openBox(HiveBoxNames.settings);
    await Hive.openBox(HiveBoxNames.currencyRates);
    AppLogger.info('✅ Hive boxes opened');

    // Initialize dependency injection
    await configureDependencies();
    AppLogger.info('✅ Dependency injection configured');

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    runApp(const MyApp());
  } catch (e, stackTrace) {
    AppLogger.error('❌ App initialization failed', e, stackTrace);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create text theme with Google Fonts
    final textTheme = createTextTheme(context, "Raleway", "Raleway");
    final theme = AppTheme(textTheme);

    return MaterialApp.router(
      title: 'Sub Tracker',
      debugShowCheckedModeBanner: false,
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
