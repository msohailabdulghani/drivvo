import 'package:drivvo/modules/quick-menu/quick_menu_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class QuickMenuView extends GetView<QuickMenuController> {
  const QuickMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Quick Menu")));
  }
}
