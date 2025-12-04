import 'package:drivvo/modules/reports/reports_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Reports")));
  }
}
