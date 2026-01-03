import 'package:drivvo/custom-widget/common/error_refresh_view.dart';
import 'package:drivvo/custom-widget/common/refresh_indicator_view.dart';
import 'package:drivvo/custom-widget/text-input-field/search_text_input_field.dart';
import 'package:drivvo/modules/more/user-vehicle/user_vehicle_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserVehicleView extends GetView<UserVehicleController> {
  const UserVehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.CREATE_USER_VEHICLE_VIEW),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF00796B),
        shape: const StadiumBorder(),
        icon: const Icon(Icons.add),
        label: Text(
          "add_user_vehicle".tr,
          style: Utils.getTextStyle(
            baseSize: 14,
            isBold: true,
            color: Colors.white,
            isUrdu: controller.isUrdu,
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Utils.appColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'user_vehicles'.tr,
          style: Utils.getTextStyle(
            baseSize: 18,
            isBold: true,
            color: Colors.white,
            isUrdu: controller.isUrdu,
          ),
        ),
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
            const SizedBox(height: 20),
            Obx(
              () => Expanded(
                child: controller.isLoading.value
                    ? const RefreshIndicatorView()
                    : controller.filterVehiclesList.isEmpty
                    ? ErrorRefreshView(
                        onRefresh: () => controller.getVehicleList(),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: controller.filterVehiclesList.length,
                        itemBuilder: (context, index) {
                          final model = controller.filterVehiclesList[index];
                          return GestureDetector(
                            onTap: () => Get.toNamed(
                              AppRoutes.UPDATE_USER_VEHICLE_VIEW,
                              arguments: model,
                            ),
                            child: Container(
                              width: double.maxFinite,
                              margin: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 10,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${"start_date:".tr} ${Utils.formatDate(date: model.startDate)}",
                                          style: Utils.getTextStyle(
                                            baseSize: 14,
                                            isBold: false,
                                            color: Colors.black,
                                            isUrdu: controller.isUrdu,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person,
                                              color: Utils.appColor,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "${model.user.firstName} ${model.user.lastName}",
                                              style: Utils.getTextStyle(
                                                baseSize: 16,
                                                isBold: false,
                                                color: Colors.black,
                                                isUrdu: controller.isUrdu,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              _getVehicleIcon(
                                                model.vehicle.vehicleType,
                                              ),
                                              color: Utils.appColor,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              model.vehicle.name,
                                              style: Utils.getTextStyle(
                                                baseSize: 16,
                                                isBold: true,
                                                color: Colors.black,
                                                isUrdu: controller.isUrdu,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${model.vehicle.manufacturer} • ${model.vehicle.modelYear}",
                                              style: Utils.getTextStyle(
                                                baseSize: 14,
                                                isBold: false,
                                                color: Colors.black54,
                                                isUrdu: controller.isUrdu,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () => Utils.showAlertDialog(
                                      confirmMsg: "are_you_sure_delete".tr,
                                      onTapYes: () {},
                                      isUrdu: controller.isUrdu,
                                    ),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
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

  IconData _getVehicleIcon(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'car':
        return Icons.directions_car;
      case 'motorcycle':
        return Icons.two_wheeler;
      case 'truck':
        return Icons.local_shipping;
      case 'bus':
        return Icons.directions_bus;
      case 'bicycle':
        return Icons.pedal_bike;
      default:
        return Icons.directions_car;
    }
  }
}
