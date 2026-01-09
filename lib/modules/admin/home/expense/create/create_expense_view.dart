import 'dart:io';

import 'package:drivvo/custom-widget/button/custom_button.dart';
import 'package:drivvo/custom-widget/common/confilcting_crad.dart';
import 'package:drivvo/custom-widget/common/label_text.dart';
import 'package:drivvo/custom-widget/text-input-field/card_text_input_field.dart';
import 'package:drivvo/custom-widget/text-input-field/form_label_text.dart';
import 'package:drivvo/custom-widget/text-input-field/text_input_field.dart';
import 'package:drivvo/model/app_user.dart';
import 'package:drivvo/modules/admin/home/expense/create/create_expense_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                    () => controller.showConfilctingCard.value
                        ? ConflictingCard(
                            isUrdu: controller.isUrdu,
                            lastRecordModel: controller.lastRecord,
                            onTap: () => controller.showConfilctingCard.value =
                                !controller.showConfilctingCard.value,
                          )
                        : SizedBox(),
                  ),

                  CardTextInputField(
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
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: CardTextInputField(
                  //         isRequired: true,
                  //         isNext: true,
                  //         obscureText: false,
                  //         readOnly: true,
                  //         controller: controller.dateController,
                  //         isUrdu: controller.isUrdu,
                  //         labelText: "date".tr,
                  //         hintText: "select_date".tr,
                  //         sufixIcon: Icon(
                  //           Icons.date_range,
                  //           color: Utils.appColor,
                  //         ),
                  //         onSaved: (value) {},
                  //         onTap: () => controller.selectDate(),
                  //         onValidate: (value) {
                  //           if (value == null || value.isEmpty) {
                  //             return 'date_required'.tr;
                  //           }
                  //           return null;
                  //         },
                  //       ),
                  //     ),
                  //     const SizedBox(width: 16),
                  //     Expanded(
                  //       child: CardTextInputField(
                  //         isRequired: true,
                  //         isNext: true,
                  //         obscureText: false,
                  //         readOnly: true,
                  //         controller: controller.timeController,
                  //         isUrdu: controller.isUrdu,
                  //         labelText: "time".tr,
                  //         hintText: "select_time".tr,
                  //         sufixIcon: Icon(
                  //           Icons.av_timer,
                  //           color: Utils.appColor,
                  //         ),
                  //         onSaved: (value) {},
                  //         onTap: () => controller.selectTime(),
                  //         onValidate: (value) {
                  //           if (value == null || value.isEmpty) {
                  //             return 'time_required'.tr;
                  //           }
                  //           return null;
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 16),
                  Obx(
                    () => TextInputField(
                      isUrdu: controller.isUrdu,
                      isRequired: false,
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
                        if (value != null && value.isNotEmpty) {
                          final odometer = int.tryParse(
                            value.replaceAll(',', ''),
                          );
                          if (odometer != null) {
                            controller.model.value.odometer = odometer;
                          }
                        }
                      },
                      onValidate: (value) {
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
                                arguments: {"list": list, "isFromCreate": true},
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Utils.appColor),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
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
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
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
                                                controller
                                                        .expenseTypesList
                                                        .length -
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
                      )?.then((e) {
                        if (e != null) {
                          controller.placeController.text = e;
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
                      )?.then((e) {
                        if (e != null) {
                          controller.paymentMethodController.text = e;
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
                                  onPressed: () =>
                                      controller.filePath.value = "",
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
                onTap: () => controller.saveExpense(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
