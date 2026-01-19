import 'package:drivvo/custom-widget/home/home_appbar.dart';
import 'package:drivvo/custom-widget/home/home_list_items.dart';
import 'package:drivvo/custom-widget/home/home_next_refueling_card.dart';
import 'package:drivvo/custom-widget/home/home_ready_to_start_card.dart';
import 'package:drivvo/custom-widget/home/home_welcome_item.dart';
import 'package:drivvo/modules/admin/home/home_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/common_function.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

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
              isAdmin: true,
              isSubscribed: controller.appService.appUser.value.isSubscribed,
              logoUrl: controller.appService.vehicleModel.value.logoUrl,
              hasActiveFilter: controller.hasActiveFilter,
              disabledFilterCount: controller.disabledFilterCount,
              currentVehicleId: controller.appService.currentVehicleId.value,
              currentVehicle: controller.appService.vehicleModel.value.name,
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
                              final String vehicleId =
                                  controller.appService.currentVehicleId.value;
                              if (vehicleId.isEmpty) {
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
                        : Column(
                            children: [
                              if (controller.nextRefuelingOdometer.value >
                                  0) ...[
                                const SizedBox(height: 16),
                                // Prediction Card
                                HomeNextRefuelingCard(
                                  isUrdu: controller.isUrdu,
                                  nextRefuelingOdometer:
                                      controller.nextRefuelingOdometer.value,
                                  nextRefuelingDate:
                                      controller.nextRefuelingDate.value,
                                  avgConsumption:
                                      controller.avgConsumption.value,
                                  distanceUnit: controller
                                      .appService
                                      .vehicleModel
                                      .value
                                      .distanceUnit,
                                ),
                              ],
                              HomeListItems(
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
                                onTapEdit: (model) =>
                                    controller.editEntry(model),
                                onTapdelete: (model) =>
                                    controller.deleteEntry(model),
                              ),
                            ],
                          ),

                    HomeWelcomeItem(
                      isUrdu: controller.isUrdu,
                      accountCreatedDate: CommonFunction.accountCreatedDate(),
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
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: InkWell(
                  onTap: () {
                    controller.checkVehicleAndNavigate(
                      routeName: AppRoutes.CREATE_REFUELING_VIEW,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFB9601),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Icon(
                          Icons.local_gas_station_outlined,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 14),
                      Text(
                        "refueling".tr,
                        style: Utils.getTextStyle(
                          baseSize: 16,
                          isBold: false,
                          color: Colors.black,
                          isUrdu: controller.isUrdu,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: InkWell(
                  onTap: () {
                    controller.checkVehicleAndNavigate(
                      routeName: AppRoutes.CREATE_EXPENSE_VIEW,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Icon(
                          Icons.receipt_long_outlined,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 14),
                      Text(
                        "expense".tr,
                        style: Utils.getTextStyle(
                          baseSize: 16,
                          isBold: false,
                          color: Colors.black,
                          isUrdu: controller.isUrdu,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: InkWell(
                  onTap: () {
                    controller.checkVehicleAndNavigate(
                      routeName: AppRoutes.CRAETE_SERVICE_VIEW,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Icon(Icons.build_outlined, color: Colors.white),
                      ),
                      SizedBox(width: 14),
                      Text(
                        "service".tr,
                        style: Utils.getTextStyle(
                          baseSize: 16,
                          isBold: false,
                          color: Colors.black,
                          isUrdu: controller.isUrdu,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: InkWell(
                  onTap: () {
                    controller.checkVehicleAndNavigate(
                      routeName: AppRoutes.CRAETE_INCOME_VIEW,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Icon(Icons.attach_money, color: Colors.white),
                      ),
                      SizedBox(width: 14),
                      Text(
                        "income".tr,
                        style: Utils.getTextStyle(
                          baseSize: 16,
                          isBold: false,
                          color: Colors.black,
                          isUrdu: controller.isUrdu,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: InkWell(
                  onTap: () {
                    controller.checkVehicleAndNavigate(
                      routeName: AppRoutes.CRAETE_ROUTE_VIEW,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5E7E8D),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Icon(Icons.route, color: Colors.white),
                      ),
                      SizedBox(width: 14),
                      Text(
                        "route".tr,
                        style: Utils.getTextStyle(
                          baseSize: 16,
                          isBold: false,
                          color: Colors.black,
                          isUrdu: controller.isUrdu,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
