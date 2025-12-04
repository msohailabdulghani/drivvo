import 'package:drivvo/modules/home/home_view.dart';
import 'package:drivvo/modules/quick-menu/quick_menu_view.dart';
import 'package:drivvo/modules/reminder/reminder_view.dart';
import 'package:drivvo/modules/reports/reports_view.dart';
import 'package:drivvo/modules/more/more_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RootController extends GetxController {
  final currentIndex = 0.obs;

  List<Widget> pages = [
    const HomeView(),
    const ReportsView(),
    const QuickMenuView(),
    const ReminderView(),
    const MoreView(),
  ];
  
  Widget get currentPage => pages[currentIndex.value];

  void changePageInRoot(int index) {
    currentIndex.value = index;
  }

}
