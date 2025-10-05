import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sub/core/constants/constants.dart';
import 'package:sub/core/router/app_router.dart';
import 'package:sub/core/theme/theme.dart';
import 'package:sub/core/theme/util.dart';
import 'package:sub/core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  AppLogger.info('🚀 Initializing Sub Tracker App');

  try {
    // Initialize Hive
    await Hive.initFlutter();
    AppLogger.info('✅ Hive initialized');

    // Open Hive boxes
    await Hive.openBox(HiveBoxNames.settings);
    await Hive.openBox(HiveBoxNames.subscriptions);
    await Hive.openBox(HiveBoxNames.paymentMethods);
    await Hive.openBox(HiveBoxNames.currencyRates);
    AppLogger.info('✅ Hive boxes opened');

    // Initialize dependency injection
    // await configureDependencies();
    // AppLogger.info('✅ Dependency injection configured');

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
