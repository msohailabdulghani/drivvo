import 'package:drivvo/custom-widget/button/custom_button.dart';
import 'package:drivvo/custom-widget/reminder/custom_toggle_btn.dart';
import 'package:drivvo/custom-widget/text-input-field/card_text_input_field.dart';
import 'package:drivvo/custom-widget/text-input-field/form_label_text.dart';
import 'package:drivvo/custom-widget/text-input-field/text_input_field.dart';
import 'package:drivvo/modules/admin/reminder/update/update_reminder_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateReminderView extends GetView<UpdateReminderController> {
  const UpdateReminderView({super.key});

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
          'update_reminder'.tr,
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: controller.formKey,
              child: Obx(
                () => Column(
                  children: [
                    FormLabelText(
                      title: "reminder_type".tr,
                      isUrdu: controller.isUrdu,
                    ),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      initialValue: controller.selectedType.value,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      items: controller.reminderTyeList
                          .map<DropdownMenuItem<String>>((element) {
                            return DropdownMenuItem<String>(
                              value: element,
                              child: Text(
                                element.tr,
                                style: Utils.getTextStyle(
                                  baseSize: 14,
                                  isBold: false,
                                  color: Colors.black,
                                  isUrdu: controller.isUrdu,
                                ),
                              ),
                            );
                          })
                          .toList(),
                      onChanged: (String? value) =>
                          value != null ? controller.onSelectType(value) : null,
                      validator: (value) {
                        if (value == null || value == "") {
                          return "reminder_type_required".tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    controller.selectedType.value == "expense"
                        ? CardTextInputField(
                            isUrdu: controller.isUrdu,
                            isRequired: true,
                            isNext: true,
                            obscureText: false,
                            readOnly: true,
                            labelText: "expense_type".tr,
                            hintText: "".tr,
                            controller: controller.expenseController,
                            sufixIcon: Icon(Icons.keyboard_arrow_down),
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.GENERAL_VIEW,
                                arguments: {
                                  "title": Constants.EXPENSE_TYPES,
                                  "selected_title":
                                      controller.expenseController.text,
                                },
                              )?.then(
                                (e) => controller.expenseController.text = e,
                              );
                            },
                            onSaved: (value) {},
                            onValidate: (value) {
                              if (value == null ||
                                  value == "" ||
                                  value == "Select expense type") {
                                return "expense_type_required".tr;
                              } else {
                                return null;
                              }
                            },
                          )
                        : CardTextInputField(
                            isUrdu: controller.isUrdu,
                            isRequired: true,
                            isNext: true,
                            obscureText: false,
                            readOnly: true,
                            labelText: "service_type".tr,
                            hintText: "".tr,
                            controller: controller.serviceController,
                            sufixIcon: Icon(Icons.keyboard_arrow_down),
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.GENERAL_VIEW,
                                arguments: {
                                  "title": Constants.SERVICE_TYPES,
                                  "selected_title":
                                      controller.serviceController.text,
                                },
                              )?.then(
                                (e) => controller.serviceController.text = e,
                              );
                            },
                            onSaved: (value) {},
                            onValidate: (value) {
                              if (value == null ||
                                  value == "" ||
                                  value == "Select service type") {
                                return "service_type_required".tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomToggleBtn(
                            label: "just_one_time".tr,
                            index: 0,
                            selectedIndex: controller.selectedIndex.value,
                            isUrdu: controller.isUrdu,
                            onTap: () => controller.toggleBtn(0),
                          ),
                          CustomToggleBtn(
                            label: "repeat_every".tr,
                            index: 1,
                            selectedIndex: controller.selectedIndex.value,
                            isUrdu: controller.isUrdu,
                            onTap: () => controller.toggleBtn(1),
                          ),
                        ],
                      ),
                    ),
                    if (controller.selectedIndex.value == 0) ...[
                      const SizedBox(height: 20),
                      // One Time - By Odometer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: controller.oneTimeByDistance.value,
                                onChanged: (v) {
                                  controller.oneTimeByDistance.value = v!;
                                },
                                activeColor: Utils.appColor,
                              ),
                              Text(
                                "km".tr,
                                style: Utils.getTextStyle(
                                  baseSize: 14,
                                  isBold: true,
                                  isUrdu: controller.isUrdu,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: CardTextInputField(
                              isUrdu: controller.isUrdu,
                              isRequired: false,
                              isNext: true,
                              obscureText: false,
                              readOnly: !controller.oneTimeByDistance.value,
                              labelText: "".tr,
                              hintText: "e.g. 150000",
                              controller: controller.targetOdometerController,
                              onSaved: (value) {},
                              onValidate: (value) =>
                                  controller.oneTimeByDistance.value &&
                                      (value == null || value.isEmpty)
                                  ? "required".tr
                                  : null,
                            ),
                          ),
                        ],
                      ),

                      // One Time - By Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: controller.oneTimeByDate.value,
                                onChanged: (v) {
                                  controller.oneTimeByDate.value = v!;
                                },
                                activeColor: Utils.appColor,
                              ),
                              Text(
                                "date".tr,
                                style: Utils.getTextStyle(
                                  baseSize: 14,
                                  isBold: true,
                                  isUrdu: controller.isUrdu,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CardTextInputField(
                              isRequired: false,
                              isNext: true,
                              obscureText: false,
                              readOnly: true,
                              controller: controller.startDateController,
                              isUrdu: controller.isUrdu,
                              labelText: "".tr,
                              hintText: "select_date".tr,
                              sufixIcon: Icon(
                                Icons.date_range,
                                color: Utils.appColor,
                              ),
                              onSaved: (value) {},
                              onTap: () => controller.oneTimeByDate.value
                                  ? controller.selectDate(isStart: true)
                                  : null,
                              onValidate: (value) {
                                if (controller.oneTimeByDate.value &&
                                    (value == null || value.isEmpty)) {
                                  return 'date_required'.tr;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],

                    if (controller.selectedIndex.value == 1) ...[
                      const SizedBox(height: 20),
                      // Repeat - By Distance
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: controller.repeatByDistance.value,
                                onChanged: (v) {
                                  controller.repeatByDistance.value = v!;
                                  if (!v) {
                                    controller.repeatDistanceIntervalController
                                        .clear();
                                  }
                                },
                                activeColor: Utils.appColor,
                              ),
                              Text(
                                "km".tr,
                                style: Utils.getTextStyle(
                                  baseSize: 14,
                                  isBold: true,
                                  isUrdu: controller.isUrdu,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            child: CardTextInputField(
                              isUrdu: controller.isUrdu,
                              isRequired: false,
                              isNext: true,
                              obscureText: false,
                              readOnly: !controller.repeatByDistance.value,
                              labelText: "".tr,
                              hintText: "e.g. 5000",
                              controller:
                                  controller.repeatDistanceIntervalController,
                              onSaved: (value) {},
                              onValidate: (value) =>
                                  controller.repeatByDistance.value &&
                                      (value == null || value.isEmpty)
                                  ? "required".tr
                                  : null,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Repeat - By Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: controller.repeatByTime.value,
                                onChanged: (v) {
                                  controller.repeatByTime.value = v!;
                                  if (!v) {
                                    controller.repeatTimeIntervalController
                                        .clear();
                                  }
                                },
                                activeColor: Utils.appColor,
                              ),
                              Text(
                                "time".tr,
                                style: Utils.getTextStyle(
                                  baseSize: 14,
                                  isBold: true,
                                  isUrdu: controller.isUrdu,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CardTextInputField(
                                    isUrdu: controller.isUrdu,
                                    isRequired: false,
                                    isNext: true,
                                    obscureText: false,
                                    readOnly: !controller.repeatByTime.value,
                                    labelText: "".tr,
                                    hintText: "e.g. 3",
                                    controller:
                                        controller.repeatTimeIntervalController,
                                    onSaved: (value) {},
                                    onValidate: (value) =>
                                        controller.repeatByTime.value &&
                                            (value == null || value.isEmpty)
                                        ? "required".tr
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 3,
                                  child: DropdownButtonFormField<String>(
                                    initialValue: controller.repeatTimeUnit.value,
                                    items: ['day', 'month', 'year'].map((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value.tr),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      if (newValue != null) {
                                        controller.repeatTimeUnit.value =
                                            newValue;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 20),
                    TextInputField(
                      isUrdu: controller.isUrdu,
                      isRequired: false,
                      isNext: false,
                      obscureText: false,
                      readOnly: false,
                      maxLines: 4,
                      maxLength: 250,
                      labelText: "notes".tr,
                      initialValue: controller.model.value.notes,
                      hintText: "reminder_notes_hint".tr,
                      inputAction: TextInputAction.done,
                      type: TextInputType.name,
                      onTap: () {},
                      onSaved: (value) {
                        controller.model.value.notes = value ?? '';
                      },
                      onValidate: (value) => null,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      title: "save".tr,
                      onTap: () => controller.saveReminder(),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
