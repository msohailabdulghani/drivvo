import 'dart:io';

import 'package:drivvo/custom-widget/button/custom_button.dart';
import 'package:drivvo/custom-widget/button/more_option_button.dart';
import 'package:drivvo/custom-widget/common/confilcting_crad.dart';
import 'package:drivvo/custom-widget/common/label_text.dart';
import 'package:drivvo/custom-widget/text-input-field/card_text_input_field.dart';
import 'package:drivvo/custom-widget/text-input-field/text_input_field.dart';
import 'package:drivvo/custom-widget/text-input-field/text_input_field_with_controller.dart';
import 'package:drivvo/model/app_user.dart';
import 'package:drivvo/modules/admin/home/refueling/create/create_refueling_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateRefuelingView extends GetView<CreateRefuelingController> {
  const CreateRefuelingView({super.key});

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
          'refueling'.tr,
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
                          sufixIcon: Icon(
                            Icons.date_range,
                            color: Utils.appColor,
                          ),
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
                          sufixIcon: Icon(
                            Icons.av_timer,
                            color: Utils.appColor,
                          ),
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
                          "${'last_odometer'.tr}: ${controller.lastOdometer.value} km",
                      inputAction: TextInputAction.next,
                      type: TextInputType.number,
                      onTap: () {},
                      onSaved: (value) {
                        if (value != null) {
                          controller.model.value.odometer = num.parse(
                            value,
                          ).toInt();
                        }
                      },
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'odometer_required'.tr;
                        }
                        final c = num.tryParse(value);
                        if (c == null) {
                          return 'invalid_odometer_value'.tr;
                        }
                        if (c <= controller.lastOdometer.value) {
                          return "odometer_greater_than_last".tr;
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
                    labelText: "fuel".tr,
                    hintText: "select_fuel".tr,
                    controller: controller.fuelController,
                    sufixIcon: Icon(Icons.keyboard_arrow_down),
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.GENERAL_VIEW,
                        arguments: {
                          "title": Constants.FUEL,
                          "selected_title": controller.fuelController.text,
                        },
                      )?.then((e) {
                        if (e != null) {
                          controller.fuelController.text = e;
                          controller.fuelValue.value = e;
                        }
                      });
                    },
                    onSaved: (value) {},
                    onValidate: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value == "Select Fuel") {
                        return 'fuel_required'.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => TextInputFieldWithController(
                      isUrdu: controller.isUrdu,
                      isRequired: true,
                      isNext: true,
                      obscureText: false,
                      readOnly: false,
                      labelText: controller.fuelValue.value == "CNG"
                          ? "m³"
                          : controller.fuelValue.value == "Electric"
                          ? "KWH"
                          : "liters".tr,
                      hintText: controller.fuelValue.value == "CNG"
                          ? "m³"
                          : controller.fuelValue.value == "Electric"
                          ? "KWH"
                          : "liters".tr,
                      controller: controller.litersController,
                      inputAction: TextInputAction.next,
                      type: TextInputType.number,
                      onChange: (value) {
                        controller.onLitersChanged(value);
                      },
                      onTap: () {},
                      onSaved: (value) {},
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'liters_required'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => TextInputFieldWithController(
                            isUrdu: controller.isUrdu,
                            isRequired: true,
                            isNext: true,
                            obscureText: false,
                            readOnly: false,
                            labelText: controller.fuelValue.value == "CNG"
                                ? "price_per_m³"
                                : controller.fuelValue.value == "Electric"
                                ? "price_per_kwh"
                                : "price_per_liter".tr,
                            hintText: "amount".tr,
                            controller: controller.priceController,
                            inputAction: TextInputAction.next,
                            type: TextInputType.number,
                            onChange: (value) {
                              controller.onPriceChanged(value);
                            },
                            onTap: () {},
                            onSaved: (value) {},
                            onValidate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'amount_required'.tr;
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextInputFieldWithController(
                          isUrdu: controller.isUrdu,
                          isRequired: true,
                          isNext: true,
                          obscureText: false,
                          readOnly: false,
                          labelText: "total_cost".tr,
                          hintText: "cost".tr,
                          controller: controller.totalCostController,
                          inputAction: TextInputAction.next,
                          type: TextInputType.number,
                          onChange: (value) {
                            controller.onTotalCostChanged(value);
                          },
                          onTap: () {},
                          onSaved: (value) {},
                          onValidate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'cost_required'.tr;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),
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
                                    controller.model.value.driverName = name;
                                  }
                                }
                              }
                            })
                          : Get.toNamed(AppRoutes.PLAN_VIEW);
                    },
                    onSaved: (value) {},
                    onValidate: (value) => null,
                  ),
                  Obx(
                    () => !controller.moreOptionsExpanded.value
                        ? Column(
                            children: [
                              const SizedBox(height: 30),
                              MoreOptionButton(
                                isUrdu: controller.isUrdu,
                                moreOptionsExpanded:
                                    controller.moreOptionsExpanded.value,
                                onTap: () => controller.toggleMoreOptions(),
                              ),
                            ],
                          )
                        : SizedBox(),
                  ),
                  Obx(
                    () => controller.moreOptionsExpanded.value
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              CardTextInputField(
                                isUrdu: controller.isUrdu,
                                isRequired: false,
                                isNext: true,
                                obscureText: false,
                                readOnly: true,
                                labelText: "gas_station".tr,
                                hintText: "select_gas_station".tr,
                                controller: controller.gasStationCostController,
                                sufixIcon: Icon(Icons.keyboard_arrow_down),
                                onTap: () {
                                  Get.toNamed(
                                    AppRoutes.GENERAL_VIEW,
                                    arguments: {
                                      "title": Constants.GAS_STATIONS,
                                      "selected_title": controller
                                          .gasStationCostController
                                          .text,
                                    },
                                  )?.then((e) {
                                    if (e != null) {
                                      controller.gasStationCostController.text =
                                          e;
                                    }
                                  });
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
                                labelText: "payment_method".tr,
                                hintText: "select_payment_method".tr,
                                controller: controller.paymentMethodController,
                                sufixIcon: Icon(Icons.keyboard_arrow_down),
                                onTap: () {
                                  Get.toNamed(
                                    AppRoutes.GENERAL_VIEW,
                                    arguments: {
                                      "title": Constants.PAYMENT_METHOD,
                                      "selected_title": controller
                                          .paymentMethodController
                                          .text,
                                    },
                                  )?.then((e) {
                                    if (e != null) {
                                      controller.paymentMethodController.text =
                                          e;
                                    }
                                  });
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
                                      "selected_title":
                                          controller.reasonController.text,
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
                              LabelText(
                                title: "attach_file".tr,
                                isUrdu: controller.isUrdu,
                              ),
                              GestureDetector(
                                onTap: () =>
                                    controller
                                        .appService
                                        .appUser
                                        .value
                                        .isSubscribed
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
                                    color: Utils.appColor.withValues(
                                      alpha: 0.1,
                                    ),
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
                                        if (controller
                                            .filePath
                                            .value
                                            .isNotEmpty)
                                          Image.file(
                                            File(controller.filePath.value),
                                          ),
                                        if (controller
                                            .filePath
                                            .value
                                            .isNotEmpty)
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              onPressed: () {
                                                controller.filePath.value = "";
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
                                  controller.model.value.notes = value ?? '';
                                },
                                onValidate: (value) => null,
                              ),
                            ],
                          )
                        : SizedBox(),
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
                onTap: () => controller.saveRefueling(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
