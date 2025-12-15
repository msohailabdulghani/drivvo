import 'package:drivvo/custom-widget/common/card_header_text.dart';
import 'package:drivvo/modules/setting/setting_controller.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Utils.appColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "setting".tr,
          style: Utils.getTextStyle(
            baseSize: 20,
            isBold: true,
            color: Colors.white,
            isUrdu: controller.isUrdu,
          ),
        ),
        centerTitle: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 14.0,
            ),
            children: [
              // Categories Section
              CardHeaderText(
                title: 'categories'.tr,
                isUrdu: controller.isUrdu,
                color: Utils.appColor,
              ),
              _buildCard(
                _buildSettingTile(
                  icon: Icons.brightness_6_outlined,
                  title: 'theme'.tr,
                  subtitle: controller.selectedTheme.value,
                  onTap: () => _showThemeDialog(),
                ),
              ),
              // SizedBox(height: 10),
              // _buildCard(
              //   _buildSettingTile(
              //     icon: Icons.language_outlined,
              //     title: 'language'.tr,
              //     subtitle: controller.selectedLanguage.value,
              //     onTap: () => _showLanguageDialog(),
              //   ),
              // ),
              SizedBox(height: 10),
              _buildCard(
                _buildSettingTile(
                  icon: Icons.calendar_today_outlined,
                  title: 'date_format'.tr,
                  subtitle: controller.selectedDateFormat.value,
                  onTap: () => _showDateFormatDialog(),
                ),
              ),
              SizedBox(height: 10),
              _buildCard(
                _buildSettingTile(
                  icon: Icons.attach_money_outlined,
                  title: 'currency_format'.tr,
                  subtitle: controller.selectedCurrencyFormat.value,
                  onTap: () => _showCurrencyFormatDialog(),
                ),
              ),
              SizedBox(height: 10),
              _buildCard(
                _buildSettingTileWithCheckbox(
                  icon: Icons.more_horiz,
                  title: 'show_three_decimal'.tr,
                  isChecked: controller.showThreeDecimalDigits.value,
                  onChanged: (value) =>
                      controller.showThreeDecimalDigits.value = value ?? false,
                ),
              ),
              SizedBox(height: 10),
              _buildCard(
                _buildSettingTileWithCheckbox(
                  icon: Icons.more_horiz,
                  title: 'display_decimal_digits'.tr,
                  isChecked: controller.displayDecimalDigits.value,
                  onChanged: (value) =>
                      controller.displayDecimalDigits.value = value ?? false,
                ),
              ),
              SizedBox(height: 30),

              // Units Section
              CardHeaderText(
                title: 'units'.tr,
                isUrdu: controller.isUrdu,
                color: Utils.appColor,
              ),
              _buildCard(
                _buildSettingTile(
                  icon: Icons.straighten_outlined,
                  title: 'km_miles'.tr,
                  subtitle: controller.selectedDistanceUnit.value,
                  onTap: () => _showDistanceUnitDialog(),
                ),
              ),
              SizedBox(height: 10),
              _buildCard(
                _buildSettingTile(
                  icon: Icons.local_gas_station_outlined,
                  title: 'unit'.tr,
                  subtitle: controller.selectedFuelUnit.value,
                  onTap: () => _showFuelUnitDialog(),
                ),
              ),
              SizedBox(height: 10),
              _buildCard(
                _buildSettingTile(
                  icon: Icons.speed_outlined,
                  title: 'fuel_efficiency'.tr,
                  subtitle: controller.selectedFuelEfficiency.value,
                  onTap: () => _showFuelEfficiencyDialog(),
                ),
              ),
              SizedBox(height: 10),
              _buildCard(
                _buildSettingTile(
                  icon: Icons.local_gas_station_outlined,
                  title: 'unit'.tr,
                  subtitle: controller.selectedVolumeUnit.value,
                  onTap: () => _showVolumeUnitDialog(),
                ),
              ),
              SizedBox(height: 10),
              _buildCard(
                _buildSettingTileWithCheckbox(
                  icon: Icons.show_chart_outlined,
                  title: 'show_average_last_records'.tr,
                  isChecked: controller.showAverageLastRecords.value,
                  onChanged: (value) =>
                      controller.showAverageLastRecords.value = value ?? false,
                ),
              ),
              SizedBox(height: 30),

              // Reminders Section
              CardHeaderText(
                title: 'reminders'.tr,
                isUrdu: controller.isUrdu,
                color: Utils.appColor,
              ),
              _buildCard(
                _buildSettingTile(
                  icon: Icons.social_distance_outlined,
                  title: 'distance_in_advance'.tr,
                  subtitle: controller.distanceInAdvance.value,
                  onTap: () => _showDistanceInAdvanceDialog(),
                ),
              ),
              SizedBox(height: 10),
              _buildCard(
                _buildSettingTile(
                  icon: Icons.date_range_outlined,
                  title: 'days_in_advance'.tr,
                  subtitle: controller.daysInAdvance.value,
                  onTap: () => _showDaysInAdvanceDialog(),
                ),
              ),
              SizedBox(height: 10),
              _buildCard(
                _buildSettingTile(
                  icon: Icons.access_time_outlined,
                  title: 'best_time_notifications'.tr,
                  subtitle: controller.bestTimeForNotifications.value,
                  onTap: () => _showTimePickerDialog(),
                ),
              ),
              SizedBox(height: 10),
              _buildCard(
                _buildSettingTileWithCheckbox(
                  icon: Icons.local_gas_station_outlined,
                  title: 'refueling_notifications'.tr,
                  isChecked: controller.refuelingNotifications.value,
                  onChanged: (value) =>
                      controller.refuelingNotifications.value = value ?? false,
                ),
              ),
              SizedBox(height: 10),
              _buildCard(
                _buildSettingTileWithCheckbox(
                  icon: Icons.tire_repair_outlined,
                  title: 'tire_pressure_notifications'.tr,
                  isChecked: controller.tirePressureNotifications.value,
                  onChanged: (value) =>
                      controller.tirePressureNotifications.value =
                          value ?? false,
                ),
              ),
              SizedBox(height: 10),
              _buildCard(
                _buildSettingTileWithCheckbox(
                  icon: Icons.ev_station_outlined,
                  title: 'gas_station_notifications'.tr,
                  isChecked: controller.gasStationNotifications.value,
                  onChanged: (value) =>
                      controller.gasStationNotifications.value = value ?? false,
                ),
              ),
              SizedBox(height: 10),
              _buildCard(
                _buildSettingTileWithCheckbox(
                  icon: Icons.vibration_outlined,
                  title: 'vibrate_when_notifying'.tr,
                  isChecked: controller.vibrateWhenNotifying.value,
                  onChanged: (value) =>
                      controller.vibrateWhenNotifying.value = value ?? false,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 4.0,
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF00796B).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF00796B), size: 22),
        ),
        title: Text(
          title,
          style: Utils.getTextStyle(
            baseSize: 15,
            isBold: false,
            color: Colors.black,
            isUrdu: controller.isUrdu,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Utils.getTextStyle(
            baseSize: 13,
            isBold: false,
            color: Colors.grey.shade500,
            isUrdu: controller.isUrdu,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTileWithCheckbox({
    required IconData icon,
    required String title,
    required bool isChecked,
    required ValueChanged<bool?> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 4.0,
      ),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF00796B).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF00796B), size: 22),
      ),
      title: Text(
        title,
        style: Utils.getTextStyle(
          baseSize: 15,
          isBold: false,
          color: Colors.black,
          isUrdu: controller.isUrdu,
        ),
      ),
      trailing: Checkbox(
        value: isChecked,
        onChanged: onChanged,
        activeColor: Utils.appColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  // Theme Dialog
  void _showThemeDialog() {
    final themes = ['Use system default', 'Light', 'Dark'];
    _showSelectionDialog(
      title: 'theme'.tr,
      options: themes,
      selectedValue: controller.selectedTheme.value,
      onSelected: (value) => controller.selectedTheme.value = value,
    );
  }

  //! Language Dialog
  // void _showLanguageDialog() {
  //   final languages = ['English (United States)', 'اردو (پاکستان)'];
  //   _showSelectionDialog(
  //     title: 'language'.tr,
  //     options: languages,
  //     selectedValue: controller.selectedLanguage.value,
  //     onSelected: (value) {
  //       controller.selectedLanguage.value = value;
  //       controller.changeLanguage(value);
  //     },
  //   );
  // }

  // Date Format Dialog
  void _showDateFormatDialog() {
    final formats = ['DD/MM/YY', 'MM/DD/YY', 'YY/MM/DD', 'DD-MM-YY'];
    _showSelectionDialog(
      title: 'date_format'.tr,
      options: formats,
      selectedValue: controller.selectedDateFormat.value,
      onSelected: (value) => controller.selectedDateFormat.value = value,
    );
  }

  // Currency Format Dialog
  void _showCurrencyFormatDialog() {
    final formats = [
      '\$1,000,200.00',
      '1.000.200,00 \$',
      '1 000 200,00 \$',
      '1,000,200.00',
    ];
    _showSelectionDialog(
      title: 'currency_format'.tr,
      options: formats,
      selectedValue: controller.selectedCurrencyFormat.value,
      onSelected: (value) => controller.selectedCurrencyFormat.value = value,
    );
  }

  // Distance Unit Dialog
  void _showDistanceUnitDialog() {
    final units = ['km', 'Miles'];
    _showSelectionDialog(
      title: 'km_miles'.tr,
      options: units,
      selectedValue: controller.selectedDistanceUnit.value,
      onSelected: (value) => controller.selectedDistanceUnit.value = value,
    );
  }

  // Fuel Unit Dialog
  void _showFuelUnitDialog() {
    final units = ['Gallon US (Gal)', 'Gallon UK (Gal)', 'Liter (L)'];
    _showSelectionDialog(
      title: 'unit'.tr,
      options: units,
      selectedValue: controller.selectedFuelUnit.value,
      onSelected: (value) => controller.selectedFuelUnit.value = value,
    );
  }

  // Volume Unit Dialog
  void _showVolumeUnitDialog() {
    final units = ['Liter (L)', 'Gallon US (Gal)', 'Gallon UK (Gal)'];
    _showSelectionDialog(
      title: 'unit'.tr,
      options: units,
      selectedValue: controller.selectedVolumeUnit.value,
      onSelected: (value) => controller.selectedVolumeUnit.value = value,
    );
  }

  // Fuel Efficiency Dialog
  void _showFuelEfficiencyDialog() {
    final efficiencies = ['Mile/Gallon US', 'km/L', 'L/100km'];
    _showSelectionDialog(
      title: 'fuel_efficiency'.tr,
      options: efficiencies,
      selectedValue: controller.selectedFuelEfficiency.value,
      onSelected: (value) => controller.selectedFuelEfficiency.value = value,
    );
  }

  // Distance in Advance Dialog
  void _showDistanceInAdvanceDialog() {
    final distances = [
      'Show reminder 100 km in advance.',
      'Show reminder 200 km in advance.',
      'Show reminder 300 km in advance.',
      'Show reminder 500 km in advance.',
    ];
    _showSelectionDialog(
      title: 'distance_in_advance'.tr,
      options: distances,
      selectedValue: controller.distanceInAdvance.value,
      onSelected: (value) => controller.distanceInAdvance.value = value,
    );
  }

  // Days in Advance Dialog
  void _showDaysInAdvanceDialog() {
    final days = [
      'Show reminder 7 days in advance.',
      'Show reminder 15 days in advance.',
      'Show reminder 30 days in advance.',
      'Show reminder 60 days in advance.',
    ];
    _showSelectionDialog(
      title: 'days_in_advance'.tr,
      options: days,
      selectedValue: controller.daysInAdvance.value,
      onSelected: (value) => controller.daysInAdvance.value = value,
    );
  }

  // Time Picker Dialog
  void _showTimePickerDialog() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Utils.appColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.bestTimeForNotifications.value = picked.format(Get.context!);
    }
  }

  // Generic Selection Dialog
  void _showSelectionDialog({
    required String title,
    required List<String> options,
    required String selectedValue,
    required Function(String) onSelected,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Utils.getTextStyle(
                  baseSize: 18,
                  isBold: true,
                  color: Colors.black,
                  isUrdu: controller.isUrdu,
                ),
              ),
              const SizedBox(height: 16),
              ...options.map(
                (option) => RadioListTile<String>(
                  title: Text(
                    option,
                    style: Utils.getTextStyle(
                      baseSize: 14,
                      isBold: false,
                      color: Colors.black,
                      isUrdu: controller.isUrdu,
                    ),
                  ),
                  value: option,
                  groupValue: selectedValue,
                  activeColor: Utils.appColor,
                  onChanged: (value) {
                    if (value != null) {
                      onSelected(value);
                      Get.back();
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'cancel'.tr,
                    style: Utils.getTextStyle(
                      baseSize: 14,
                      isBold: true,
                      color: Utils.appColor,
                      isUrdu: controller.isUrdu,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
