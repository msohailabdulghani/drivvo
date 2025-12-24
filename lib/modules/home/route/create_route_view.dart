import 'dart:io';

import 'package:drivvo/custom-widget/common/label_text.dart';
import 'package:drivvo/custom-widget/text-input-field/card_text_input_field.dart';
import 'package:drivvo/custom-widget/text-input-field/text_input_field.dart';
import 'package:drivvo/modules/home/route/create_route_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateRouteView extends GetView<CreateRouteController> {
  const CreateRouteView({super.key});

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
          'route'.tr,
          style: Utils.getTextStyle(
            baseSize: 18,
            isBold: true,
            color: Colors.white,
            isUrdu: controller.isUrdu,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => controller.saveRoute(),
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
              CardTextInputField(
                isUrdu: controller.isUrdu,
                isRequired: true,
                isNext: true,
                obscureText: false,
                readOnly: true,
                labelText: "origin".tr,
                hintText: "select_origin".tr,
                controller: controller.originController,
                sufixIcon: Icon(Icons.keyboard_arrow_down),
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: {
                      "title": Constants.PLACES,
                      "selected_title": controller.originController.text,
                    },
                  )?.then((e) {
                    if (e != null) {
                      controller.originController.text = e;
                    }
                  });
                },
                onSaved: (value) {},
                onValidate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'origin_required'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CardTextInputField(
                      isRequired: true,
                      isNext: true,
                      obscureText: false,
                      readOnly: true,
                      controller: controller.startDateController,
                      isUrdu: controller.isUrdu,
                      labelText: "start_date".tr,
                      hintText: "select_date".tr,
                      sufixIcon: Icon(Icons.date_range, color: Utils.appColor),
                      onSaved: (value) {},
                      onTap: () => controller.selectDate(isStartDate: true),
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'start_date_required'.tr;
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
                      controller: controller.startTimeController,
                      isUrdu: controller.isUrdu,
                      labelText: "start_time".tr,
                      hintText: "select_time".tr,
                      sufixIcon: Icon(Icons.av_timer, color: Utils.appColor),
                      onSaved: (value) {},
                      onTap: () => controller.selectTime(isStartTime: true),
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'start_time_required'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CardTextInputField(
                      isRequired: true,
                      isNext: true,
                      obscureText: false,
                      readOnly: true,
                      controller: controller.endDateController,
                      isUrdu: controller.isUrdu,
                      labelText: "end_date".tr,
                      hintText: "select_date".tr,
                      sufixIcon: Icon(Icons.date_range, color: Utils.appColor),
                      onSaved: (value) {},
                      onTap: () => controller.selectDate(isStartDate: false),
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'end_date_required'.tr;
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
                      controller: controller.endTimeController,
                      isUrdu: controller.isUrdu,
                      labelText: "end_time".tr,
                      hintText: "select_time".tr,
                      sufixIcon: Icon(Icons.av_timer, color: Utils.appColor),
                      onSaved: (value) {},
                      onTap: () => controller.selectTime(isStartTime: false),
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'end_time_required'.tr;
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
                  labelText: "initial_odometer".tr,
                  hintText:
                      "${'last_odometer'.tr}: ${controller.lastOdometer.value} km"
                          .tr,
                  inputAction: TextInputAction.next,
                  type: TextInputType.number,
                  onTap: () {},
                  onChange: (v) {
                    if (v != null && v.isNotEmpty) {
                      // controller.initalOdometer.value = int.parse(v);
                      final parsed = int.tryParse(v);
                      if (parsed != null) {
                        controller.initalOdometer.value = parsed;
                      }
                    }
                  },
                  onSaved: (value) {
                    controller.model.value.initialOdometer = value!;
                  },
                  onValidate: (value) {
                    if (value != null) {
                      if (value.isNotEmpty) {
                        final c = int.parse(value);
                        if (c <= controller.lastOdometer.value) {
                          return "odometer_greater_than_last".tr;
                        }
                      } else if (value.isEmpty) {
                        return 'initial_odometer_required'.tr;
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
              CardTextInputField(
                isUrdu: controller.isUrdu,
                isRequired: true,
                isNext: true,
                obscureText: false,
                readOnly: true,
                labelText: "destination".tr,
                hintText: "".tr,
                controller: controller.destinationController,
                sufixIcon: Icon(Icons.keyboard_arrow_down),
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: {
                      "title": Constants.PLACES,
                      "selected_title": controller.destinationController.text,
                    },
                  )?.then((e) => controller.destinationController.text = e);
                },
                onSaved: (value) {},
                onValidate: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value == "select_destination".tr) {
                    return 'destination_required'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Obx(
                () => TextInputField(
                  isUrdu: controller.isUrdu,
                  isRequired: true,
                  isNext: true,
                  obscureText: false,
                  readOnly: false,
                  labelText: "final_odometer".tr,
                  hintText:
                      "${'last_odometer'.tr}: ${controller.lastOdometer.value} km"
                          .tr,
                  inputAction: TextInputAction.next,
                  type: TextInputType.number,
                  onTap: () {},
                  onSaved: (value) {
                    controller.model.value.finalOdometer = value!;
                  },
                  onValidate: (value) {
                    if (value != null) {
                      if (value.isNotEmpty) {
                        final c = int.parse(value);
                        if (c <= controller.initalOdometer.value) {
                          return "Final odometer should be greater than initial odometer"
                              .tr;
                        }
                      } else if (value.isEmpty) {
                        return 'final_odometer_required'.tr;
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
              Row(
                children: [
                  Expanded(
                    child: TextInputField(
                      isUrdu: controller.isUrdu,
                      isRequired: true,
                      isNext: true,
                      obscureText: false,
                      readOnly: false,
                      labelText: "value_per_km".tr,
                      hintText: "100".tr,
                      inputAction: TextInputAction.next,
                      type: TextInputType.number,
                      onTap: () {},
                      onSaved: (value) {
                        controller.model.value.valuePerKm = value!;
                      },
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'value_per_km_required'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextInputField(
                      isUrdu: controller.isUrdu,
                      isRequired: true,
                      isNext: true,
                      obscureText: false,
                      readOnly: false,
                      labelText: "total".tr,
                      hintText: "100".tr,
                      inputAction: TextInputAction.next,
                      type: TextInputType.number,
                      onTap: () {},
                      onSaved: (value) {
                        controller.model.value.total = value!;
                      },
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'total_required'.tr;
                        }
                        return null;
                      },
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
                labelText: "driver".tr,
                hintText: "Amir".tr,
                inputAction: TextInputAction.next,
                type: TextInputType.name,
                onTap: () {},
                onSaved: (value) {
                  controller.model.value.driverName = value ?? '';
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
                  controller.model.value.notes = value!;
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
