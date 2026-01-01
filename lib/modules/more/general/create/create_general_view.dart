import 'package:drivvo/custom-widget/button/custom_button.dart';
import 'package:drivvo/custom-widget/common/custom_app_bar.dart';
import 'package:drivvo/custom-widget/text-input-field/card_text_input_field.dart';
import 'package:drivvo/custom-widget/text-input-field/form_label_text.dart';
import 'package:drivvo/custom-widget/text-input-field/text_input_field.dart';
import 'package:drivvo/modules/more/general/create/create_general_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateGeneralView extends GetView<CreateGeneralController> {
  const CreateGeneralView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        name: controller.isUrdu
            ? "${controller.title.tr} ${"add".tr}"
            : "${"add".tr} ${controller.title.tr}",
        isUrdu: controller.isUrdu,
        bgColor: Utils.appColor,
        textColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (controller.title == Constants.EXPENSE_TYPES)
              Form(
                key: controller.formStateKey,
                child: TextInputField(
                  isUrdu: controller.isUrdu,
                  isRequired: true,
                  isNext: true,
                  obscureText: false,
                  readOnly: false,
                  labelText: "type".tr,
                  hintText: "name".tr,
                  inputAction: TextInputAction.next,
                  type: TextInputType.name,
                  onTap: () {},
                  onSaved: (value) {
                    controller.name = value!;
                  },
                  onValidate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'expense_type_required'.tr;
                    }
                    return null;
                  },
                ),
              ),

            if (controller.title == Constants.INCOME_TYPES)
              Form(
                key: controller.formStateKey,
                child: TextInputField(
                  isUrdu: controller.isUrdu,
                  isRequired: true,
                  isNext: true,
                  obscureText: false,
                  readOnly: false,
                  labelText: "type".tr,
                  hintText: "name".tr,
                  inputAction: TextInputAction.next,
                  type: TextInputType.name,
                  onTap: () {},
                  onSaved: (value) {
                    controller.name = value!;
                  },
                  onValidate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'income_type_required'.tr;
                    }
                    return null;
                  },
                ),
              ),

            if (controller.title == Constants.SERVICE_TYPES)
              Form(
                key: controller.formStateKey,
                child: TextInputField(
                  isUrdu: controller.isUrdu,
                  isRequired: true,
                  isNext: true,
                  obscureText: false,
                  readOnly: false,
                  labelText: "type".tr,
                  hintText: "name".tr,
                  inputAction: TextInputAction.next,
                  type: TextInputType.name,
                  onTap: () {},
                  onSaved: (value) {
                    controller.name = value!;
                  },
                  onValidate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'service_type_required'.tr;
                    }
                    return null;
                  },
                ),
              ),

            if (controller.title == Constants.PAYMENT_METHOD)
              Form(
                key: controller.formStateKey,
                child: TextInputField(
                  isUrdu: controller.isUrdu,
                  isRequired: true,
                  isNext: true,
                  obscureText: false,
                  readOnly: false,
                  labelText: "method_name".tr,
                  hintText: "name".tr,
                  inputAction: TextInputAction.next,
                  type: TextInputType.name,
                  onTap: () {},
                  onSaved: (value) {
                    controller.name = value!;
                  },
                  onValidate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'payment_method_required'.tr;
                    }
                    return null;
                  },
                ),
              ),

            if (controller.title == Constants.REASONS)
              Form(
                key: controller.formStateKey,
                child: TextInputField(
                  isUrdu: controller.isUrdu,
                  isRequired: true,
                  isNext: true,
                  obscureText: false,
                  readOnly: false,
                  labelText: "reason".tr,
                  hintText: "enter_your_reason".tr,
                  inputAction: TextInputAction.next,
                  type: TextInputType.name,
                  onTap: () {},
                  onSaved: (value) {
                    controller.name = value!;
                  },
                  onValidate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'reason_required'.tr;
                    }
                    return null;
                  },
                ),
              ),

            if (controller.title == Constants.FUEL)
              Form(
                key: controller.formStateKey,
                child: Column(
                  children: [
                    FormLabelText(
                      title: 'fuel_type'.tr,
                      isUrdu: controller.isUrdu,
                    ),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      initialValue: null,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      items: Utils.fuelTypeList.map<DropdownMenuItem<String>>((
                        element,
                      ) {
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
                      }).toList(),
                      onChanged: (String? value) =>
                          controller.onSelectFuelType(value!),
                      validator: (value) {
                        if (value == null || value == "") {
                          return "fuel_type_required".tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    TextInputField(
                      isUrdu: controller.isUrdu,
                      isRequired: true,
                      isNext: true,
                      obscureText: false,
                      readOnly: false,
                      labelText: "fuel".tr,
                      hintText: "cng".tr,
                      inputAction: TextInputAction.next,
                      type: TextInputType.name,
                      onTap: () {},
                      onSaved: (value) {
                        controller.name = value!;
                      },
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'fuel_name_required'.tr;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

            if (controller.title == Constants.GAS_STATIONS)
              Form(
                key: controller.formStateKey,
                child: Column(
                  children: [
                    TextInputField(
                      isUrdu: controller.isUrdu,
                      isRequired: true,
                      isNext: true,
                      obscureText: false,
                      readOnly: false,
                      labelText: "name".tr,
                      hintText: "enter_gas_station_name".tr,
                      inputAction: TextInputAction.next,
                      type: TextInputType.name,
                      onTap: () {},
                      onSaved: (value) {
                        controller.name = value!;
                      },
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'gas_station_name_required'.tr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    CardTextInputField(
                      isUrdu: controller.isUrdu,
                      isRequired: false,
                      isNext: false,
                      obscureText: false,
                      readOnly: true,
                      sufixIcon: Icon(
                        Icons.add_location_rounded,
                        color: Utils.appColor,
                      ),
                      controller: controller.locationController,
                      labelText: "location".tr,
                      hintText: "select_location".tr,
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.MAP_VIEW,
                        )?.then((e) => controller.locationController.text = e);
                      },
                      onSaved: (value) {},
                      onValidate: (value) => null,
                    ),
                  ],
                ),
              ),

            if (controller.title == Constants.PLACES)
              Form(
                key: controller.formStateKey,
                child: Column(
                  children: [
                    TextInputField(
                      isUrdu: controller.isUrdu,
                      isRequired: true,
                      isNext: true,
                      obscureText: false,
                      readOnly: false,
                      labelText: "name".tr,
                      hintText: "enter_your_place_name".tr,
                      inputAction: TextInputAction.next,
                      type: TextInputType.name,
                      onTap: () {},
                      onSaved: (value) {
                        controller.name = value!;
                      },
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'place_name_required'.tr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    CardTextInputField(
                      isUrdu: controller.isUrdu,
                      isRequired: false,
                      isNext: false,
                      obscureText: false,
                      readOnly: true,
                      sufixIcon: Icon(Icons.add_location_rounded),
                      controller: controller.locationController,
                      labelText: "location".tr,
                      hintText: "select_location".tr,
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.MAP_VIEW,
                        )?.then((e) => controller.locationController.text = e);
                      },
                      onSaved: (value) {},
                      onValidate: (value) => null,
                    ),
                  ],
                ),
              ),

            SizedBox(height: 40),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomButton(
                title: "save".tr,
                onTap: () => controller.saveData(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
