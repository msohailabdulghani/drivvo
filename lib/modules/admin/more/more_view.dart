import 'package:drivvo/custom-widget/button/custom_outline_button.dart';
import 'package:drivvo/custom-widget/common/card_header_text.dart';
import 'package:drivvo/modules/admin/more/more_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/common_function.dart';
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
        backgroundColor: Utils.appColor,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "more_options".tr,
          style: Utils.getTextStyle(
            baseSize: 20,
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
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          children: [
            CardHeaderText(
              title: 'section_account_data'.tr,
              isUrdu: controller.isUrdu,
              color: Utils.appColor,
            ),
            _buildSectionCard([
              Obx(
                () => _buildTile(
                  imagePath: "assets/images/more/plan.png",
                  title: 'premium_plans'.tr,
                  subtitle: controller.appService.appUser.value.isSubscribed
                      ? 'manage_your_subscription'.tr
                      : 'premium_plans_sub'.tr,
                  showPro: true,
                  onTap: () => controller.onPremiumPlanTap(),
                ),
              ),
              _buildDivider(),
              _buildTile(
                imagePath: "assets/images/more/account.png",
                title: 'my_account'.tr,
                subtitle: 'my_account_sub'.tr,
                onTap: () => Get.toNamed(AppRoutes.UPDATE_PROFILE_VIEW),
              ),
              _buildDivider(),
              _buildTile(
                imagePath: "assets/images/more/syncronize_data.png",
                title: 'import_export_data'.tr,
                subtitle: 'import_export_data_sub'.tr,
                onTap: () {
                  // if (controller.appService.appUser.value.isSubscribed) {
                  //   Get.toNamed(AppRoutes.IMPORT_DATA_VIEW, arguments: true);
                  // } else {
                  //   Get.toNamed(AppRoutes.PLAN_VIEW);
                  // }

                  Get.toNamed(AppRoutes.IMPORT_DATA_VIEW, arguments: true);
                },
              ),
              // _buildDivider(),
              // _buildTile(
              //   imagePath: "assets/images/more/storage.png",
              //   title: 'storage'.tr,
              //   subtitle: 'storage_sub'.tr,
              //   trailingInfo: '85%',
              //   trailingColor: Color(0xFF00796B),
              //   onTap: () {},
              // ),
              // _buildDivider(),
              // _buildTile(
              //   imagePath: "assets/images/more/transfer.png",
              //   title: 'transfer'.tr,
              //   subtitle: 'transfer_sub'.tr,
              //   onTap: () {
              //     if (controller.appService.appUser.value.isSubscribed) {
              //       return null;
              //     } else {
              //       Get.toNamed(AppRoutes.PLAN_VIEW);
              //     }
              //   },
              // ),
            ]),
            CardHeaderText(
              title: 'section_vehicles'.tr,
              isUrdu: controller.isUrdu,
              color: Utils.appColor,
            ),
            _buildSectionCard([
              Obx(
                () => _buildTile(
                  imagePath: "assets/images/more/vehicle.png",
                  title: 'my_vehicles'.tr,
                  subtitle: controller.appService.allVehiclesCount.value > 1
                      ? '${controller.appService.allVehiclesCount.value} ${"vehicles_registered".tr}'
                      : '${controller.appService.allVehiclesCount.value} ${"vehicle_registered".tr}',
                  onTap: () => Get.toNamed(
                    AppRoutes.VEHICLES_VIEW,
                    arguments: {"is_from_home": false, "is_from_user": false},
                  ),
                ),
              ),
              _buildDivider(),
              _buildTile(
                imagePath: "assets/images/more/users.png",
                title: 'users'.tr,
                subtitle: 'users_sub'.tr,
                onTap: () {
                  Get.toNamed(AppRoutes.USER_VIEW, arguments: "");
                },
              ),
              _buildDivider(),
              _buildTile(
                imagePath: "assets/images/more/vehicle_user.png",
                title: 'vehicle_user'.tr,
                subtitle: 'vehicle_user_sub'.tr,
                onTap: () {
                  Get.toNamed(AppRoutes.USER_VEHICLE_VIEW);
                },
              ),
            ]),
            CardHeaderText(
              title: 'section_tracking'.tr,
              isUrdu: controller.isUrdu,
              color: Utils.appColor,
            ),
            _buildSectionCard([
              _buildTile(
                imagePath: "assets/images/more/fuel.png",
                title: 'fuel'.tr,
                subtitle: 'fuel_sub'.tr,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: {"title": Constants.FUEL, "selected_title": ""},
                  );
                },
              ),
              _buildDivider(),
              _buildTile(
                imagePath: "assets/images/more/gas_station.png",
                title: 'gas_stations'.tr,
                subtitle: 'gas_stations_sub'.tr,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: {
                      "title": Constants.GAS_STATIONS,
                      "selected_title": "",
                    },
                  );
                },
              ),
              _buildDivider(),
              _buildTile(
                imagePath: "assets/images/more/places.png",
                title: 'places'.tr,
                subtitle: 'places_sub'.tr,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: {
                      "title": Constants.PLACES,
                      "selected_title": "",
                    },
                  );
                },
              ),
            ]),
            CardHeaderText(
              title: 'section_financial'.tr,
              isUrdu: controller.isUrdu,
              color: Utils.appColor,
            ),
            _buildSectionCard([
              _buildTile(
                imagePath: "assets/images/more/expenses.png",
                title: 'types_expense'.tr,
                subtitle: 'types_expense_sub'.tr,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: {
                      "title": Constants.EXPENSE_TYPES,
                      "selected_title": "",
                    },
                  );
                },
              ),
              _buildDivider(),
              _buildTile(
                imagePath: "assets/images/more/income.png",
                title: 'types_income'.tr,
                subtitle: 'types_income_sub'.tr,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: {
                      "title": Constants.INCOME_TYPES,
                      "selected_title": "",
                    },
                  );
                },
              ),
              _buildDivider(),
              _buildTile(
                imagePath: "assets/images/more/services.png",
                title: 'types_service'.tr,
                subtitle: 'types_service_sub'.tr,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: {
                      "title": Constants.SERVICE_TYPES,
                      "selected_title": "",
                    },
                  );
                },
              ),
              _buildDivider(),
              _buildTile(
                imagePath: "assets/images/more/payment_method.png",
                title: 'payment_methods'.tr,
                subtitle: 'payment_methods_sub'.tr,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: {
                      "title": Constants.PAYMENT_METHOD,
                      "selected_title": "",
                    },
                  );
                },
              ),
              _buildDivider(),
              _buildTile(
                imagePath: "assets/images/more/reason.png",
                title: 'reasons'.tr,
                subtitle: 'reasons_sub'.tr,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.GENERAL_VIEW,
                    arguments: {
                      "title": Constants.REASONS,
                      "selected_title": "",
                    },
                  );
                },
              ),
            ]),
            // CardHeaderText(
            //   title: 'section_tools'.tr,
            //   isUrdu: controller.isUrdu,
            //   color: Utils.appColor,
            // ),
            // _buildSectionCard([
            // _buildTile(
            //   imagePath: "assets/images/more/form.png",
            //   title: 'forms'.tr,
            //   subtitle: 'forms_sub'.tr,
            //   onTap: () {},
            // ),
            // _buildDivider(),
            // _buildTile(
            //   imagePath: "assets/images/more/my_places.png",
            //   title: 'my_places'.tr,
            //   subtitle: 'my_places_sub'.tr,
            //   onTap: () {},
            // ),
            // _buildDivider(),
            // _buildTile(
            //   imagePath: "assets/images/more/calculater.png",
            //   title: 'flex_calculator'.tr,
            //   subtitle: 'flex_calculator_sub'.tr,
            //   onTap: () {},
            // ),
            // _buildDivider(),
            // _buildTile(
            //   imagePath: "assets/images/more/achievements.png",
            //   title: 'achievements'.tr,
            //   subtitle: 'achievements_sub'.tr,
            //   trailingInfo: 'achievements_new'.tr,
            //   trailingColor: Color(0xFF00796B),
            //   onTap: () {},
            //   isBadge: true,
            // ),
            // ]),
            CardHeaderText(
              title: 'section_preferences'.tr,
              isUrdu: controller.isUrdu,
              color: Utils.appColor,
            ),
            _buildSectionCard([
              _buildTile(
                imagePath: "assets/images/more/setting.png",
                title: 'settings'.tr,
                subtitle: 'settings_sub'.tr,
                onTap: () {
                  Get.toNamed(AppRoutes.SETTING_VIEW);
                },
              ),
              _buildDivider(),
              _buildTile(
                imagePath: "assets/images/more/translation.png",
                title: 'translation'.tr,
                subtitle: 'translation_sub'.tr,
                onTap: () => controller.showLanguageDialog(),
              ),
            ]),
            CardHeaderText(
              title: 'section_support'.tr,
              isUrdu: controller.isUrdu,
              color: Utils.appColor,
            ),
            _buildSectionCard([
              _buildTile(
                imagePath: "assets/images/more/contact.png",
                title: 'contact'.tr,
                subtitle: 'contact_sub'.tr,
                onTap: () {
                  CommonFunction.sendMail();
                },
              ),
              _buildDivider(),
              _buildTile(
                imagePath: "assets/images/more/about.png",
                title: 'about'.tr,
                subtitle: 'about_sub'.tr,
                onTap: () {
                  Get.toNamed(AppRoutes.ABOUT_US_VIEW);
                },
              ),
            ]),
            const SizedBox(height: 20),
            CustomOutlineButton(
              title: 'logout'.tr,
              icon: Icons.logout,
              isUrdu: controller.isUrdu,
              btnColor: Colors.red,
              onTap: () => Get.defaultDialog(
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
    required String imagePath,
    required String title,
    required String subtitle,
    required Function onTap,
    String? trailingInfo,
    bool? showPro,
    Color? trailingColor,
    // bool isBadge = false,
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
          // child: Icon(icon, color: Color(0xFF00796B), size: 22),
          child: Image.asset(imagePath),
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
            if (showPro != null)
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Utils.appColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.workspace_premium,
                      size: 18,
                      color: Utils.appColor,
                    ),
                    SizedBox(width: 4),
                    Text(
                      controller.appService.appUser.value.isSubscribed
                          ? 'pro'.tr
                          : 'get_pro'.tr,
                      style: Utils.getTextStyle(
                        baseSize: 12,
                        isBold: true,
                        color: Utils.appColor,
                        isUrdu: controller.isUrdu,
                      ),
                    ),
                  ],
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
