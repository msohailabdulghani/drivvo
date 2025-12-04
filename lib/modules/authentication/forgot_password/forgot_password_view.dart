import 'package:drivvo/modules/authentication/forgot_password/forgot_password_controller.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: Flex(
        direction: Axis.vertical,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Center(
              child: Text(
                "safe_x".tr,
                style: TextStyle(
                  color: Color(0XffFB5C7C),
                  fontWeight: FontWeight.bold,
                  // decoration: TextDecoration.underline,
                  // decorationColor: Color(0XffFB5C7C),
                  fontSize:
                      Get.locale?.languageCode ==
                          Constants.DEFAULT_LANGUAGE_CODE
                      ? 35
                      : 40,
                  fontFamily:
                      Get.locale?.languageCode ==
                          Constants.DEFAULT_LANGUAGE_CODE
                      ? "D-FONT-R"
                      : "U-FONT-R",
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 4,
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Text(
                      "reset_password".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            Get.locale?.languageCode ==
                                Constants.DEFAULT_LANGUAGE_CODE
                            ? 22
                            : 24,
                        fontFamily:
                            Get.locale?.languageCode ==
                                Constants.DEFAULT_LANGUAGE_CODE
                            ? "D-FONT-R"
                            : "U-FONT-R",
                      ),
                    ),
                    Obx(
                      () => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'enter_registered_email'.tr,
                            style: const TextStyle(
                              fontFamily: "D-FONT-r",
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontSize: 12,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: controller.registeredEmail.value,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,

                                  fontSize:
                                      Get.locale?.languageCode ==
                                          Constants.DEFAULT_LANGUAGE_CODE
                                      ? 12
                                      : 14,
                                  fontFamily:
                                      Get.locale?.languageCode ==
                                          Constants.DEFAULT_LANGUAGE_CODE
                                      ? "D-FONT-R"
                                      : "U-FONT-R",
                                ),
                              ),
                              TextSpan(
                                text:
                                    controller.registeredEmail.value.isNotEmpty
                                    ? " ${'receive_reset_instructions'.tr}"
                                    : "receive_reset_instructions".tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize:
                                      Get.locale?.languageCode ==
                                          Constants.DEFAULT_LANGUAGE_CODE
                                      ? 12
                                      : 14,
                                  fontFamily:
                                      Get.locale?.languageCode ==
                                          Constants.DEFAULT_LANGUAGE_CODE
                                      ? "D-FONT-R"
                                      : "U-FONT-R",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Form(
                      key: controller.formStateKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 7),
                          // TextInputField(
                          //   isRequired: true,
                          //   isNext: true,
                          //   obscureText: false,
                          //   readOnly: false,
                          //   labelText: "email".tr,
                          //   inputAction: TextInputAction.next,
                          //   type: TextInputType.emailAddress,
                          //   prefixIcon: const Icon(Icons.email_outlined),
                          //   onSaved: (v) {
                          //     if (v != null) {
                          //       controller.email = v;
                          //     }
                          //   },
                          //   onValidate: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'email_required'.tr;
                          //     }

                          //     if (!RegExp(
                          //       r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          //     ).hasMatch(value)) {
                          //       return 'enter_valid_email'.tr;
                          //     }

                          //     return null;
                          //   },
                          // ),

                          const SizedBox(height: 50),
                          GestureDetector(
                            onTap: () => controller.onTapForgot(),
                            child: Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                color: Color(0XffFB5C7C),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Obx(
                                  () => Center(
                                    child: controller.loading.value
                                        ? CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 1,
                                          )
                                        : Text(
                                            "send_otp".tr,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
