import 'package:drivvo/modules/reminder/reminder_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ReminderView extends GetView<ReminderController> {
  const ReminderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Reminder")));
  }
}
