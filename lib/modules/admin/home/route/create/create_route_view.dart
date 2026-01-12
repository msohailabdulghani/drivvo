import 'dart:io';

import 'package:drivvo/custom-widget/button/custom_button.dart';
import 'package:drivvo/custom-widget/common/confilcting_crad.dart';
import 'package:drivvo/custom-widget/common/label_text.dart';
import 'package:drivvo/custom-widget/text-input-field/card_text_input_field.dart';
import 'package:drivvo/custom-widget/text-input-field/text_input_field.dart';
import 'package:drivvo/model/app_user.dart';
import 'package:drivvo/modules/admin/home/route/create/create_route_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),

      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => controller.showConflictingCard.value
                        ? ConflictingCard(
                            isUrdu: controller.isUrdu,
                            lastRecordModel: controller.lastRecord,
                            onTap: () => controller.showConflictingCard.value =
                                !controller.showConflictingCard.value,
                          )
                        : SizedBox(),
                  ),
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
                          sufixIcon: Icon(
                            Icons.date_range,
                            color: Utils.appColor,
                          ),
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
                          sufixIcon: Icon(
                            Icons.av_timer,
                            color: Utils.appColor,
                          ),
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
                          sufixIcon: Icon(
                            Icons.date_range,
                            color: Utils.appColor,
                          ),
                          onSaved: (value) {},
                          onTap: () =>
                              controller.selectDate(isStartDate: false),
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
                          sufixIcon: Icon(
                            Icons.av_timer,
                            color: Utils.appColor,
                          ),
                          onSaved: (value) {},
                          onTap: () =>
                              controller.selectTime(isStartTime: false),
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
                          "${'last_odometer'.tr}: ${controller.lastOdometer.value} km",
                      inputAction: TextInputAction.next,
                      type: TextInputType.number,
                      controller: controller.initialOdometerController,
                      onTap: () {},
                      onChange: (v) => controller.calculateValuePerKm(),
                      onSaved: (value) {},
                      onValidate: (value) {
                        if (value != null) {
                          if (value.isNotEmpty) {
                            final c = int.tryParse(value);
                            if (c != null) {
                              if (c <= controller.lastOdometer.value) {
                                return "odometer_greater_than_last".tr;
                              }
                            }
                          } else if (value.isEmpty) {
                            return 'initial_odometer_required'.tr;
                          }
                        }
                        return null;
                      },
                    ),
                  ),
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
                          "selected_title":
                              controller.destinationController.text,
                        },
                      )?.then((e) {
                        if (e != null) {
                          controller.destinationController.text = e;
                        }
                      });
                    },
                    onSaved: (value) {},
                    onValidate: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value == "Select destination") {
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
                          "${'last_odometer'.tr}: ${controller.lastOdometer.value} km",
                      inputAction: TextInputAction.next,
                      type: TextInputType.number,
                      controller: controller.finalOdometerController,
                      onTap: () {},
                      onChange: (v) => controller.calculateValuePerKm(),
                      onSaved: (value) {},
                      onValidate: (value) {
                        if (value != null) {
                          if (value.isNotEmpty) {
                            // final c = int.parse(value);
                            // if (c <= controller.initalOdometer.value) {
                            //   return "Final odometer should be greater than initial odometer"
                            //       .tr;
                            // }
                            final c = int.tryParse(value);
                            if (c == null) {
                              return 'invalid_number'.tr;
                            }
                            if (c <= controller.initalOdometer.value) {
                              return 'final_odometer_greater_than_initial'.tr;
                            }
                          } else if (value.isEmpty) {
                            return 'final_odometer_required'.tr;
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextInputField(
                          isUrdu: controller.isUrdu,
                          isRequired: true,
                          isNext: true,
                          obscureText: false,
                          readOnly: true,
                          labelText: "value_per_km".tr,
                          hintText: "100".tr,
                          inputAction: TextInputAction.next,
                          type: TextInputType.number,
                          controller: controller.valuePerKmController,
                          onTap: () {},
                          onChange: (v) => controller.calculateValuePerKm(),
                          onSaved: (value) {},
                          onValidate: (value) {
                            // if (value == null || value.isEmpty) {
                            //   return 'value_per_km_required'.tr;
                            // }
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
                          controller: controller.totalController,
                          onTap: () {},
                          onChange: (v) => controller.calculateValuePerKm(),
                          onSaved: (value) {},
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
                  if (controller.appService.appUser.value.userType ==
                      Constants.ADMIN) ...[
                    const SizedBox(height: 16),
                    CardTextInputField(
                      isUrdu: controller.isUrdu,
                      isRequired: false,
                      isNext: true,
                      obscureText: false,
                      readOnly: true,
                      labelText: "driver".tr,
                      hintText: "enter_driver_name".tr,
                      controller: controller.driverController,
                      sufixIcon: Icon(Icons.keyboard_arrow_down),
                      onTap: () {
                        controller.appService.appUser.value.isSubscribed
                            ? Get.toNamed(
                                AppRoutes.USER_VIEW,
                                arguments: controller.driverController.text,
                              )?.then((e) {
                                if (e != null) {
                                  if (e is AppUser) {
                                    final firstName = e.firstName;
                                    final lastName = e.lastName;
                                    final name = "$firstName $lastName".trim();
                                    if (name.isNotEmpty) {
                                      controller.driverController.text = name;
                                      controller.model.value.driver = e;
                                    }
                                  }
                                }
                              })
                            : Get.toNamed(AppRoutes.PLAN_VIEW);
                      },
                      onSaved: (value) {},
                      onValidate: (value) => null,
                    ),
                  ],
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
                      )?.then((e) {
                        if (e != null) {
                          controller.reasonController.text = e;
                        }
                      });
                    },
                    onSaved: (value) {},
                    onValidate: (value) => null,
                  ),
                  const SizedBox(height: 16),
                  LabelText(title: "attach_file".tr, isUrdu: controller.isUrdu),
                  GestureDetector(
                    onTap: () =>
                        controller.appService.appUser.value.isSubscribed
                        ? Utils.showImagePicker(
                            isUrdu: controller.isUrdu,
                            pickFile: (path) =>
                                controller.filePath.value = path,
                          )
                        : Get.toNamed(AppRoutes.PLAN_VIEW),
                    child: Container(
                      width: double.maxFinite,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Utils.appColor.withValues(alpha: 0.1),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        border: Border.all(
                          color: Utils.appColor,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Obx(
                        () => Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.add_a_photo,
                              color: Utils.appColor,
                            ),
                            if (controller.filePath.value.isNotEmpty)
                              Image.file(File(controller.filePath.value)),
                            if (controller.filePath.value.isNotEmpty)
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () => {
                                    controller.filePath.value = "",
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
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
                      if (value != null) {
                        controller.model.value.notes = value;
                      }
                    },
                    onValidate: (value) => null,
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0, left: 16, right: 16),
              child: CustomButton(
                title: "save".tr,
                onTap: () => controller.saveRoute(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
