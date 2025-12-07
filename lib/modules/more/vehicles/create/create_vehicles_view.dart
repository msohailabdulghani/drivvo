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
        name: "Add new Vehicle",
        isUrdu: controller.isUrdu,
        bgColor: const Color(0xFF047772),
        textColor: Colors.white,
        centerTitle: true,
        showBackBtn: true,
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
                title: "Basic Information",
                isUrdu: controller.isUrdu,
              ),
              _buildCard(
                child: Column(
                  children: [
                    FormLabelText(
                      title: "Vehicle Type",
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
                              child: Text(element),
                            );
                          })
                          .toList(),
                      onChanged: (String? value) =>
                          controller.onSelectVehicleType(value!),
                      validator: (value) {
                        if (value == null || value == "") {
                          return "Vechile type is required".tr;
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
                      labelText: "Vehicle Name".tr,
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
                      labelText: "Manufacturer".tr,
                      hintText: "e.g, Toyota, Honda".tr,
                      inputAction: TextInputAction.next,
                      type: TextInputType.name,
                      sufixIcon: Icon(Icons.info_outline),
                      onSaved: (value) {},
                      onTap: () {
                        openBottomSheet(context);
                      },
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Manufacturer is required'.tr;
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
                      labelText: "Model".tr,
                      hintText: "eg Civic, Camry".tr,
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
              CardHeaderText(title: "Registration", isUrdu: controller.isUrdu),
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
                        labelText: "License Plate (optional)".tr,
                        hintText: "ABC-1234".tr,
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
                          const Text(
                            "Year",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
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
                title: "Fuel Configuration",
                isUrdu: controller.isUrdu,
              ),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormLabelText(
                      title: "Tank Configuration",
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
                          child: Text(element),
                        );
                      }).toList(),
                      onChanged: (String? value) =>
                          controller.onSelectTank(value!),
                      validator: (value) {
                        if (value == null || value == "") {
                          return "Tank configuration is required".tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    FormLabelText(
                      title: "Fuel Type",
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
                          return "Fuel type is required".tr;
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
                      labelText: "Fuel Capacity".tr,
                      hintText: "Capacity in gallons".tr,
                      inputAction: TextInputAction.next,
                      type: TextInputType.name,
                      onTap: () {},
                      onSaved: (value) {
                        controller.model.fuelCapacity = value!;
                      },
                      onValidate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Fuel Capacity is required'.tr;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // --- Preferences Card ---
              CardHeaderText(title: "Preferences", isUrdu: controller.isUrdu),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Distance Unit",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ChoiceChip(
                            label: Text(
                              "Kilometers (km)",
                              style: TextStyle(
                                fontFamily: "D-FONT-R",
                                fontSize: 15,
                                color:
                                    controller.selectedChipName.value ==
                                        "Kilometers"
                                    ? Colors.white
                                    : Colors.black,
                                fontStyle: FontStyle.normal,
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
                              "Miles (mi)",
                              style: TextStyle(
                                fontFamily: "D-FONT-R",
                                fontSize: 15,
                                color:
                                    controller.selectedChipName.value == "Miles"
                                    ? Colors.white
                                    : Colors.black,
                                fontStyle: FontStyle.normal,
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
                title: "Additional Details",
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
                      labelText: "Chassis Number (optional)".tr,
                      hintText: "Enter chassis number".tr,
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
                      labelText: "VIN (Identification number)".tr,
                      hintText: "Enter VIN".tr,
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
                      "Active Vehicle",
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
                  labelText: "Note (optional)".tr,
                  hintText: "Add any additional notes about this vehicle...".tr,
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
                                ? const Color(0xFF047772).withValues(alpha: 0.1)
                                : Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(40),
                            ),
                            border: Border.all(
                              color: controller.manufacturerId == model.id
                                  ? const Color(0xFF047772)
                                  : Colors.white,
                            ),
                          ),
                          child: Text(
                            model.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
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
