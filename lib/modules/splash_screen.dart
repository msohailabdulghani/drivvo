import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AppService appService;

  @override
  void initState() {
    super.initState();
    appService = Get.find<AppService>();
    final user = FirebaseAuth.instance.currentUser;
    Future.delayed(const Duration(milliseconds: 2000), () async {
      if (appService.onBoarding) {
        if (user != null) {
          if (appService.currentVehicleId.isNotEmpty) {
            if (appService.importData) {
              if (appService.appUser.value.userType == Constants.ADMIN) {
                Get.offAllNamed(AppRoutes.ADMIN_ROOT_VIEW);
              } else {
                Get.offAllNamed(AppRoutes.DRIVER_ROOT_VIEW);
              }
            }
          } else {
            Get.offAllNamed(AppRoutes.IMPORT_DATA_VIEW);
          }
        } else {
          Get.offAllNamed(AppRoutes.LOGIN_VIEW);
        }
      } else {
        Get.offAllNamed(AppRoutes.ON_BOARDING_VIEW);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF047772), Color.fromARGB(255, 60, 120, 118)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            const Text(
              'LOQO',
              style: TextStyle(
                fontFamily: 'D-FONT-R',
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -2.0,
              ),
            ),
            const Spacer(flex: 1),
            const Text(
              'Drivvo',
              style: TextStyle(
                fontSize: 32,
                fontFamily: 'D-FONT-R',
                color: Colors.white,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
