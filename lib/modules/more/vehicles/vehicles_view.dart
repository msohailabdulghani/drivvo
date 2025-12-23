import 'package:drivvo/custom-widget/button/custom_floating_action_button.dart';
import 'package:drivvo/custom-widget/common/custom_app_bar.dart';
import 'package:drivvo/custom-widget/common/error_refresh_view.dart';
import 'package:drivvo/custom-widget/common/refresh_indicator_view.dart';
import 'package:drivvo/custom-widget/text-input-field/search_text_input_field.dart';
import 'package:drivvo/modules/more/vehicles/vehicles_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehiclesView extends GetView<VehiclesController> {
  const VehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () =>
            Get.toNamed(AppRoutes.CREATE_VEHICLES_VIEW, arguments: false)?.then(
              (e) {
                controller.getVehicleList();
              },
            ),
      ),
      appBar: CustomAppBar(
        name: "Vehicles",
        isUrdu: controller.isUrdu,
        bgColor: Utils.appColor,
        textColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Utils.appColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: SearchTextInputField(
                controller: controller.searchInputController,
                hintKey: "search_by_name",
                isUrdu: controller.isUrdu,
                fillColors: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Obx(
              () => Expanded(
                child: controller.isLoading.value
                    ? RefreshIndicatorView()
                    : controller.filterVehiclesList.isEmpty
                    ? ErrorRefreshView(
                        onRefresh: () => controller.getVehicleList(),
                      )
                    : ListView.builder(
                        itemCount: controller.filterVehiclesList.length,
                        itemBuilder: (context, index) {
                          final model = controller.filterVehiclesList[index];
                          return GestureDetector(
                            onTap: () {
                              controller.isFromHome.value
                                  ? controller.getBackToHome(vehicle: model)
                                  : null;
                            },
                            child: Container(
                              width: double.maxFinite,
                              margin: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 10,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/more/vehicle.png",
                                    height: 36,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.directions_car,
                                        size: 36,
                                      );
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          model.name,
                                          style: Utils.getTextStyle(
                                            baseSize: 15,
                                            isBold: true,
                                            color: Colors.black,
                                            isUrdu: controller.isUrdu,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                model.manufacturer,
                                                style: Utils.getTextStyle(
                                                  baseSize: 14,
                                                  isBold: false,
                                                  color: Colors.black,
                                                  isUrdu: controller.isUrdu,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              " ${model.year}",
                                              style: Utils.getTextStyle(
                                                baseSize: 14,
                                                isBold: true,
                                                color: Utils.appColor,
                                                isUrdu: controller.isUrdu,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
