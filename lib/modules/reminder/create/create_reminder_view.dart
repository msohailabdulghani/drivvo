import 'package:drivvo/custom-widget/text-input-field/card_text_input_field.dart';
import 'package:drivvo/custom-widget/text-input-field/form_label_text.dart';
import 'package:drivvo/custom-widget/text-input-field/text_input_field.dart';
import 'package:drivvo/modules/reminder/create/create_reminder_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateReminderView extends GetView<CreateReminderController> {
  const CreateReminderView({super.key});

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
          'add_new_reminder'.tr,
          style: Utils.getTextStyle(
            baseSize: 18,
            isBold: true,
            color: Colors.white,
            isUrdu: controller.isUrdu,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => controller.saveReminder(),
            child: Text(
              'save'.tr,
              style: Utils.getTextStyle(
                baseSize: 14,
                isBold: false,
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
                      initialValue: "expense",
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
                              if (value == null || value == "") {
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
                              if (value == null || value == "") {
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
                        horizontal: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildToggleButton(
                            label: "just_one_time".tr,
                            index: 0,
                          ),
                          _buildToggleButton(
                            label: "repeat_every".tr,
                            index: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    controller.selectedIndex.value == 0
                        ? Column(
                            children: [
                              CardTextInputField(
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
                              const SizedBox(height: 20),
                              TextInputField(
                                isUrdu: controller.isUrdu,
                                isRequired: true,
                                isNext: true,
                                obscureText: false,
                                readOnly: false,
                                labelText: "odometer".tr,
                                hintText: "100".tr,
                                inputAction: TextInputAction.next,
                                type: TextInputType.number,
                                onTap: () {},
                                onSaved: (value) {
                                  controller.model.value.odometer =
                                      double.tryParse(value ?? '') ?? 0.0;
                                },
                                onValidate: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'odometer_required'.tr;
                                  }
                                  return null;
                                },
                              ),
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
                                hintText: "reminder_notes_hint".tr,
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
                        : Column(children: []),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton({required String label, required int index}) {
    final bool isSelected = controller.selectedIndex.value == index;

    return GestureDetector(
      onTap: () => controller.toggleBtn(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? Utils.appColor : Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: Utils.getTextStyle(
            baseSize: 14,
            isBold: false,
            color: isSelected ? Colors.white : Colors.grey,
            isUrdu: controller.isUrdu,
          ),
        ),
      ),
    );
  }
}
