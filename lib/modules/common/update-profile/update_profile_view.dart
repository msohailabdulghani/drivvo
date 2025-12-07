import 'dart:io';
import 'package:drivvo/custom-widget/button/custom_button.dart';
import 'package:drivvo/custom-widget/common/custom_app_bar.dart';
import 'package:drivvo/custom-widget/common/profile_image.dart';
import 'package:drivvo/custom-widget/text-input-field/text_input_field.dart';
import 'package:drivvo/modules/common/update-profile/update_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  const UpdateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        name: "update_profile".tr,
        isUrdu: controller.isUrdu,
        centerTitle: true,
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
                                          foregroundColor: const Color(
                                            0xFF047772,
                                          ),
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
                        TextInputField(
                          isUrdu: controller.isUrdu,
                          isRequired: false,
                          isNext: true,
                          obscureText: false,
                          readOnly: false,
                          initialValue:
                              controller.appService.appUser.value.name,
                          labelText: "name".tr,
                          hintText: "enter_your_name".tr,
                          inputAction: TextInputAction.next,
                          type: TextInputType.name,
                          onSaved: (value) {
                            value != null
                                ? controller.name = value
                                : controller.name = "";
                          },
                          onValidate: (value) {},
                        ),
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 40),
                        CustomButton(
                          title: "update".tr,
                          onTap: () => controller.saveData(),
                        ),
                        const SizedBox(height: 20),
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
