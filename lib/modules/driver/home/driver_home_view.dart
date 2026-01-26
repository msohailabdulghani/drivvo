import 'package:drivvo/custom-widget/home/add_item_card.dart';
import 'package:drivvo/custom-widget/home/home_appbar.dart';
import 'package:drivvo/custom-widget/home/home_list_items.dart';
import 'package:drivvo/custom-widget/home/home_ready_to_start_card.dart';
import 'package:drivvo/custom-widget/home/home_welcome_item.dart';
import 'package:drivvo/modules/driver/home/driver_home_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/services/ads_service.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverHomeView extends GetView<DriverHomeController> {
  const DriverHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openBottomSheet(context),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF00796B),
        shape: const StadiumBorder(),
        icon: const Icon(Icons.add),
        label: Text(
          "log_now".tr,
          style: Utils.getTextStyle(
            baseSize: 14,
            isBold: true,
            color: Colors.white,
            isUrdu: controller.isUrdu,
          ),
        ),
      ),
      // floatingActionButton: HomeAddBtn(
      //   circularMenuKey: controller.circularMenuKey,
      //   onTapRefueling: () {
      //     controller.circularMenuKey.currentState?.reverseAnimation();
      //     controller.checkVehicleAndNavigate(
      //       routeName: AppRoutes.CREATE_REFUELING_VIEW,
      //     );
      //   },
      //   onTapExpense: () {
      //     controller.circularMenuKey.currentState?.reverseAnimation();
      //     controller.checkVehicleAndNavigate(
      //       routeName: AppRoutes.CREATE_EXPENSE_VIEW,
      //     );
      //   },
      //   onTapService: () {
      //     controller.circularMenuKey.currentState?.reverseAnimation();
      //     controller.checkVehicleAndNavigate(
      //       routeName: AppRoutes.CRAETE_SERVICE_VIEW,
      //     );
      //   },
      //   onTapIncome: () {
      //     controller.circularMenuKey.currentState?.reverseAnimation();
      //     controller.checkVehicleAndNavigate(
      //       routeName: AppRoutes.CRAETE_INCOME_VIEW,
      //     );
      //   },
      //   onTapRoute: () {
      //     controller.circularMenuKey.currentState?.reverseAnimation();
      //     controller.checkVehicleAndNavigate(
      //       routeName: AppRoutes.CRAETE_ROUTE_VIEW,
      //     );
      //   },
      // ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // Sliver Header
          Obx(
            () => HomeAppbar(
              isUrdu: controller.isUrdu,
              isAdmin: false,
              isSubscribed: controller.appService.appUser.value.isSubscribed,
              logoUrl: controller.appService.driverVehicleModel.value.logoUrl,
              hasActiveFilter: controller.hasActiveFilter,
              disabledFilterCount: controller.disabledFilterCount,
              currentVehicleId:
                  controller.appService.driverCurrentVehicleId.value,
              currentVehicle:
                  controller.appService.driverVehicleModel.value.name,
              lastOdometer:
                  controller.appService.driverVehicleModel.value.lastOdometer,
            ),
          ),

          // Content Section
          SliverToBoxAdapter(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  controller.allEntries.isEmpty
                      // Ready to Start Section
                      ? HomeReadyToStartCard(
                          isUrdu: controller.isUrdu,
                          initialSelection: controller.initialSelection.value,
                          onTap: (label) {
                            if (controller
                                .appService
                                .driverCurrentVehicleId
                                .value
                                .isEmpty) {
                              Utils.showSnackBar(
                                message: "vehicle_must_be_selected_first".tr,
                                success: false,
                              );
                              return;
                            }

                            controller.initialSelection.value = label;
                            if (label == "Fuel") {
                              Get.toNamed(AppRoutes.CREATE_REFUELING_VIEW);
                            } else if (label == "Service") {
                              Get.toNamed(AppRoutes.CRAETE_SERVICE_VIEW);
                            } else if (label == "Expense") {
                              Get.toNamed(AppRoutes.CREATE_EXPENSE_VIEW);
                            }
                          },
                        )
                      : HomeListItems(
                          isUrdu: controller.isUrdu,
                          isLoading: controller.isLoading.value,
                          onTapRefresh: () => controller.refreshData(),
                          allEntries: controller.allEntries,
                          groupedEntries: controller.groupedEntries,
                          isEntryExpanded: (entryKey) =>
                              controller.isEntryExpanded(entryKey),
                          toggleEntryExpansion: (entryKey) =>
                              controller.toggleEntryExpansion(entryKey),
                          selectedCurrencySymbol: controller
                              .appService
                              .selectedCurrencySymbol
                              .value,
                          onTapEdit: (model) => controller.editEntry(model),
                          onTapdelete: (model) => controller.deleteEntry(model),
                          loadAds: AdsService.isNativeAdLoaded.value,
                          isAdminSubscribed:
                              controller.appService.isAdminSubscribed.value,
                        ),

                  HomeWelcomeItem(
                    isUrdu: controller.isUrdu,
                    accountCreatedDate: controller.accountCreatedDate,
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        final safeBottom = MediaQuery.of(context).padding.bottom;
        return Padding(
          padding: EdgeInsets.only(
            bottom: bottomInset > 0 ? bottomInset : safeBottom,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            width: double.maxFinite,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(46),
                topRight: Radius.circular(46),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "log_now".tr,
                        style: Utils.getTextStyle(
                          baseSize: 16,
                          isBold: true,
                          color: Colors.black,
                          isUrdu: controller.isUrdu,
                        ),
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
                AddItemCard(
                  isUrdu: controller.isUrdu,
                  title: "refueling",
                  color: const Color(0xFFFB9601),
                  icon: Icons.local_gas_station_outlined,
                  onTap: () {
                    controller.checkVehicleAndNavigate(
                      routeName: AppRoutes.CREATE_REFUELING_VIEW,
                    );
                  },
                ),
                AddItemCard(
                  isUrdu: controller.isUrdu,
                  title: "expense",
                  color: Colors.red,
                  icon: Icons.receipt_long_outlined,
                  onTap: () {
                    controller.checkVehicleAndNavigate(
                      routeName: AppRoutes.CREATE_EXPENSE_VIEW,
                    );
                  },
                ),
                AddItemCard(
                  isUrdu: controller.isUrdu,
                  title: "service",
                  color: Colors.brown,
                  icon: Icons.build_outlined,
                  onTap: () {
                    controller.checkVehicleAndNavigate(
                      routeName: AppRoutes.CRAETE_SERVICE_VIEW,
                    );
                  },
                ),
                AddItemCard(
                  isUrdu: controller.isUrdu,
                  title: "income",
                  color: Colors.green,
                  icon: Icons.attach_money,
                  onTap: () {
                    controller.checkVehicleAndNavigate(
                      routeName: AppRoutes.CRAETE_INCOME_VIEW,
                    );
                  },
                ),
                AddItemCard(
                  isUrdu: controller.isUrdu,
                  title: "route",
                  color: const Color(0xFF5E7E8D),
                  icon: Icons.route_outlined,
                  onTap: () {
                    controller.checkVehicleAndNavigate(
                      routeName: AppRoutes.CRAETE_ROUTE_VIEW,
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
