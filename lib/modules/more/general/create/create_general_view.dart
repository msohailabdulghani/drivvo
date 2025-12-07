import 'package:drivvo/custom-widget/common/custom_app_bar.dart';
import 'package:drivvo/modules/more/general/create/create_general_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateGeneralView extends GetView<CreateGeneralController> {
  const CreateGeneralView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        name: "Add new Vehicle",
        isUrdu: controller.isUrdu,
        bgColor: const Color(0xFF047772),
        textColor: Colors.white,
        centerTitle: true,
        showBackBtn: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: []),
      ),
    );
  }
}
