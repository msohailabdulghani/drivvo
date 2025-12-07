import 'package:drivvo/model/onboarding_model.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var currentIndex = 0.obs;
  late AppService appService;

  final PageController pageController = PageController();

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  // Data from your screenshots
  final List<OnboardingModel> contentList = [
    OnboardingModel(
      title: "onboard_title_1",
      description: "onboard_desc_1",
      imagePath: "assets/images/on_boarding.png",
    ),
    OnboardingModel(
      title: "onboard_title_2",
      description: "onboard_desc_2",
      imagePath: "assets/images/on_boarding.png",
    ),
    OnboardingModel(
      title: "onboard_title_3",
      description: "onboard_desc_3",
      imagePath: "assets/images/on_boarding.png",
    ),
  ];

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();
  }

  void nextPage() {
    if (currentIndex < contentList.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      skipToLogin();
    }
  }

  void skipToLogin() {
    appService.setOnboarding(value: true);
    Get.offAllNamed(AppRoutes.LOGIN_VIEW);
  }

  void onPageChange(int index) {
    currentIndex.value = index;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
