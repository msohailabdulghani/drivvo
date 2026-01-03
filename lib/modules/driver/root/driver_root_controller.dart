import 'package:drivvo/modules/driver/home/driver_home_view.dart';
import 'package:drivvo/modules/driver/more/driver_more_view.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverRootController extends GetxController {
  final currentIndex = 0.obs;
  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  List<Widget> pages = [const DriverHomeView(), const DriverMoreView()];

  Widget get currentPage => pages[currentIndex.value];

  void changePageInRoot(int index) {
    currentIndex.value = index;
  }
}
