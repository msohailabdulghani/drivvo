import 'package:drivvo/custom-widget/common/custom_app_bar.dart';
import 'package:drivvo/modules/reminder/reminder_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ReminderView extends GetView<ReminderController> {
  const ReminderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF00796B),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: CustomAppBar(name: "reminders".tr, isUrdu: controller.isUrdu),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/reminders.png",
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text("Add your first", style: TextStyle(fontSize: 16)),
            Text("Reminder", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
