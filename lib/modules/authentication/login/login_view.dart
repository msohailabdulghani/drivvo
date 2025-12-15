import 'package:drivvo/custom-widget/button/custom_button.dart';
import 'package:drivvo/custom-widget/text-input-field/password_input_field.dart';
import 'package:drivvo/custom-widget/text-input-field/text_input_field.dart';
import 'package:drivvo/modules/authentication/login/login_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  'login_to_continue'.tr,
                  style: Utils.getTextStyle(
                    baseSize: 28,
                    isBold: true,
                    color: Colors.black,
                    isUrdu: controller.isUrdu,
                  ),
                ),
                const SizedBox(height: 40),
                Form(
                  key: controller.formStateKey,
                  child: Column(
                    children: [
                      TextInputField(
                        isUrdu: controller.isUrdu,
                        isRequired: false,
                        isNext: true,
                        obscureText: false,
                        readOnly: false,
                        labelText: "email".tr,
                        hintText: "enter_your_email".tr,
                        inputAction: TextInputAction.next,
                        type: TextInputType.emailAddress,
                        onSaved: (value) => {
                          value != null
                              ? controller.email = value
                              : controller.email = "",
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
                          isRequired: false,
                          isNext: true,
                          obscureText: controller.showPwd.value,
                          readOnly: false,
                          isUrdu: controller.isUrdu,
                          labelText: "password".tr,
                          hintText: "enter_your_password".tr,
                          inputAction: TextInputAction.done,
                          type: TextInputType.emailAddress,
                          suffixIcon: IconButton(
                            onPressed: () => controller.showPwd.value =
                                !controller.showPwd.value,
                            icon: Icon(
                              controller.showPwd.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          onPessed: () {},
                          onSaved: (value) => {
                            value != null
                                ? controller.password = value
                                : controller.password = "",
                          },
                          onChanged: (value) {},
                          onValidate: (value) => value!.isEmpty
                              ? 'password_required'.tr
                              : value.length < 8
                              ? "password_short".tr
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        Get.toNamed(AppRoutes.FORGOT_PASSWORD_VIEW),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'forgot_password'.tr,
                        style: Utils.getTextStyle(
                          baseSize: 14,
                          isBold: false,
                          color: Utils.appColor,
                          isUrdu: controller.isUrdu,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  title: "login".tr,
                  onTap: () => controller.onTapLogin(),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.grey[300], thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or'.tr,
                        style: Utils.getTextStyle(
                          baseSize: 16,
                          isBold: false,
                          color: Colors.grey[600]!,
                          isUrdu: controller.isUrdu,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.grey[300], thickness: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () => controller.signInWithGoogle(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black87),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/google.png", height: 24),
                        const SizedBox(width: 12),
                        Text(
                          'sign_in_with_google'.tr,
                          style: Utils.getTextStyle(
                            baseSize: 14,
                            isBold: true,
                            color: Colors.black87,
                            isUrdu: controller.isUrdu,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 24.0, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "no_account".tr,
              style: Utils.getTextStyle(
                baseSize: 14,
                isBold: false,
                color: Colors.black87,
                isUrdu: controller.isUrdu,
              ),
            ),
            Text(" "),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.SIGNUP_VIEW),
              child: Text(
                'sign_up'.tr,
                style: Utils.getTextStyle(
                  baseSize: 14,
                  isBold: true,
                  isUrdu: controller.isUrdu,
                  color: Utils.appColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
