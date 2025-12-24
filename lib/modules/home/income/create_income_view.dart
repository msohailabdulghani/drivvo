import 'dart:io';

import 'package:drivvo/custom-widget/common/label_text.dart';
import 'package:drivvo/custom-widget/text-input-field/card_text_input_field.dart';
import 'package:drivvo/custom-widget/text-input-field/text_input_field.dart';
import 'package:drivvo/modules/home/income/create_income_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateIncomeView extends GetView<CreateIncomeController> {
  const CreateIncomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Utils.appColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'income'.tr,
          style: Utils.getTextStyle(
            baseSize: 18,
            isBold: true,
            color: Colors.white,
            isUrdu: controller.isUrdu,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => controller.saveIncome(),
            icon: Text(
              "save".tr,
              style: Utils.getTextStyle(
                baseSize: 14,
                isBold: true,
                color: Colors.white,
                isUrdu: controller.isUrdu,
              ),
            ),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CardTextInputField(
                      isRequired: true,
                      isNext: true,
                      obscureText: false,
                      readOnly: true,
                      controller: controller.dateController,
                      isUrdu: controller.isUrdu,
                      labelText: "date".tr,
                      hintText: "select_date".tr,
                      sufixIcon: Icon(Icons.date_range, color: Utils.appColor),
                      onSaved: (value) {},
                      onTap: () => controller.selectDate(),
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'date_required'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CardTextInputField(
                      isRequired: true,
                      isNext: true,
                      obscureText: false,
                      readOnly: true,
                      controller: controller.timeController,
                      isUrdu: controller.isUrdu,
                      labelText: "time".tr,
                      hintText: "select_time".tr,
                      sufixIcon: Icon(Icons.av_timer, color: Utils.appColor),
                      onSaved: (value) {},
                      onTap: () => controller.selectTime(),
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'time_required'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(
                () => TextInputField(
                  isUrdu: controller.isUrdu,
                  isRequired: true,
                  isNext: true,
                  obscureText: false,
                  readOnly: false,
                  labelText: "odometer".tr,
                  hintText:
                      "${'last_odometer'.tr}: ${controller.lastOdometer.value} km"
                          .tr,
                  inputAction: TextInputAction.next,
                  type: TextInputType.number,
                  onTap: () {},
                  onSaved: (value) {
                    controller.model.value.odometer = value ?? '';
                  },
                  onValidate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'odometer_required'.tr;
                    }
                    final parsedValue = int.tryParse(value);
                    if (parsedValue == null) {
                      return 'invalid_odometer'.tr;
                    }
                    if (parsedValue <= controller.lastOdometer.value) {
                      return "odometer_greater_than_last".tr;
                    }

                    return null;
                  },
                ),
              ),
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: Padding(
              //     padding: const EdgeInsets.only(top: 8),
              //     child: Obx(
              //       () => Text(
              //         '${'last_odometer'.tr}: ${controller.lastOdometer.value} km',
              //         style: Utils.getTextStyle(
              //           baseSize: 12,
              //           isBold: false,
              //           color: Colors.grey[600]!,
              //           isUrdu: controller.isUrdu,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 16),
              CardTextInputField(
                isUrdu: controller.isUrdu,
                isRequired: true,
                isNext: true,
                obscureText: false,
                readOnly: true,
                labelText: "income_type".tr,
                hintText: "".tr,
                controller: controller.incomeTypeController,
                sufixIcon: Icon(Icons.keyboard_arrow_down),
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: {
                      "title": Constants.INCOME_TYPES,
                      "selected_title": controller.incomeTypeController.text,
                    },
                  )?.then((e) {
                    if (e != null) controller.incomeTypeController.text = e;
                  });
                },
                onSaved: (value) {},
                onValidate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'income_type_required'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextInputField(
                isUrdu: controller.isUrdu,
                isRequired: true,
                isNext: true,
                obscureText: false,
                readOnly: false,
                labelText: "value".tr,
                hintText: "100".tr,
                inputAction: TextInputAction.next,
                type: TextInputType.number,
                onTap: () {},
                onSaved: (value) {
                  controller.model.value.value = value ?? '';
                },
                onValidate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'income_required'.tr;
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextInputField(
                isUrdu: controller.isUrdu,
                isRequired: false,
                isNext: true,
                obscureText: false,
                readOnly: false,
                labelText: "driver".tr,
                hintText: "Amir".tr,
                inputAction: TextInputAction.next,
                type: TextInputType.name,
                onTap: () {},
                onSaved: (value) {
                  controller.model.value.driverName = value!;
                },
                onValidate: (value) => null,
              ),
              const SizedBox(height: 16),
              LabelText(title: "attach_file".tr, isUrdu: controller.isUrdu),
              GestureDetector(
                onTap: () => showImagePicker(),
                child: Container(
                  width: double.maxFinite,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Utils.appColor.withValues(alpha: 0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: Utils.appColor,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Obx(
                    () => Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.add_a_photo, color: Utils.appColor),
                        if (controller.filePath.value.isNotEmpty)
                          Image.file(File(controller.filePath.value)),
                        if (controller.filePath.value.isNotEmpty)
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () => {controller.filePath.value = ""},
                              icon: const Icon(Icons.cancel, color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextInputField(
                isUrdu: controller.isUrdu,
                isRequired: false,
                isNext: false,
                obscureText: false,
                readOnly: false,
                maxLines: 4,
                maxLength: 250,
                labelText: "notes".tr,
                hintText: "enter_your_notes".tr,
                inputAction: TextInputAction.done,
                type: TextInputType.name,
                onTap: () {},
                onSaved: (value) {
                  controller.model.value.notes = value ?? '';
                },
                onValidate: (value) => null,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void showImagePicker() async {
    final ImagePicker imgPicker = ImagePicker();

    Get.defaultDialog(
      title: "choose_option".tr,
      titleStyle: Utils.getTextStyle(
        baseSize: 16,
        isBold: true,
        color: Colors.black,
        isUrdu: controller.isUrdu,
      ),
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
                  imageQuality: 100,
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
                    style: Utils.getTextStyle(
                      baseSize: 14,
                      isBold: false,
                      color: Colors.black,
                      isUrdu: controller.isUrdu,
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
                  imageQuality: 100,
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
                    style: Utils.getTextStyle(
                      baseSize: 14,
                      isBold: false,
                      color: Colors.black,
                      isUrdu: controller.isUrdu,
                    ),
                  ),
                  const Icon(
                    Icons.photo_library,
                    color: Colors.black,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
