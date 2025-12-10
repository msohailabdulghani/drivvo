import 'package:drivvo/custom-widget/common/card_header_text.dart';
import 'package:drivvo/custom-widget/common/custom_app_bar.dart';
import 'package:drivvo/custom-widget/text-input-field/card_text_input_field.dart';
import 'package:drivvo/custom-widget/text-input-field/form_label_text.dart';
import 'package:drivvo/custom-widget/text-input-field/search_text_input_field.dart';
import 'package:drivvo/custom-widget/text-input-field/text_input_field.dart';
import 'package:drivvo/modules/more/vehicles/create/create_vehicles_controller.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateVehiclesView extends GetView<CreateVehiclesController> {
  const CreateVehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        name: "add_new_vehicle".tr,
        isUrdu: controller.isUrdu,
        bgColor: Utils.appColor,
        textColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => controller.saveData(),
            icon: Text(
              "save".tr,
              style: Utils.getTextStyle(
                baseSize: 16,
                isBold: true,
                color: Colors.white,
                isUrdu: controller.isUrdu,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formStateKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Basic Information Card ---
              CardHeaderText(
                title: "basic_information".tr,
                isUrdu: controller.isUrdu,
              ),
              _buildCard(
                child: Column(
                  children: [
                    FormLabelText(
                      title: "vehicle_type".tr,
                      isUrdu: controller.isUrdu,
                    ),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      initialValue: null,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      items: controller.vehicleTypesList
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
                          controller.onSelectVehicleType(value!),
                      validator: (value) {
                        if (value == null || value == "") {
                          return "vehicle_type_required".tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextInputField(
                      isUrdu: controller.isUrdu,
                      isRequired: true,
                      isNext: true,
                      obscureText: false,
                      readOnly: false,
                      labelText: "vehicle_name".tr,
                      hintText: "name".tr,
                      inputAction: TextInputAction.next,
                      type: TextInputType.name,
                      onChange: (value) {},
                      onTap: () {},
                      onSaved: (value) {
                        controller.model.name = value!;
                      },
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'vehicle_name_required'.tr;
                        } else if (value.length < 3) {
                          return "invalid_name".tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    CardTextInputField(
                      isRequired: true,
                      isNext: true,
                      obscureText: false,
                      readOnly: true,
                      controller: controller.manufacturerController,
                      isUrdu: controller.isUrdu,
                      labelText: "manufacturer".tr,
                      hintText: "manufacturer_hint".tr,
                      sufixIcon: Icon(Icons.info_outline),
                      onSaved: (value) {},
                      onTap: () {
                        openBottomSheet(context);
                      },
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'manufacturer_required'.tr;
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
                      labelText: "model".tr,
                      hintText: "model_hint".tr,
                      inputAction: TextInputAction.next,
                      type: TextInputType.name,
                      onTap: () {},
                      onSaved: (value) {
                        controller.model.model = value!;
                      },
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'model_required'.tr;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // -- - Registration Card ---
              CardHeaderText(
                title: "registration".tr,
                isUrdu: controller.isUrdu,
              ),
              _buildCard(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextInputField(
                        isUrdu: controller.isUrdu,
                        isRequired: false,
                        isNext: true,
                        obscureText: false,
                        readOnly: false,
                        labelText: "license_plate_optional".tr,
                        hintText: "license_plate_hint".tr,
                        inputAction: TextInputAction.next,
                        type: TextInputType.name,
                        onTap: () {},
                        onSaved: (value) {
                          controller.model.licensePlate = value!;
                        },
                        onValidate: (value) => null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "year".tr,
                            style: Utils.getTextStyle(
                              baseSize: 14,
                              isBold: false,
                              color: Colors.black,
                              isUrdu: controller.isUrdu,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Obx(
                              () => DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  isExpanded: true,
                                  value: controller.selectedYear.value,
                                  items: Utils.years.map((int year) {
                                    return DropdownMenuItem<int>(
                                      value: year,
                                      child: Text(year.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    controller.model.year = value!;
                                    controller.selectedYear.value = value;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // --- Fuel Configuration Card ---
              CardHeaderText(
                title: "fuel_configuration".tr,
                isUrdu: controller.isUrdu,
              ),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormLabelText(
                      title: "tank_configuration".tr,
                      isUrdu: controller.isUrdu,
                    ),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      initialValue: null,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      items: controller.tankList.map<DropdownMenuItem<String>>((
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
                          controller.onSelectTank(value!),
                      validator: (value) {
                        if (value == null || value == "") {
                          return "tank_configuration_required".tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    FormLabelText(
                      title: "fuel_type".tr,
                      isUrdu: controller.isUrdu,
                    ),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      initialValue: null,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      items: controller.fuelTypesList
                          .map<DropdownMenuItem<String>>((element) {
                            return DropdownMenuItem<String>(
                              value: element,
                              child: Text(element),
                            );
                          })
                          .toList(),
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
                    const SizedBox(height: 16),
                    TextInputField(
                      isUrdu: controller.isUrdu,
                      isRequired: true,
                      isNext: true,
                      obscureText: false,
                      readOnly: false,
                      labelText: "fuel_capacity".tr,
                      hintText: "fuel_capacity_hint".tr,
                      inputAction: TextInputAction.next,
                      type: TextInputType.name,
                      onTap: () {},
                      onSaved: (value) {
                        controller.model.fuelCapacity = value!;
                      },
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'fuel_capacity_required'.tr;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // --- Preferences Card ---
              CardHeaderText(
                title: "preferences".tr,
                isUrdu: controller.isUrdu,
              ),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "distance_unit".tr,
                      style: Utils.getTextStyle(
                        baseSize: 14,
                        isBold: false,
                        color: Colors.black,
                        isUrdu: controller.isUrdu,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ChoiceChip(
                            label: Text(
                              "kilometers".tr,
                              style: Utils.getTextStyle(
                                baseSize: 14,
                                isBold: false,
                                color:
                                    controller.selectedChipName.value ==
                                        "Kilometers"
                                    ? Colors.white
                                    : Colors.black,
                                isUrdu: controller.isUrdu,
                              ),
                            ),
                            visualDensity: VisualDensity.compact,
                            selected:
                                controller.selectedChipName.value ==
                                "Kilometers",
                            onSelected: (bool selected) {
                              if (selected) {
                                controller.model.distanceUnit = "Kilometers";
                                controller.selectedChipName.value =
                                    "Kilometers";
                              }
                            },
                          ),
                          SizedBox(width: 20),
                          ChoiceChip(
                            label: Text(
                              "miles".tr,
                              style: Utils.getTextStyle(
                                baseSize: 14,
                                isBold: false,
                                color:
                                    controller.selectedChipName.value == "Miles"
                                    ? Colors.white
                                    : Colors.black,
                                isUrdu: controller.isUrdu,
                              ),
                            ),
                            visualDensity: VisualDensity.compact,
                            selected:
                                controller.selectedChipName.value == "Miles",
                            onSelected: (bool selected) {
                              if (selected) {
                                controller.model.distanceUnit = "Miles";
                                controller.selectedChipName.value = "Miles";
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // --- Additional Details Card ---
              CardHeaderText(
                title: "additional_details".tr,
                isUrdu: controller.isUrdu,
              ),
              _buildCard(
                child: Column(
                  children: [
                    TextInputField(
                      isUrdu: controller.isUrdu,
                      isRequired: false,
                      isNext: true,
                      obscureText: false,
                      readOnly: false,
                      labelText: "chassis_number_optional".tr,
                      hintText: "chassis_number_hint".tr,
                      inputAction: TextInputAction.next,
                      type: TextInputType.name,
                      onTap: () {},
                      onSaved: (value) {
                        controller.model.chassisNumber = value!;
                      },
                      onValidate: (value) => null,
                    ),
                    const SizedBox(height: 16),
                    TextInputField(
                      isUrdu: controller.isUrdu,
                      isRequired: false,
                      isNext: true,
                      obscureText: false,
                      readOnly: false,
                      labelText: "vin_number".tr,
                      hintText: "vin_hint".tr,
                      inputAction: TextInputAction.next,
                      type: TextInputType.name,
                      onTap: () {},
                      onSaved: (value) {
                        controller.model.identificationNumber = value!;
                      },
                      onValidate: (value) => null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // --- Active Vehicle Switch ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "active_vehicle".tr,
                      style: Utils.getTextStyle(
                        baseSize: 16,
                        isBold: false,
                        color: Colors.black,
                        isUrdu: controller.isUrdu,
                      ),
                    ),
                    Obx(
                      () => Switch(
                        value: controller.isActiveVehicle.value,
                        activeThumbColor: Colors.teal,
                        onChanged: (val) {
                          controller.isActiveVehicle.value = val;
                          controller.model.activeVehicle = val;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // --- Note ---
              CardHeaderText(title: "", isUrdu: controller.isUrdu),
              _buildCard(
                child: TextInputField(
                  isUrdu: controller.isUrdu,
                  isRequired: false,
                  isNext: true,
                  obscureText: false,
                  readOnly: false,
                  maxLength: 250,
                  maxLines: 4,
                  labelText: "note_optional".tr,
                  hintText: "note_hint".tr,
                  inputAction: TextInputAction.next,
                  type: TextInputType.name,
                  onTap: () {},
                  onSaved: (value) {
                    controller.model.notes = value!;
                  },
                  onValidate: (value) => null,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          width: double.maxFinite,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(46),
              topRight: Radius.circular(46),
            ),
          ),
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "select_manufacturer".tr,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close, color: Color(0xFF8D90A8)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SearchTextInputField(
                  controller: controller.searchInputController,
                  hintKey: "search".tr,
                  isUrdu: controller.isUrdu,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.manufacturerFilterList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final model = controller.manufacturerFilterList[index];
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          controller.onSelectManufacturer(model);
                          Get.back();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: controller.manufacturerId == model.id
                                ? Utils.appColor.withValues(alpha: 0.1)
                                : Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(40),
                            ),
                            border: Border.all(
                              color: controller.manufacturerId == model.id
                                  ? Utils.appColor
                                  : Colors.white,
                            ),
                          ),
                          child: Text(
                            model.name,
                            // overflow: TextOverflow.ellipsis,
                            // maxLines: 2,
                            style: Utils.getTextStyle(
                              baseSize: 16,
                              isBold: false,
                              color: Colors.black,
                              isUrdu: controller.isUrdu,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
