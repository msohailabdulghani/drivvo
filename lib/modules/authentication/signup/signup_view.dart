import 'package:drivvo/custom-widget/button/custom_button.dart';
import 'package:drivvo/custom-widget/text-input-field/password_input_field.dart';
import 'package:drivvo/custom-widget/text-input-field/text_input_field.dart';
import 'package:drivvo/modules/authentication/signup/signup_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IconButton(
              //   icon: const Icon(Icons.arrow_back),
              //   padding: EdgeInsets.zero,
              //   alignment: Alignment.centerLeft,
              //   onPressed: () {
              //     // Handle back navigation
              //   },
              // ),
              // const SizedBox(height: 20),
              Text(
                "signup_to_continue".tr,
                style: Utils.getTextStyle(
                  baseSize: 28,
                  isBold: true,
                  color: Colors.black,
                  isUrdu: controller.isUrdu,
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: controller.formStateKey,
                child: Column(
                  children: [
                    TextInputField(
                      isUrdu: controller.isUrdu,
                      isRequired: true,
                      isNext: true,
                      obscureText: false,
                      readOnly: false,
                      labelText: "name".tr,
                      hintText: "enter_your_name".tr,
                      inputAction: TextInputAction.next,
                      type: TextInputType.name,
                      onChange: (value) {
                        controller.nameController.text = value!;
                      },
                      onSaved: (value) {
                        controller.nameController.text = value!;
                      },
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'name_required'.tr;
                        } else if (value.length < 3) {
                          return "invalid_name".tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextInputField(
                      isUrdu: controller.isUrdu,
                      isRequired: true,
                      isNext: true,
                      obscureText: false,
                      readOnly: false,
                      labelText: "email".tr,
                      hintText: "enter_your_email".tr,
                      inputAction: TextInputAction.next,
                      type: TextInputType.emailAddress,
                      onChange: (value) {
                        controller.emailController.text = value!;
                      },
                      onSaved: (value) {
                        controller.emailController.text = value!;
                      },
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'email_required'.tr;
                        }

                        const emailPattern = r'^[\w-\.]+@([\w-]+\.)+com$';
                        final regex = RegExp(emailPattern);

                        if (!regex.hasMatch(value)) {
                          return 'enter_valid_email'.tr;
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => PasswordInputField(
                        isRequired: true,
                        isNext: true,
                        obscureText: controller.showPwd.value,
                        readOnly: false,
                        labelText: "password".tr,
                        hintText: "enter_your_password".tr,
                        inputAction: TextInputAction.next,
                        type: TextInputType.visiblePassword,
                        suffixIcon: IconButton(
                          onPressed: () => controller.showPwd.value =
                              !controller.showPwd.value,
                          icon: Icon(
                            controller.showPwd.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        onChanged: (value) {
                          controller.passwordController.text = value!;
                        },
                        onPessed: () {},
                        onSaved: (value) {
                          controller.passwordController.text = value!;
                        },
                        onValidate: (value) => value!.isEmpty
                            ? 'password_required'.tr
                            : value.length < 8
                            ? "password_short".tr
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => PasswordInputField(
                        isRequired: true,
                        isNext: true,
                        obscureText: controller.showConPwd.value,
                        readOnly: false,
                        labelText: "confirm_password".tr,
                        hintText: "enter_your_password".tr,
                        inputAction: TextInputAction.done,
                        type: TextInputType.visiblePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.showConPwd.value =
                                !controller.showConPwd.value;
                          },
                          icon: Icon(
                            controller.showConPwd.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        onPessed: () {},

                        onSaved: (value) => null,
                        onChanged: (value) {},
                        onValidate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'confirm_password_required'.tr;
                          } else if (value !=
                              controller.passwordController.text) {
                            return 'passwords_do_not_match'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomButton(
                      title: "create_account".tr,
                      onTap: () => controller.onTapSignUp(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: "agree_text".tr,
                        style: Utils.getTextStyle(
                          baseSize: 14,
                          isBold: false,
                          color: Colors.black,
                          isUrdu: controller.isUrdu,
                        ),
                      ),
                      TextSpan(text: " "),
                      TextSpan(
                        text: "terms_of_service".tr,
                        style: Utils.getTextStyle(
                          baseSize: 14,
                          isBold: true,
                          color: const Color(0xFF047772),
                          isUrdu: controller.isUrdu,
                        ),
                      ),
                      TextSpan(text: " "),
                      TextSpan(
                        text: "and".tr,
                        style: Utils.getTextStyle(
                          baseSize: 14,
                          isBold: false,
                          color: Colors.black,
                          isUrdu: controller.isUrdu,
                        ),
                      ),
                      TextSpan(text: " "),
                      TextSpan(
                        text: "privacy_policy".tr,
                        style: Utils.getTextStyle(
                          baseSize: 14,
                          isBold: true,
                          color: const Color(0xFF047772),
                          isUrdu: controller.isUrdu,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "already_have_account".tr,
                    style: Utils.getTextStyle(
                      baseSize: 14,
                      isBold: false,
                      color: Colors.black,
                      isUrdu: controller.isUrdu,
                    ),
                  ),
                  Text(" "),
                  GestureDetector(
                    onTap: () => Get.offAllNamed(AppRoutes.LOGIN_VIEW),
                    child: Text(
                      "sign_in".tr,
                      style: Utils.getTextStyle(
                        baseSize: 14,
                        isBold: true,
                        color: const Color(0xFF047772),
                        isUrdu: controller.isUrdu,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
