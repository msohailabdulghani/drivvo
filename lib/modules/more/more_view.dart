import 'package:drivvo/custom-widget/common/card_header_text.dart';
import 'package:drivvo/modules/more/more_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoreView extends GetView<MoreController> {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "more_options".tr,
          style: Utils.getTextStyle(
            baseSize: 18,
            isBold: true,
            color: Colors.black,
            isUrdu: controller.isUrdu,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: [
            CardHeaderText(
              title: 'section_account_data'.tr,
              isUrdu: controller.isUrdu,
            ),
            _buildSectionCard([
              _buildTile(
                icon: Icons.sim_card_outlined,
                title: 'premium_plans'.tr,
                subtitle: 'premium_plans_sub'.tr,
                onTap: () {},
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.person_outline,
                title: 'my_account'.tr,
                subtitle: 'my_account_sub'.tr,
                onTap: () => Get.toNamed(AppRoutes.UPDATE_PROFILE_VIEW),
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.sync,
                title: 'sync_data'.tr,
                subtitle: 'sync_data_sub'.tr,
                onTap: () {},
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.storage,
                title: 'storage'.tr,
                subtitle: 'storage_sub'.tr,
                trailingInfo: '85%',
                trailingColor: Color(0xFF00796B),
                onTap: () {},
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.swap_horiz,
                title: 'transfer'.tr,
                subtitle: 'transfer_sub'.tr,
                onTap: () {},
              ),
            ]),
            CardHeaderText(
              title: 'section_vehicles'.tr,
              isUrdu: controller.isUrdu,
            ),
            _buildSectionCard([
              Obx(
                () => _buildTile(
                  icon: Icons.directions_car_outlined,
                  title: 'my_vehicles'.tr,
                  subtitle: controller.registeredVehicles.value > 1
                      ? '${controller.registeredVehicles.value} ${"vehicles_registered".tr}'
                      : '${controller.registeredVehicles.value} ${"vehicle_registered".tr}',
                  onTap: () => Get.toNamed(AppRoutes.VEHICLES_VIEW),
                ),
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.people_outline,
                title: 'users'.tr,
                subtitle: 'users_sub'.tr,
                onTap: () {},
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.settings_applications_outlined,
                title: 'vehicle_user'.tr,
                subtitle: 'vehicle_user_sub'.tr,
                onTap: () {},
              ),
            ]),
            CardHeaderText(
              title: 'section_tracking'.tr,
              isUrdu: controller.isUrdu,
            ),
            _buildSectionCard([
              _buildTile(
                icon: Icons.local_gas_station_outlined,
                title: 'fuel'.tr,
                subtitle: 'fuel_sub'.tr,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: Constants.FUEL,
                  );
                },
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.store_mall_directory_outlined,
                title: 'gas_stations'.tr,
                subtitle: 'gas_stations_sub'.tr,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: Constants.GAS_STATIONS,
                  );
                },
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.place_outlined,
                title: 'places'.tr,
                subtitle: 'places_sub'.tr,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: Constants.PLACES,
                  );
                },
              ),
            ]),
            CardHeaderText(
              title: 'section_financial'.tr,
              isUrdu: controller.isUrdu,
            ),
            _buildSectionCard([
              _buildTile(
                icon: Icons.attach_money,
                title: 'types_expense'.tr,
                subtitle: 'types_expense_sub'.tr,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: Constants.EXPENSE_TYPES,
                  );
                },
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.money_off,
                title: 'types_income'.tr,
                subtitle: 'types_income_sub'.tr,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: Constants.INCOME_TYPES,
                  );
                },
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.build_outlined,
                title: 'types_service'.tr,
                subtitle: 'types_service_sub'.tr,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: Constants.SERVICE_TYPES,
                  );
                },
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.credit_card,
                title: 'payment_methods'.tr,
                subtitle: 'payment_methods_sub'.tr,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: Constants.PAYMENT_METHOD,
                  );
                },
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.label_outline,
                title: 'reasons'.tr,
                subtitle: 'reasons_sub'.tr,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: Constants.REASONS,
                  );
                },
              ),
            ]),
            CardHeaderText(
              title: 'section_tools'.tr,
              isUrdu: controller.isUrdu,
            ),
            _buildSectionCard([
              _buildTile(
                icon: Icons.description_outlined,
                title: 'forms'.tr,
                subtitle: 'forms_sub'.tr,
                onTap: () {},
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.map_outlined,
                title: 'my_places'.tr,
                subtitle: 'my_places_sub'.tr,
                onTap: () {},
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.calculate_outlined,
                title: 'flex_calculator'.tr,
                subtitle: 'flex_calculator_sub'.tr,
                onTap: () {},
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.emoji_events_outlined,
                title: 'achievements'.tr,
                subtitle: 'achievements_sub'.tr,
                trailingInfo: 'achievements_new'.tr,
                trailingColor: Color(0xFF00796B),
                onTap: () {},
                isBadge: true,
              ),
            ]),
            CardHeaderText(
              title: 'section_preferences'.tr,
              isUrdu: controller.isUrdu,
            ),
            _buildSectionCard([
              _buildTile(
                icon: Icons.settings_outlined,
                title: 'settings'.tr,
                subtitle: 'settings_sub'.tr,
                onTap: () {
                  Get.toNamed(AppRoutes.SETTING_VIEW);
                },
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.translate,
                title: 'translation'.tr,
                subtitle: 'translation_sub'.tr,
                onTap: () => controller.showLanguageDialog(),
              ),
            ]),
            CardHeaderText(
              title: 'section_support'.tr,
              isUrdu: controller.isUrdu,
            ),
            _buildSectionCard([
              _buildTile(
                icon: Icons.help_outline,
                title: 'contact'.tr,
                subtitle: 'contact_sub'.tr,
                onTap: () {},
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.info_outline,
                title: 'about'.tr,
                subtitle: 'about_sub'.tr,
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () => Get.defaultDialog(
                title: "",
                contentPadding: const EdgeInsets.all(0),
                content: Container(
                  width: Get.mediaQuery.size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode
                        ? const Color(0xFF39374C)
                        : Colors.white,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "confirm_logout".tr,
                          textAlign: TextAlign.center,
                          style: Utils.getTextStyle(
                            baseSize: 14,
                            isBold: false,
                            color: Colors.black,
                            isUrdu: controller.isUrdu,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              "no".tr,
                              style: Utils.getTextStyle(
                                baseSize: 14,
                                isBold: true,
                                color: Colors.black,
                                isUrdu: controller.isUrdu,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => controller.appService.logOut(),
                            child: Text(
                              "yes".tr,
                              style: Utils.getTextStyle(
                                baseSize: 14,
                                isBold: true,
                                color: Colors.black,
                                isUrdu: controller.isUrdu,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                barrierDismissible: false,
                backgroundColor: Colors.transparent,
              ),
              icon: Icon(Icons.logout, size: 22),
              label: Text(
                'logout'.tr,
                style: Utils.getTextStyle(
                  baseSize: 16,
                  isBold: false,
                  color: Colors.red,
                  isUrdu: controller.isUrdu,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.red.withValues(alpha: 0.1),
                foregroundColor: Colors.red, // Text and Icon color
                side: BorderSide(color: Colors.red), // Border color
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Function onTap,
    String? trailingInfo,
    Color? trailingColor,
    bool isBadge = false,
  }) {
    return InkWell(
      onTap: () => onTap(),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 4.0,
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFF00796B).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Color(0xFF00796B), size: 22),
        ),
        title: Text(
          title,
          style: Utils.getTextStyle(
            baseSize: 15,
            isBold: true,
            color: Colors.black,
            isUrdu: controller.isUrdu,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Utils.getTextStyle(
            baseSize: 13,
            isBold: true,
            color: Colors.grey.shade500,
            isUrdu: controller.isUrdu,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingInfo != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  trailingInfo,
                  style: Utils.getTextStyle(
                    baseSize: 14,
                    isBold: true,
                    color: trailingColor ?? Colors.grey,
                    isUrdu: controller.isUrdu,
                  ),
                ),
              ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade200,
      indent: 0,
      endIndent: 0,
    );
  }
}
