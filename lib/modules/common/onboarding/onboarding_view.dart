import 'package:drivvo/custom-widget/button/custom_button.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 16.0,
                  top: 10,
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    controller.currentIndex.value > 0
                        ? IconButton(
                            onPressed: () {
                              if (controller.currentIndex.value > 0) {
                                controller.pageController.previousPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                                controller.onPageChange(
                                  controller.currentIndex.value - 1,
                                );
                              } else {
                                Get.back();
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          )
                        : SizedBox(),
                    controller.currentIndex.value != 2
                        ? TextButton(
                            onPressed: () => controller.skipToLogin(),
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF00796B,
                              ), // Dark Teal
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              "skip".tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    Get.locale?.languageCode ==
                                        Constants.URDU_LANGUAGE_CODE
                                    ? 16
                                    : 14,
                                fontFamily:
                                    Get.locale?.languageCode ==
                                        Constants.URDU_LANGUAGE_CODE
                                    ? "U-FONT-R"
                                    : "D-FONT-R",
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),

              const Spacer(flex: 1),

              Expanded(
                flex: 8,
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.contentList.length,
                  onPageChanged: (index) => controller.onPageChange(index),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Illustration Placeholder
                          Expanded(
                            child: Image.asset(
                              controller.contentList[index].imagePath,
                            ),
                          ),
                          Text(
                            controller.contentList[index].title.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              height: 1.2,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  Get.locale?.languageCode ==
                                      Constants.URDU_LANGUAGE_CODE
                                  ? 26
                                  : 24,
                              fontFamily:
                                  Get.locale?.languageCode ==
                                      Constants.URDU_LANGUAGE_CODE
                                  ? "U-FONT-R"
                                  : "D-FONT-R",
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            controller.contentList[index].description.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              height: 1.5,
                              fontWeight: FontWeight.normal,
                              fontSize:
                                  Get.locale?.languageCode ==
                                      Constants.URDU_LANGUAGE_CODE
                                  ? 16
                                  : 14,
                              fontFamily:
                                  Get.locale?.languageCode ==
                                      Constants.URDU_LANGUAGE_CODE
                                  ? "U-FONT-R"
                                  : "D-FONT-R",
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.contentList.length,
                  (index) => buildDot(index, context),
                ),
              ),

              const Spacer(flex: 1),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20,
                ),
                child: CustomButton(
                  title:
                      controller.currentIndex.value ==
                          controller.contentList.length - 1
                      ? "get_started".tr
                      : "next".tr,
                  onTap: () => controller.nextPage(),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: controller.currentIndex.value == index
          ? 8
          : 8, // Keeping them circular based on design
      decoration: BoxDecoration(
        // Active dot is teal (filled), inactive is outlined or lighter
        color: controller.currentIndex.value == index
            ? const Color(0xFF00796B)
            : Colors.transparent,
        border: Border.all(color: const Color(0xFF00796B), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
