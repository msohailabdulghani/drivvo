import 'dart:io';

import 'package:drivvo/custom-widget/button/custom_button.dart';
import 'package:drivvo/custom-widget/common/icon_with_text.dart';
import 'package:drivvo/custom-widget/common/profile_image.dart';
import 'package:drivvo/custom-widget/text-input-field/card_text_input_field.dart';
import 'package:drivvo/custom-widget/text-input-field/text_input_field.dart';
import 'package:drivvo/modules/common/update-profile/update_profile_controller.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  const UpdateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Utils.appColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'update_profile'.tr,
          style: Utils.getTextStyle(
            baseSize: 18,
            isBold: true,
            color: Colors.white,
            isUrdu: controller.isUrdu,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  decoration: const BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Form(
                    key: controller.formStateKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Obx(
                                () => SizedBox(
                                  width: 130,
                                  height: 130,
                                  child: controller.filePath.isNotEmpty
                                      ? CircleAvatar(
                                          foregroundColor: Utils.appColor,
                                          backgroundImage: FileImage(
                                            File(controller.filePath.value),
                                          ),
                                          radius: 48.0,
                                        )
                                      : ProfileImage(
                                          photoUrl: controller
                                              .appService
                                              .appUser
                                              .value
                                              .photoUrl,
                                          width: 120,
                                          height: 120,
                                          radius: 100,
                                          placeholder:
                                              "assets/images/placeholder.png",
                                        ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => {showResponseDialog()},
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF00796B),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.edit,
                                      size:
                                          MediaQuery.of(context).size.width *
                                          0.047,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        IconWithText(
                          isUrdu: controller.isUrdu,
                          imagePath: "assets/images/info.png",
                          textColor: Utils.appColor,
                          title: "personal_information".tr,
                        ),
                        const SizedBox(height: 20),
                        TextInputField(
                          isUrdu: controller.isUrdu,
                          isRequired: false,
                          isNext: true,
                          obscureText: false,
                          readOnly: false,
                          initialValue:
                              controller.appService.appUser.value.firstName,
                          labelText: "first_name".tr,
                          hintText: "enter_your_first_name".tr,
                          inputAction: TextInputAction.next,
                          type: TextInputType.name,
                          onSaved: (value) {
                            value != null
                                ? controller.model.firstName = value
                                : controller.model.firstName = "";
                          },
                          onValidate: (value) {},
                        ),
                        const SizedBox(height: 16),
                        TextInputField(
                          isUrdu: controller.isUrdu,
                          isRequired: false,
                          isNext: true,
                          obscureText: false,
                          readOnly: false,
                          initialValue:
                              controller.appService.appUser.value.lastName,
                          labelText: "last_name".tr,
                          hintText: "enter_your_last_name".tr,
                          inputAction: TextInputAction.next,
                          type: TextInputType.name,
                          onSaved: (value) {
                            value != null
                                ? controller.model.lastName = value
                                : controller.model.lastName = "";
                          },
                          onValidate: (value) {},
                        ),
                        const SizedBox(height: 16),
                        TextInputField(
                          isUrdu: controller.isUrdu,
                          isRequired: false,
                          isNext: true,
                          obscureText: false,
                          readOnly: true,
                          initialValue:
                              controller.appService.appUser.value.email,
                          labelText: "email".tr,
                          hintText: "enter_your_email".tr,
                          inputAction: TextInputAction.next,
                          type: TextInputType.emailAddress,
                          onSaved: (value) => {},
                          onValidate: (value) {},
                        ),
                        const SizedBox(height: 16),
                        TextInputField(
                          isUrdu: controller.isUrdu,
                          isRequired: false,
                          isNext: true,
                          obscureText: false,
                          readOnly: false,
                          labelText: "phone_number".tr,
                          hintText: "enter_your_phone_number".tr,
                          inputAction: TextInputAction.next,
                          initialValue:
                              controller.appService.appUser.value.phone,
                          type: TextInputType.number,
                          onSaved: (value) {
                            value != null
                                ? controller.model.phone = value
                                : controller.model.phone = "";
                          },
                          onValidate: (value) {},
                        ),
                        const SizedBox(height: 30),
                        IconWithText(
                          isUrdu: controller.isUrdu,
                          imagePath: "assets/images/additional.png",
                          textColor: Utils.appColor,
                          title: "driver_license_info".tr,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: CardTextInputField(
                                isRequired: false,
                                isNext: true,
                                obscureText: false,
                                readOnly: true,
                                controller: controller.issueDateController,
                                isUrdu: controller.isUrdu,
                                labelText: "issue_date".tr,
                                hintText: "select_date".tr,
                                sufixIcon: Icon(
                                  Icons.date_range,
                                  color: Utils.appColor,
                                ),
                                onSaved: (value) {},
                                onTap: () =>
                                    controller.selectDate(isIssueDate: true),
                                onValidate: (value) => null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CardTextInputField(
                                isRequired: false,
                                isNext: true,
                                obscureText: false,
                                readOnly: true,
                                controller: controller.expiryDateController,
                                isUrdu: controller.isUrdu,
                                labelText: "expiry_date".tr,
                                hintText: "select_date".tr,
                                sufixIcon: Icon(
                                  Icons.date_range,
                                  color: Utils.appColor,
                                ),
                                onSaved: (value) {},
                                onTap: () =>
                                    controller.selectDate(isIssueDate: false),
                                onValidate: (value) => null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextInputField(
                          isUrdu: controller.isUrdu,
                          isRequired: false,
                          isNext: true,
                          obscureText: false,
                          readOnly: false,
                          initialValue:
                              controller.appService.appUser.value.licenseNumber,
                          labelText: "license_number".tr,
                          hintText: "enter_your_license_number".tr,
                          inputAction: TextInputAction.next,
                          type: TextInputType.name,
                          onSaved: (value) {
                            value != null
                                ? controller.model.licenseNumber = value
                                : controller.model.licenseNumber = "";
                          },
                          onValidate: (value) {},
                        ),
                        const SizedBox(height: 16),
                        TextInputField(
                          isUrdu: controller.isUrdu,
                          isRequired: false,
                          isNext: false,
                          obscureText: false,
                          readOnly: false,
                          labelText: "category".tr,
                          hintText: "license_category".tr,
                          initialValue: controller
                              .appService
                              .appUser
                              .value
                              .licenseCategory,
                          inputAction: TextInputAction.done,
                          type: TextInputType.name,
                          onSaved: (value) {
                            value != null
                                ? controller.model.licenseCategory = value
                                : controller.model.licenseCategory = "";
                          },
                          onValidate: (value) {},
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          title: "update".tr,
                          onTap: () => controller.saveData(),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showResponseDialog() async {
    final ImagePicker imgPicker = ImagePicker();

    Get.defaultDialog(
      title: "choose_option".tr,
      backgroundColor: Colors.white,
      content: Padding(
        padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                Get.back();
                final pickedFile = await imgPicker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 85,
                  maxWidth: 400,
                  maxHeight: 400,
                );
                if (pickedFile != null) {
                  controller.onPickedFile(pickedFile);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "take_photo".tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xff000000),
                      fontSize: 14,
                    ),
                  ),
                  const Icon(Icons.camera_alt, color: Colors.black, size: 18),
                ],
              ),
            ),
            const SizedBox(height: 5),
            const Divider(thickness: 0.5, color: Color(0x20000000)),
            const SizedBox(height: 5),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                Get.back();
                final pickedFile = await imgPicker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 85,
                  maxWidth: 400,
                  maxHeight: 400,
                );
                if (pickedFile != null) {
                  controller.onPickedFile(pickedFile);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "gallery".tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xff000000),
                      fontSize: 14,
                    ),
                  ),
                  const Icon(Icons.camera_alt, color: Colors.black, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
