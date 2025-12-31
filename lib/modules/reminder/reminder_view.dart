import 'package:drivvo/custom-widget/common/refresh_indicator_view.dart';
import 'package:drivvo/modules/reminder/reminder_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReminderView extends GetView<ReminderController> {
  const ReminderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.CREATE_REMINDER_VIEW),
        shape: const CircleBorder(),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF00796B),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: Utils.appColor,
        elevation: 0,
        title: Text(
          'reminders'.tr,
          style: Utils.getTextStyle(
            baseSize: 18,
            isBold: true,
            color: Colors.white,
            isUrdu: controller.isUrdu,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? Center(child: RefreshIndicatorView())
              : controller.reminderList.isEmpty
              ? Center(
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
                      Text("add_your_first".tr, style: TextStyle(fontSize: 16)),
                      Text("reminder".tr, style: TextStyle(fontSize: 16)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(bottom: 66, top: 20),
                  itemCount: controller.reminderList.length,
                  itemBuilder: (context, index) {
                    final model = controller.reminderList[index];
                    final distance = controller.getDistance(model);
                    final days = controller.getDays(model.startDate);
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.UPDATE_REMINDER_VIEW,
                          arguments: model,
                        );
                      },
                      child: Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 10,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: model.type == "expense"
                              ? Border.all(color: Colors.red)
                              : Border.all(color: Colors.brown),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.subType,
                              style: Utils.getTextStyle(
                                baseSize: 16,
                                isBold: false,
                                color: Colors.black,
                                isUrdu: controller.isUrdu,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.format_list_numbered,
                                      size: 14,
                                      color: Colors.black54,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "${model.odometer} km",
                                      style: Utils.getTextStyle(
                                        baseSize: 14,
                                        isBold: false,
                                        color: Colors.black54,
                                        isUrdu: controller.isUrdu,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  distance > 0
                                      ? "in $distance km"
                                      : "${distance.abs().toString()} km ago",
                                  style: Utils.getTextStyle(
                                    baseSize: 14,
                                    isBold: false,
                                    color: distance > 0
                                        ? Colors.green
                                        : Colors.red,
                                    isUrdu: controller.isUrdu,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Utils.formatDate(date: model.startDate),
                                  style: Utils.getTextStyle(
                                    baseSize: 14,
                                    isBold: false,
                                    color: Colors.grey.shade700,
                                    isUrdu: controller.isUrdu,
                                  ),
                                ),
                                Text(
                                  days == 0
                                      ? "today".tr
                                      : days == 1
                                      ? "tomorrow".tr
                                      : "in $days".tr,
                                  style: Utils.getTextStyle(
                                    baseSize: 14,
                                    isBold: false,
                                    color: days == 0 || days == 1
                                        ? Colors.green
                                        : Colors.grey.shade700,
                                    isUrdu: controller.isUrdu,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
