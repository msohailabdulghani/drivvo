import 'dart:io';

import 'package:drivvo/custom-widget/common/label_text.dart';
import 'package:drivvo/custom-widget/text-input-field/card_text_input_field.dart';
import 'package:drivvo/custom-widget/text-input-field/form_label_text.dart';
import 'package:drivvo/custom-widget/text-input-field/text_input_field.dart';
import 'package:drivvo/modules/home/expense/create_expense_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateExpenseView extends GetView<CreateExpenseController> {
  const CreateExpenseView({super.key});

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
          'expense'.tr,
          style: Utils.getTextStyle(
            baseSize: 18,
            isBold: true,
            color: Colors.white,
            isUrdu: controller.isUrdu,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => controller.saveRefueling(),
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
              // CardHeaderText(
              //   title: "date_and_time".tr,
              //   isUrdu: controller.isUrdu,
              // ),
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
                    if (value != null) {
                      if (value.isNotEmpty) {
                        final c = int.parse(value);
                        if (c <= controller.lastOdometer.value) {
                          return "odometer_greater_than_last".tr;
                        }
                      } else if (value.isEmpty) {
                        return 'odometer_required'.tr;
                      }
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
              FormLabelText(
                title: "expense_details".tr,
                isUrdu: controller.isUrdu,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "total_cost".tr,
                    style: Utils.getTextStyle(
                      baseSize: 16,
                      isBold: false,
                      color: Colors.black,
                      isUrdu: controller.isUrdu,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Obx(
                        () => Text(
                          controller.totalAmount.value.toString(),
                          style: Utils.getTextStyle(
                            baseSize: 16,
                            isBold: true,
                            color: Utils.appColor,
                            isUrdu: controller.isUrdu,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "|",
                        style: Utils.getTextStyle(
                          baseSize: 16,
                          isBold: true,
                          color: Colors.grey.shade400,
                          isUrdu: controller.isUrdu,
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          final list = controller.expenseTypesList
                              .where((e) => e.isChecked.value == true)
                              .toList();
                          Get.toNamed(
                            AppRoutes.EXPENSE_TYPE_VIEW,
                            arguments: list,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Utils.appColor),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "add".tr,
                                style: Utils.getTextStyle(
                                  baseSize: 14,
                                  isBold: false,
                                  color: Utils.appColor,
                                  isUrdu: controller.isUrdu,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.add,
                                size: 16,
                                fontWeight: FontWeight.bold,
                                color: Utils.appColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Obx(
                () => controller.expenseTypesList.isNotEmpty
                    ? Container(
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.expenseTypesList.length,
                              itemBuilder: (context, index) {
                                final model =
                                    controller.expenseTypesList[index];
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              model.name,
                                              style: Utils.getTextStyle(
                                                baseSize: 15,
                                                isBold: false,
                                                color: Colors.grey.shade600,
                                                isUrdu: controller.isUrdu,
                                              ),
                                            ),
                                            Text(
                                              model.value.toString(),
                                              style: Utils.getTextStyle(
                                                baseSize: 14,
                                                isBold: false,
                                                color: Colors.black,
                                                isUrdu: controller.isUrdu,
                                              ),
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () =>
                                              controller.removeItem(index),
                                          child: Icon(
                                            Icons.close,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    index !=
                                            controller.expenseTypesList.length -
                                                1
                                        ? Divider()
                                        : SizedBox(),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
              ),

              const SizedBox(height: 16),
              CardTextInputField(
                isUrdu: controller.isUrdu,
                isRequired: false,
                isNext: true,
                obscureText: false,
                readOnly: true,
                labelText: "place".tr,
                hintText: "".tr,
                controller: controller.placeController,
                sufixIcon: Icon(Icons.keyboard_arrow_down),
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: {
                      "title": Constants.PLACES,
                      "selected_title": controller.placeController.text,
                    },
                  )?.then((e) => controller.placeController.text = e);
                },
                onSaved: (value) {},
                onValidate: (value) => null,
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
              CardTextInputField(
                isUrdu: controller.isUrdu,
                isRequired: false,
                isNext: true,
                obscureText: false,
                readOnly: true,
                labelText: "payment_method".tr,
                hintText: "select_payment_method".tr,
                controller: controller.paymentMethodController,
                sufixIcon: Icon(Icons.keyboard_arrow_down),
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: {
                      "title": Constants.PAYMENT_METHOD,
                      "selected_title": controller.paymentMethodController.text,
                    },
                  )?.then((e) => controller.paymentMethodController.text = e);
                },
                onSaved: (value) {},
                onValidate: (value) => null,
              ),
              const SizedBox(height: 16),
              CardTextInputField(
                isUrdu: controller.isUrdu,
                isRequired: false,
                isNext: true,
                obscureText: false,
                readOnly: true,
                labelText: "reason".tr,
                hintText: "select_reason".tr,
                controller: controller.reasonController,
                sufixIcon: Icon(Icons.keyboard_arrow_down),
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: {
                      "title": Constants.REASONS,
                      "selected_title": controller.reasonController.text,
                    },
                  )?.then((e) => controller.reasonController.text = e);
                },
                onSaved: (value) {},
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
