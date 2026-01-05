import 'package:drivvo/custom-widget/home/home_add_btn.dart';
import 'package:drivvo/custom-widget/home/home_appbar.dart';
import 'package:drivvo/custom-widget/home/home_list_items.dart';
import 'package:drivvo/custom-widget/home/home_ready_to_start_card.dart';
import 'package:drivvo/custom-widget/home/home_welcome_item.dart';
import 'package:drivvo/modules/driver/home/driver_home_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverHomeView extends GetView<DriverHomeController> {
  const DriverHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: HomeAddBtn(
        circularMenuKey: controller.circularMenuKey,
        onTapRefueling: () {
          controller.circularMenuKey.currentState?.reverseAnimation();
          controller.checkVehicleAndNavigate(
            routeName: AppRoutes.CREATE_REFUELING_VIEW,
          );
        },
        onTapExpense: () {
          controller.circularMenuKey.currentState?.reverseAnimation();
          controller.checkVehicleAndNavigate(
            routeName: AppRoutes.CREATE_EXPENSE_VIEW,
          );
        },
        onTapService: () {
          controller.circularMenuKey.currentState?.reverseAnimation();
          controller.checkVehicleAndNavigate(
            routeName: AppRoutes.CRAETE_SERVICE_VIEW,
          );
        },
        onTapIncome: () {
          controller.circularMenuKey.currentState?.reverseAnimation();
          controller.checkVehicleAndNavigate(
            routeName: AppRoutes.CRAETE_INCOME_VIEW,
          );
        },
        onTapRoute: () {
          controller.circularMenuKey.currentState?.reverseAnimation();
          controller.checkVehicleAndNavigate(
            routeName: AppRoutes.CRAETE_ROUTE_VIEW,
          );
        },
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // Sliver Header
          Obx(
            () => HomeAppbar(
              isUrdu: controller.isUrdu,
              hasActiveFilter: controller.hasActiveFilter,
              disabledFilterCount: controller.disabledFilterCount,
              currentVehicleId: controller.appService.currentVehicleId.value,
              currentVehicle: controller.appService.currentVehicle.value,
              lastOdometer:
                  controller.appService.vehicleModel.value.lastOdometer,
            ),
          ),

          // Content Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                  .currentVehicleId
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
                            onTapdelete: (model) =>
                                controller.deleteEntry(model),
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
          ),
        ],
      ),
    );
  }
}
