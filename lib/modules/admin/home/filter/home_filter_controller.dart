import 'package:drivvo/model/date_range_model.dart';
import 'package:drivvo/modules/admin/home/home_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  late AppService appService;

  var checklist = true.obs;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();
    if (appService.selectedDateRange.value != null) {
      selectedDateIndex.value = appService.selectedDateRange.value!.id;
      customDate.value = appService.selectedDateRange.value!.dateString;
    } else if (dateRangeList.isNotEmpty) {
      final model = dateRangeList.first;
      selectedDateIndex.value = model.id;
      customDate.value = model.dateString;
      appService.selectedDateRange.value = model;
    }
  }

  // Expanded options state
  var moreOptionsExpanded = false.obs;

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  final selectedDateIndex = 0.obs;
  final customDate = "".obs;
  final dateRangeList = Utils.getDateRangeList(
    titles: [
      "this_week",
      "this_month",
      "last_month",
      "last_6_months",
      "this_year",
      "last_year",
      "custom_date",
    ],
  );

  void toggleMoreOptions() {
    moreOptionsExpanded.value = !moreOptionsExpanded.value;
  }

  void getBackToMain() {
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().loadTimelineData();
    }
    Get.back();
  }

  void onSelectDateRange(DateRangeModel model) {
    // if (model.id == 6) {
    if (model.title == "custom_date") {
      final lastSelectDate = dateRangeList[selectedDateIndex.value];
      Get.toNamed(
        AppRoutes.DATE_RANGE,
        arguments: {
          "startDate": lastSelectDate.startDate ?? DateTime.now(),
          "endDate": lastSelectDate.endDate ?? DateTime.now(),
        },
      )?.then((result) {
        if (result != null) {
          DateTime fromDate = result["startDate"];
          DateTime toDate = result["endDate"];
          model.startDate = fromDate;
          model.endDate = toDate;
          model.dateString =
              "${Utils.formatDate(date: fromDate)} ${"to".tr} ${Utils.formatDate(date: toDate)}";
          selectedDateIndex.value = model.id;
          customDate.value =
              "${Utils.formatDate(date: fromDate)} ${"to".tr} ${Utils.formatDate(date: toDate)}";
          appService.selectedDateRange.value = model;
          if (Get.isRegistered<HomeController>()) {
            Get.find<HomeController>().loadTimelineData();
          }
        }
      });
    } else {
      customDate.value = model.dateString;
      // "${Utils.formatDate(date: model.startDate)} ${"to".tr} ${Utils.formatDate(date: model.endDate)}";
      selectedDateIndex.value = model.id;
      appService.selectedDateRange.value = model;
      Future.delayed(Duration.zero, () {
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().loadTimelineData();
        }
      });
    }
  }
}
