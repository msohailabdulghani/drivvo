import 'package:drivvo/binding/initial_app_binding.dart';
import 'package:drivvo/firebase_options.dart';
import 'package:drivvo/routes/app_pages.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/services/notification_service.dart';
import 'package:drivvo/services/translation_service.dart';
import 'package:drivvo/utils/app_theme.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final translations = TranslationService();
  await translations.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  await FirebaseAppCheck.instance.activate(
    // ignore: deprecated_member_use
    androidProvider: kDebugMode
        ? AndroidProvider.debug
        : AndroidProvider.playIntegrity,
    // ignore: deprecated_member_use
    appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.deviceCheck,
  );

  await Get.putAsync<AppService>(() => AppService().init());
  await NotificationService().init();

  runApp(MyApp(translations));
}

class MyApp extends StatelessWidget {
  final TranslationService translations;

  const MyApp(this.translations, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CarLog',
      translations: translations,
      initialBinding: InitialAppBinding(),
      locale: Get.find<AppService>().locale,
      fallbackLocale: Get.find<AppService>().locale,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.SPLASH_SCREEN,
      getPages: AppPages.routes,
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: Get.find<AppService>().getThemeMode,
    );
  }
}
