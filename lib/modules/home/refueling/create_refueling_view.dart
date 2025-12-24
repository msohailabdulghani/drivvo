import 'dart:io';

import 'package:drivvo/custom-widget/button/more_option_button.dart';
import 'package:drivvo/custom-widget/common/label_text.dart';
import 'package:drivvo/custom-widget/text-input-field/card_text_input_field.dart';
import 'package:drivvo/custom-widget/text-input-field/text_input_field.dart';
import 'package:drivvo/custom-widget/text-input-field/text_input_field_with_controller.dart';
import 'package:drivvo/modules/home/refueling/create_refueling_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
              // Fuel Section
              // CardHeaderText(
              //   title: "fuel_and_price".tr,
              //   isUrdu: controller.isUrdu,
              // ),
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
                  )?.then((e) => controller.fuelController.text = e);
                },
                onSaved: (value) {},
                onValidate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'fuel_required'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextInputFieldWithController(
                      isUrdu: controller.isUrdu,
                      isRequired: true,
                      isNext: true,
                      obscureText: false,
                      readOnly: false,
                      labelText: "price".tr,
                      hintText: "amount".tr,
                      controller: controller.priceController,
                      inputAction: TextInputAction.next,
                      type: TextInputType.number,
                      onChange: (value) {
                        //controller.model.value.price = double.parse(value!);
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
                  const SizedBox(width: 10),
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
                        // controller.model.value.totalCost = double.parse(value!);
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextInputFieldWithController(
                      isUrdu: controller.isUrdu,
                      isRequired: true,
                      isNext: true,
                      obscureText: false,
                      readOnly: false,
                      labelText: "liters".tr,
                      hintText: "70".tr,
                      controller: controller.litersController,
                      inputAction: TextInputAction.next,
                      type: TextInputType.number,
                      onChange: (value) {
                        //controller.model.value.liter = double.parse(value!);
                        controller.onLitersChanged(value);
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
              const SizedBox(height: 16),
              _buildSwitchRow(
                icon: Icons.local_gas_station_outlined,
                label: 'are_you_filling_this_tank'.tr,
                value: controller.isFullTank,
                onChanged: (val) => controller.isFullTank.value = val,
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
                                  "selected_title":
                                      controller.gasStationCostController.text,
                                },
                              )?.then(
                                (e) =>
                                    controller.gasStationCostController.text =
                                        e,
                              );
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
                                  "selected_title":
                                      controller.paymentMethodController.text,
                                },
                              )?.then(
                                (e) =>
                                    controller.paymentMethodController.text = e,
                              );
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
                              )?.then(
                                (e) => controller.reasonController.text = e,
                              );
                            },
                            onSaved: (value) {},
                            onValidate: (value) => null,
                          ),
                          const SizedBox(height: 16),

                          // Missed previous refueling?
                          _buildSwitchRow(
                            icon: Icons.local_gas_station_outlined,
                            label: 'missed_previous_refueling'.tr,
                            value: controller.missedPreviousRefueling,
                            onChanged: (val) =>
                                controller.missedPreviousRefueling.value = val,
                          ),
                          const SizedBox(height: 16),
                          LabelText(
                            title: "attach_file".tr,
                            isUrdu: controller.isUrdu,
                          ),
                          GestureDetector(
                            onTap: () => showImagePicker(),
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
                                      Image.file(
                                        File(controller.filePath.value),
                                      ),
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
                              controller.model.value.notes = value!;
                            },
                            onValidate: (value) => null,
                          ),
                        ],
                      )
                    : SizedBox(),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String label,
    required RxBool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: controller.isUrdu
          ? EdgeInsets.only(right: 10)
          : EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Utils.getTextStyle(
                baseSize: 14,
                isBold: false,
                color: Colors.black87,
                isUrdu: controller.isUrdu,
              ),
            ),
          ),
          Obx(
            () => Transform.scale(
              scale: 0.8,
              child: Switch(
                value: value.value,
                onChanged: onChanged,
                activeThumbColor: Utils.appColor,
                activeTrackColor: Utils.appColor.withValues(alpha: 0.2),
              ),
            ),
          ),
        ],
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
