import 'package:drivvo/custom-widget/button/custom_button.dart';
import 'package:drivvo/custom-widget/common/card_header_text.dart';
import 'package:drivvo/model/date_range_model.dart';
import 'package:drivvo/modules/home/filter/home_filter_controller.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeFilterView extends GetView<FilterController> {
  const HomeFilterView({super.key});

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
          'filter'.tr,
          style: Utils.getTextStyle(
            baseSize: 18,
            isBold: true,
            color: Colors.white,
            isUrdu: controller.isUrdu,
          ),
        ),
        actions: [
          TextButton(
            onPressed: controller.clearFilters,
            child: Text(
              'clear_filters'.tr,
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardHeaderText(
                    title: "time_period".tr,
                    isUrdu: controller.isUrdu,
                  ),

                  // Dropdown
                  DropdownButtonFormField<DateRangeModel>(
                    initialValue: controller.dateRangeList.first,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    items: controller.dateRangeList
                        .map<DropdownMenuItem<DateRangeModel>>((element) {
                          return DropdownMenuItem<DateRangeModel>(
                            value: element,
                            child: Text(
                              element.title.tr,
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
                    onChanged: (DateRangeModel? value) =>
                        controller.onSelectDateRange(value!),
                    validator: (value) {
                      if (value == null) {
                        return "time_period_required".tr;
                      } else {
                        return null;
                      }
                    },
                  ),

                  const SizedBox(height: 10),

                  Obx(
                    () => Center(
                      child: Text(
                        controller.customDate.value,
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: "D-FONT-R",
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  CardHeaderText(
                    title: "categories".tr,
                    isUrdu: controller.isUrdu,
                  ),

                  // Category Switch Items
                  Obx(
                    () => _buildCategoryItem(
                      'refueling'.tr,
                      Icons.local_gas_station_outlined,
                      controller.refueling.value,
                      (v) => controller.refueling.value = v,
                      controller,
                    ),
                  ),
                  Obx(
                    () => _buildCategoryItem(
                      'expenses'.tr,
                      Icons.receipt_long_outlined,
                      controller.expenses.value,
                      (v) => controller.expenses.value = v,
                      controller,
                    ),
                  ),
                  Obx(
                    () => _buildCategoryItem(
                      'incomes'.tr,
                      Icons.account_balance_wallet_outlined,
                      controller.incomes.value,
                      (v) => controller.incomes.value = v,
                      controller,
                    ),
                  ),
                  Obx(
                    () => _buildCategoryItem(
                      'services'.tr,
                      Icons.settings_outlined,
                      controller.services.value,
                      (v) => controller.services.value = v,
                      controller,
                    ),
                  ),
                  Obx(
                    () => _buildCategoryItem(
                      'pouters'.tr,
                      Icons.alt_route_outlined,
                      controller.pouters.value,
                      (v) => controller.pouters.value = v,
                      controller,
                    ),
                  ),
                  Obx(
                    () => _buildCategoryItem(
                      'checklist'.tr,
                      Icons.checklist_outlined,
                      controller.checklist.value,
                      (v) => controller.checklist.value = v,
                      controller,
                    ),
                  ),

                  const SizedBox(height: 24),
                  Obx(() => _buildMoreOptionsButton(controller)),

                  // More Options Expanded Section
                  Obx(() {
                    if (controller.moreOptionsExpanded.value) {
                      return Column(
                        children: [
                          const SizedBox(height: 16),
                          _buildFilterOption(
                            'fuel'.tr,
                            'select_fuel_type'.tr,
                            Icons.local_gas_station_outlined,
                            controller,
                          ),
                          _buildFilterOption(
                            'gas_station'.tr,
                            'select_station'.tr,
                            Icons.store_outlined,
                            controller,
                          ),
                          _buildFilterOption(
                            'type_of_expense'.tr,
                            'financing'.tr,
                            Icons.receipt_outlined,
                            controller,
                          ),
                          _buildFilterOption(
                            'type_of_income'.tr,
                            'select_income_type'.tr,
                            Icons.attach_money,
                            controller,
                          ),
                          _buildFilterOption(
                            'type_of_service'.tr,
                            'select_station'.tr,
                            Icons.favorite_border,
                            controller,
                          ),
                          _buildFilterOption(
                            'place'.tr,
                            'select_location'.tr,
                            Icons.place_outlined,
                            controller,
                          ),
                          _buildFilterOption(
                            'reason'.tr,
                            'enter_method'.tr,
                            null,
                            controller,
                          ),
                          _buildFilterOption(
                            'driver'.tr,
                            'select_driver'.tr,
                            Icons.person_outline,
                            controller,
                          ),
                          _buildFilterOption(
                            'form'.tr,
                            'select_form'.tr,
                            Icons.account_tree_outlined,
                            controller,
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Apply Filter Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: CustomButton(
              title: "apply_filter".tr,
              onTap: () {
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
    FilterController controller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        leading: Icon(icon, color: Colors.black87, size: 22),
        title: Text(
          title,
          style: Utils.getTextStyle(
            baseSize: 15,
            isBold: false,
            color: Colors.black87,
            isUrdu: controller.isUrdu,
          ),
        ),
        trailing: Transform.scale(
          scale: 0.8,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Utils.appColor,
            activeTrackColor: Utils.appColor.withValues(alpha: 0.2),
          ),
        ),
      ),
    );
  }

  Widget _buildMoreOptionsButton(FilterController controller) {
    const Color primaryColor = Color(0xFF047772);
    return InkWell(
      onTap: controller.toggleMoreOptions,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              controller.moreOptionsExpanded.value ? Icons.remove : Icons.add,
              color: primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'more_options'.tr,
              style: Utils.getTextStyle(
                baseSize: 15,
                isBold: true,
                color: primaryColor,
                isUrdu: controller.isUrdu,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(
    String title,
    String subtitle,
    IconData? icon,
    FilterController controller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: icon != null
              ? Icon(icon, color: Colors.blueGrey[700], size: 20)
              : const SizedBox(width: 20, height: 20),
        ),
        title: Text(
          title,
          style: Utils.getTextStyle(
            baseSize: 14,
            isBold: true,
            color: Colors.black87,
            isUrdu: controller.isUrdu,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Utils.getTextStyle(
            baseSize: 12,
            isBold: false,
            color: Colors.grey[400]!,
            isUrdu: controller.isUrdu,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
