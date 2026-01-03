import 'package:drivvo/modules/admin/home/home_view.dart';
import 'package:drivvo/modules/admin/more/more_view.dart';
import 'package:drivvo/modules/admin/reminder/reminder_view.dart';
import 'package:drivvo/modules/admin/reports/reports_view.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminRootController extends GetxController {
  final currentIndex = 0.obs;
  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  List<Widget> pages = [
    const HomeView(),
    const ReportsView(),
    const ReminderView(),
    const MoreView(),
  ];

  Widget get currentPage => pages[currentIndex.value];

  void changePageInRoot(int index) {
    currentIndex.value = index;
  }
}
