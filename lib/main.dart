import 'package:drivvo/firebase_options.dart';
import 'package:drivvo/routes/app_pages.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/services/translation_service.dart';
import 'package:drivvo/utils/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final translations = TranslationService();
  await translations.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  await Get.putAsync<AppService>(() => AppService().init());

  runApp(MyApp(translations));
}

class MyApp extends StatelessWidget {
  final TranslationService translations;

  const MyApp(this.translations, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Drivvo',
      translations: translations,
      locale: Get.find<AppService>().locale,
      fallbackLocale: Get.find<AppService>().locale,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.SPLASH_SCREEN,
      getPages: AppPages.routes,
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: ThemeMode.light,
    );
  }
}
