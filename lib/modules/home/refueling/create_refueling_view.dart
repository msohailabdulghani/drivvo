import 'package:drivvo/custom-widget/common/card_header_text.dart';
import 'package:drivvo/custom-widget/common/label_text.dart';
import 'package:drivvo/custom-widget/text-input-field/form_label_text.dart';
import 'package:drivvo/modules/home/refueling/create_refueling_controller.dart';
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
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          'refueling'.tr,
          style: Utils.getTextStyle(
            baseSize: 18,
            isBold: true,
            color: Colors.black,
            isUrdu: controller.isUrdu,
          ),
        ),
        actions: [
          IconButton(
            onPressed: controller.saveRefueling,
            icon: const Icon(Icons.check, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date & Time Section
              CardHeaderText(
                title: 'date_and_time'.tr,
                isUrdu: controller.isUrdu,
              ),
              _buildDateTimeCard(),

              const SizedBox(height: 24),

              // Odometer Section
              FormLabelText(title: 'odometer'.tr, isUrdu: controller.isUrdu),
              _buildOdometerField(),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${'last_odometer'.tr}: 2200 km',
                    style: Utils.getTextStyle(
                      baseSize: 12,
                      isBold: false,
                      color: Colors.grey[600]!,
                      isUrdu: controller.isUrdu,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Fuel Section
              FormLabelText(title: 'fuel'.tr, isUrdu: controller.isUrdu),
              _buildDropdownField(hintText: 'gas_premium'.tr, onTap: () {}),

              const SizedBox(height: 24),

              // Price & Gal Section
              FormLabelText(
                title: 'price_and_gal'.tr,
                isUrdu: controller.isUrdu,
              ),
              _buildPriceGallonsCard(),

              const SizedBox(height: 16),

              // Are you filling this tank?
              _buildSwitchRow(
                icon: Icons.local_gas_station_outlined,
                label: 'are_you_filling_this_tank'.tr,
                value: controller.isFillingTank,
                onChanged: (val) => controller.isFillingTank.value = val,
              ),

              const SizedBox(height: 16),

              // Fuel + Button
              _buildAddButton('fuel'.tr),

              const SizedBox(height: 24),

              // Driver Section
              FormLabelText(title: 'driver'.tr, isUrdu: controller.isUrdu),
              _buildTextField(hintText: 'Amir'),

              const SizedBox(height: 24),

              // Gas Station Section
              FormLabelText(title: 'gas_station'.tr, isUrdu: controller.isUrdu),
              _buildDropdownField(
                hintText: 'Shell - Downtown Boston',
                onTap: () {},
              ),

              const SizedBox(height: 24),

              // Payment Method Section
              FormLabelText(
                title: 'payment_method'.tr,
                isUrdu: controller.isUrdu,
              ),
              _buildDropdownField(hintText: 'Visa****4321', onTap: () {}),

              const SizedBox(height: 24),

              // Reason Section
              FormLabelText(title: 'reason'.tr, isUrdu: controller.isUrdu),
              _buildDropdownField(hintText: 'Trip', onTap: () {}),

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

              // Attach file button
              _buildAddButton('attach_file'.tr),

              const SizedBox(height: 24),

              // Notes Section
              LabelText(title: 'notes'.tr, isUrdu: controller.isUrdu),
              _buildNotesField(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Date Field
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'date'.tr,
                  style: Utils.getTextStyle(
                    baseSize: 12,
                    isBold: false,
                    color: Colors.grey[600]!,
                    isUrdu: controller.isUrdu,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: controller.selectDate,
                  child: Obx(
                    () => Text(
                      controller.selectedDate.value,
                      style: Utils.getTextStyle(
                        baseSize: 14,
                        isBold: false,
                        color: Colors.black87,
                        isUrdu: controller.isUrdu,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          const SizedBox(width: 16),
          // Time Field
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'time'.tr,
                  style: Utils.getTextStyle(
                    baseSize: 12,
                    isBold: false,
                    color: Colors.grey[600]!,
                    isUrdu: controller.isUrdu,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: controller.selectTime,
                  child: Obx(
                    () => Text(
                      controller.selectedTime.value,
                      style: Utils.getTextStyle(
                        baseSize: 14,
                        isBold: false,
                        color: Colors.black87,
                        isUrdu: controller.isUrdu,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOdometerField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextFormField(
        controller: controller.odometerController,
        keyboardType: TextInputType.number,
        style: Utils.getTextStyle(
          baseSize: 14,
          isBold: false,
          color: Colors.black,
          isUrdu: controller.isUrdu,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Km',
          hintStyle: Utils.getTextStyle(
            baseSize: 14,
            isBold: false,
            color: Colors.grey[400]!,
            isUrdu: controller.isUrdu,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hintText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              hintText,
              style: Utils.getTextStyle(
                baseSize: 14,
                isBold: false,
                color: Colors.black87,
                isUrdu: controller.isUrdu,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceGallonsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Price Field
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'price'.tr,
                  style: Utils.getTextStyle(
                    baseSize: 12,
                    isBold: false,
                    color: Colors.grey[600]!,
                    isUrdu: controller.isUrdu,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.priceController,
                  keyboardType: TextInputType.number,
                  style: Utils.getTextStyle(
                    baseSize: 14,
                    isBold: false,
                    color: Colors.black,
                    isUrdu: controller.isUrdu,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'amount'.tr,
                    hintStyle: Utils.getTextStyle(
                      baseSize: 14,
                      isBold: false,
                      color: Colors.grey[400]!,
                      isUrdu: controller.isUrdu,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          const SizedBox(width: 16),
          // Total Cost Field
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'total_cost'.tr,
                  style: Utils.getTextStyle(
                    baseSize: 12,
                    isBold: false,
                    color: Colors.grey[600]!,
                    isUrdu: controller.isUrdu,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.totalCostController,
                  keyboardType: TextInputType.number,
                  style: Utils.getTextStyle(
                    baseSize: 14,
                    isBold: false,
                    color: Colors.black,
                    isUrdu: controller.isUrdu,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'cost'.tr,
                    hintStyle: Utils.getTextStyle(
                      baseSize: 14,
                      isBold: false,
                      color: Colors.grey[400]!,
                      isUrdu: controller.isUrdu,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          const SizedBox(width: 16),
          // Gallons Field
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'gallons'.tr,
                  style: Utils.getTextStyle(
                    baseSize: 12,
                    isBold: false,
                    color: Colors.grey[600]!,
                    isUrdu: controller.isUrdu,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.gallonsController,
                  keyboardType: TextInputType.number,
                  style: Utils.getTextStyle(
                    baseSize: 14,
                    isBold: false,
                    color: Colors.black,
                    isUrdu: controller.isUrdu,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Gallons',
                    hintStyle: Utils.getTextStyle(
                      baseSize: 14,
                      isBold: false,
                      color: Colors.grey[400]!,
                      isUrdu: controller.isUrdu,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String label,
    required RxBool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
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
              activeColor: Utils.appColor,
              activeTrackColor: Utils.appColor.withValues(alpha: 0.2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(String label) {
    return OutlinedButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: Utils.appColor,
        side: BorderSide(color: Utils.appColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      icon: const Icon(Icons.add, size: 18),
      label: Text(
        label,
        style: Utils.getTextStyle(
          baseSize: 14,
          isBold: true,
          color: Utils.appColor,
          isUrdu: controller.isUrdu,
        ),
      ),
    );
  }

  Widget _buildTextField({required String hintText}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextFormField(
        controller: controller.driverController,
        style: Utils.getTextStyle(
          baseSize: 14,
          isBold: false,
          color: Colors.black,
          isUrdu: controller.isUrdu,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: Utils.getTextStyle(
            baseSize: 14,
            isBold: false,
            color: Colors.grey[400]!,
            isUrdu: controller.isUrdu,
          ),
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextFormField(
        controller: controller.notesController,
        maxLines: 4,
        style: Utils.getTextStyle(
          baseSize: 14,
          isBold: false,
          color: Colors.black,
          isUrdu: controller.isUrdu,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Note...',
          hintStyle: Utils.getTextStyle(
            baseSize: 14,
            isBold: false,
            color: Colors.grey[400]!,
            isUrdu: controller.isUrdu,
          ),
        ),
      ),
    );
  }
}
