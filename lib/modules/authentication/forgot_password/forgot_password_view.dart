import 'package:drivvo/custom-widget/button/custom_button.dart';
import 'package:drivvo/custom-widget/text-input-field/text_input_field.dart';
import 'package:drivvo/modules/authentication/forgot_password/forgot_password_controller.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                "reset_password".tr,
                style: Utils.getTextStyle(
                  baseSize: 22,
                  isBold: true,
                  isUrdu: controller.isUrdu,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Obx(
                () => RichText(
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
                        style: Utils.getTextStyle(
                          baseSize: 12,
                          isBold: true,
                          isUrdu: controller.isUrdu,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: controller.registeredEmail.value.isNotEmpty
                            ? " ${'receive_reset_instructions'.tr}"
                            : "receive_reset_instructions".tr,
                        style: Utils.getTextStyle(
                          baseSize: 12,
                          isBold: true,
                          isUrdu: controller.isUrdu,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: controller.formStateKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 7),

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
                      onSaved: (v) {
                        if (v != null) {
                          controller.email = v;
                        }
                      },
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'email_required'.tr;
                        }

                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'enter_valid_email'.tr;
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 50),
                    CustomButton(
                      title: "send_otp".tr,
                      onTap: () => controller.onTapForgot(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
