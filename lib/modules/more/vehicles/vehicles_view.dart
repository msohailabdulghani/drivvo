import 'package:drivvo/custom-widget/button/custom_floating_action_button.dart';
import 'package:drivvo/custom-widget/common/custom_app_bar.dart';
import 'package:drivvo/custom-widget/common/error_refresh_view.dart';
import 'package:drivvo/custom-widget/common/refresh_indicator_view.dart';
import 'package:drivvo/custom-widget/text-input-field/search_text_input_field.dart';
import 'package:drivvo/modules/more/vehicles/vehicles_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehiclesView extends GetView<VehiclesController> {
  const VehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.CREATE_VEHICLES_VIEW),
      ),
      appBar: CustomAppBar(
        name: "Vehicles",
        isUrdu: controller.isUrdu,
        bgColor: const Color(0xFF047772),
        textColor: Colors.white,
        centerTitle: true,
        showBackBtn: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            SearchTextInputField(
              controller: controller.searchInputController,
              hintKey: "search",
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
                            onTap: () {},
                            child: Container(
                              width: double.maxFinite,
                              margin: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 10,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text(model.name)],
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
