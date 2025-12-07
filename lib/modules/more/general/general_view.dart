import 'package:drivvo/custom-widget/button/custom_floating_action_button.dart';
import 'package:drivvo/custom-widget/common/custom_app_bar.dart';
import 'package:drivvo/modules/more/general/general_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GeneralView extends GetView<GeneralController> {
  const GeneralView({super.key});

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
      body: SafeArea(child: Column(children: [
              ],
          )),
    );
  }
}
