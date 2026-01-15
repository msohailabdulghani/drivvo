import 'package:drivvo/custom-widget/common/card_header_text.dart';
import 'package:drivvo/modules/admin/setting/setting_controller.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              // _buildCard(
              //   context,
              //   _buildSettingTile(
              //     context,
              //     icon: Icons.brightness_6_outlined,
              //     title: 'theme'.tr,
              //     subtitle: controller.selectedTheme.value,
              //     onTap: () => _showThemeDialog(context),
              //   ),
              // ),
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
                context,
                Obx(
                  () => _buildSettingTile(
                    context,
                    icon: Icons.calendar_today_outlined,
                    title: 'date_format'.tr,
                    subtitle: controller.selectedDateFormat.value,
                    onTap: () => _showDateFormatDialog(context),
                  ),
                ),
              ),
              SizedBox(height: 10),
              _buildCard(
                context,
                _buildSettingTile(
                  context,
                  icon: Icons.attach_money_outlined,
                  title: 'currency_format'.tr,
                  subtitle: controller.selectedCurrencyFormat.value,
                  onTap: () =>
                      _showCurrencySearchDialog(context, Utils.currencies),
                ),
              ),
              // SizedBox(height: 10),
              // _buildCard(
              //   _buildSettingTileWithCheckbox(
              //     icon: Icons.more_horiz,
              //     title: 'show_three_decimal'.tr,
              //     isChecked: controller.showThreeDecimalDigits.value,
              //     onChanged: (value) =>
              //         controller.showThreeDecimalDigits.value = value ?? false,
              //   ),
              // ),
              // SizedBox(height: 10),
              // _buildCard(
              //   _buildSettingTileWithCheckbox(
              //     icon: Icons.more_horiz,
              //     title: 'display_decimal_digits'.tr,
              //     isChecked: controller.displayDecimalDigits.value,
              //     onChanged: (value) =>
              //         controller.displayDecimalDigits.value = value ?? false,
              //   ),
              // ),
              SizedBox(height: 30),

              // Units Section
              CardHeaderText(
                title: 'units'.tr,
                isUrdu: controller.isUrdu,
                color: Utils.appColor,
              ),
              _buildCard(
                context,
                _buildSettingTile(
                  context,
                  icon: Icons.straighten_outlined,
                  title: 'km_miles'.tr,
                  subtitle: controller.selectedDistanceUnit.value,
                  onTap: () => Get.dialog(
                    Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tip",
                              style: Utils.getTextStyle(
                                baseSize: 18,
                                isBold: true,
                                color: Utils.appColor,
                                isUrdu: controller.isUrdu,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "You must edit your vehicle to change this setting",
                              style: Utils.getTextStyle(
                                baseSize: 14,
                                isBold: false,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.color!,
                                isUrdu: controller.isUrdu,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => Get.back(),
                                child: Text(
                                  'ok'.tr,
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
                  ),
                ),
              ),
              SizedBox(height: 10),
              _buildCard(
                context,
                _buildSettingTile(
                  context,
                  icon: Icons.local_gas_station_outlined,
                  title: 'unit'.tr,
                  subtitle: controller.selectedFuelUnit.value,
                  onTap: () => _showFuelUnitDialog(context),
                ),
              ),
              // SizedBox(height: 10),
              // _buildCard(
              //   _buildSettingTile(
              //     icon: Icons.speed_outlined,
              //     title: 'fuel_efficiency'.tr,
              //     subtitle: controller.selectedFuelEfficiency.value,
              //     onTap: () => _showFuelEfficiencyDialog(),
              //   ),
              // ),

              //! Fuel Efficiency Dialog
              // void _showFuelEfficiencyDialog() {
              //   final efficiencies = ['Mile/Gallon US', 'km/L', 'L/100km'];
              //   _showSelectionDialog(
              //     title: 'fuel_efficiency'.tr,
              //     options: efficiencies,
              //     selectedValue: controller.selectedFuelEfficiency.value,
              //     onSelected: (value) => controller.selectedFuelEfficiency.value = value,
              //   );
              // }
              SizedBox(height: 10),
              _buildCard(
                context,
                _buildSettingTile(
                  context,
                  icon: Icons.local_gas_station_outlined,
                  title: 'unit'.tr,
                  subtitle: controller.selectedGasUnit.value,
                  onTap: () => _showVolumeUnitDialog(context),
                ),
              ),
              SizedBox(height: 10),
              // _buildCard(
              //   _buildSettingTileWithCheckbox(
              //     icon: Icons.show_chart_outlined,
              //     title: 'show_average_last_records'.tr,
              //     isChecked: controller.showAverageLastRecords.value,
              //     onChanged: (value) =>
              //         controller.showAverageLastRecords.value = value ?? false,
              //   ),
              // ),
              SizedBox(height: 30),

              // Reminders Section
              CardHeaderText(
                title: 'reminders'.tr,
                isUrdu: controller.isUrdu,
                color: Utils.appColor,
              ),
              // _buildCard(
              //   _buildSettingTile(
              //     icon: Icons.social_distance_outlined,
              //     title: 'distance_in_advance'.tr,
              //     subtitle: controller.distanceInAdvance.value,
              //     onTap: () => _showDistanceInAdvanceDialog(),
              //   ),
              // ),
              // SizedBox(height: 10),
              // _buildCard(
              //   _buildSettingTile(
              //     icon: Icons.date_range_outlined,
              //     title: 'days_in_advance'.tr,
              //     subtitle: controller.daysInAdvance.value,
              //     onTap: () => _showDaysInAdvanceDialog(),
              //   ),
              // ),
              // SizedBox(height: 10),
              _buildCard(
                context,
                _buildSettingTile(
                  context,
                  icon: Icons.access_time_outlined,
                  title: 'best_time_notifications'.tr,
                  subtitle: controller.bestTimeForNotifications.value,
                  onTap: () => controller.showTimePickerDialog(),
                ),
              ),
              SizedBox(height: 10),
              _buildCard(
                context,
                _buildSettingTileWithCheckbox(
                  context,
                  icon: Icons.local_gas_station_outlined,
                  title: 'refueling_notifications'.tr,
                  isChecked: controller.refuelingNotifications.value,
                  onChanged: (value) =>
                      controller.refuelingNotifications.value = value ?? false,
                ),
              ),
              SizedBox(height: 10),
              _buildCard(
                context,
                _buildSettingTileWithCheckbox(
                  context,
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
                context,
                _buildSettingTileWithCheckbox(
                  context,
                  icon: Icons.ev_station_outlined,
                  title: 'gas_station_notifications'.tr,
                  isChecked: controller.gasStationNotifications.value,
                  onChanged: (value) =>
                      controller.gasStationNotifications.value = value ?? false,
                ),
              ),
              SizedBox(height: 10),
              _buildCard(
                context,
                _buildSettingTileWithCheckbox(
                  context,
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

  Widget _buildCard(BuildContext context, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
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
            color: Theme.of(context).listTileTheme.textColor!,
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

  Widget _buildSettingTileWithCheckbox(
    BuildContext context, {
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
          color: Theme.of(context).listTileTheme.textColor!,
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
  void _showThemeDialog(BuildContext context) {
    final themes = ['Light', 'Dark'];
    _showSelectionDialog(
      context,
      title: 'theme'.tr,
      options: themes,
      selectedValue: controller.selectedTheme.value,
      onSelected: (value) => controller.changeTheme(value),
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
  void _showDateFormatDialog(BuildContext context) {
    final formats = [
      'dd MMM yyyy',
      'MM/dd/yyyy',
      'yyyy-MM-dd',
      'dd-MM-yyyy',
      'MMM d, yyyy',
    ];
    _showSelectionDialog(
      context,
      title: 'date_format'.tr,
      options: formats,
      selectedValue: controller.selectedDateFormat.value,
      onSelected: (value) {
        controller.selectedDateFormat.value = value;
        controller.appService.setDateFormat(value);
      },
    );
  }

  // Searchable Currency Dialog
  void _showCurrencySearchDialog(
    BuildContext context,
    List<Map<String, String>> currencies,
  ) {
    final searchController = TextEditingController();
    final filteredCurrencies = currencies.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: double.maxFinite,
          height: Get.height * 0.7,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'currency_format'.tr,
                style: Utils.getTextStyle(
                  baseSize: 18,
                  isBold: true,
                  color: Theme.of(context).listTileTheme.textColor!,
                  isUrdu: controller.isUrdu,
                ),
              ),
              const SizedBox(height: 12),
              // Search Field
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'search'.tr,
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Utils.appColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    filteredCurrencies.value = currencies;
                  } else {
                    filteredCurrencies.value = currencies.where((currency) {
                      final name = currency['name']!.toLowerCase();
                      final code = currency['code']!.toLowerCase();
                      final symbol = currency['symbol']!.toLowerCase();
                      final query = value.toLowerCase();
                      return name.contains(query) ||
                          code.contains(query) ||
                          symbol.contains(query);
                    }).toList();
                  }
                },
              ),
              const SizedBox(height: 12),
              // Currency List
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: filteredCurrencies.length,
                    itemBuilder: (context, index) {
                      final currency = filteredCurrencies[index];
                      final displayText =
                          '${currency['name']} (${currency['code']}) - ${currency['format']}';
                      final isSelected =
                          controller.selectedCurrencyFormat.value ==
                          displayText;

                      return InkWell(
                        onTap: () {
                          controller.selectedCurrencyFormat.value = displayText;
                          controller.saveCurrencyFormat(currency);
                          Get.back();
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Utils.appColor.withValues(alpha: 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Utils.appColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    currency['symbol']!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Utils.appColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${currency['name']} (${currency['code']})',
                                      style: Utils.getTextStyle(
                                        baseSize: 14,
                                        isBold: false,
                                        color: Theme.of(
                                          context,
                                        ).listTileTheme.textColor!,
                                        isUrdu: controller.isUrdu,
                                      ),
                                    ),
                                    Text(
                                      currency['format']!,
                                      style: Utils.getTextStyle(
                                        baseSize: 12,
                                        isBold: false,
                                        color: Colors.grey.shade600,
                                        isUrdu: controller.isUrdu,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: Utils.appColor,
                                  size: 22,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
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

  // Fuel Unit Dialog
  void _showFuelUnitDialog(BuildContext context) {
    final units = ['Liter (L)', 'Gallon US (Gal)', 'Gallon UK (Gal)'];
    _showSelectionDialog(
      context,
      title: 'unit'.tr,
      options: units,
      selectedValue: controller.selectedFuelUnit.value,
      onSelected: (value) {
        controller.selectedFuelUnit.value = value;
        controller.appService.setFuelUnit(value);
      },
    );
  }

  // Volume Unit Dialog
  void _showVolumeUnitDialog(BuildContext context) {
    final units = ['m³', 'kg', 'GGE'];
    _showSelectionDialog(
      context,
      title: 'unit'.tr,
      options: units,
      selectedValue: controller.selectedGasUnit.value,
      onSelected: (value) {
        controller.selectedGasUnit.value = value;
        controller.appService.setGasUnit(value);
      },
    );
  }

  // Distance in Advance Dialog
  // void _showDistanceInAdvanceDialog() {
  //   final distances = [
  //     'Show reminder 100 km in advance.',
  //     'Show reminder 200 km in advance.',
  //     'Show reminder 300 km in advance.',
  //     'Show reminder 500 km in advance.',
  //   ];
  //   _showSelectionDialog(
  //     title: 'distance_in_advance'.tr,
  //     options: distances,
  //     selectedValue: controller.distanceInAdvance.value,
  //     onSelected: (value) => controller.distanceInAdvance.value = value,
  //   );
  // }

  // Days in Advance Dialog
  // void _showDaysInAdvanceDialog() {
  //   final days = [
  //     'Show reminder 7 days in advance.',
  //     'Show reminder 15 days in advance.',
  //     'Show reminder 30 days in advance.',
  //     'Show reminder 60 days in advance.',
  //   ];
  //   _showSelectionDialog(
  //     title: 'days_in_advance'.tr,
  //     options: days,
  //     selectedValue: controller.daysInAdvance.value,
  //     onSelected: (value) => controller.daysInAdvance.value = value,
  //   );
  // }

  // Generic Selection Dialog
  void _showSelectionDialog(
    BuildContext context, {
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
            color: Theme.of(context).cardTheme.color,
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
                  color: Theme.of(context).listTileTheme.textColor!,
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
                      color: Theme.of(context).listTileTheme.textColor!,
                      isUrdu: controller.isUrdu,
                    ),
                  ),
                  value: option,
                  // ignore: deprecated_member_use
                  groupValue: selectedValue,
                  activeColor: Utils.appColor,
                  // ignore: deprecated_member_use
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
