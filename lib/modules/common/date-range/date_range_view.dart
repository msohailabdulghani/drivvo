import 'package:drivvo/modules/common/date-range/date_range_controller.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateRangeView extends GetView<DateRangeController> {
  const DateRangeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                height: 200,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        "start_date".tr,
                        style: Utils.getTextStyle(
                          baseSize: 14,
                          isBold: true,
                          color: Colors.black,
                          isUrdu: controller.isUrdu,
                        ),
                      ),
                    ),
                    Expanded(
                      child: CupertinoDatePicker(
                        initialDateTime: controller.startDate,
                        mode: CupertinoDatePickerMode.date,
                        use24hFormat: true,
                        // This shows day of week alongside day of month
                        showDayOfWeek: true,
                        // This is called when the user changes the date.
                        onDateTimeChanged: (DateTime newDate) {
                          controller.startDate = newDate;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                height: 200,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        "end_date".tr,
                        style: Utils.getTextStyle(
                          baseSize: 14,
                          isBold: true,
                          color: Colors.black,
                          isUrdu: controller.isUrdu,
                        ),
                      ),
                    ),
                    Expanded(
                      child: CupertinoDatePicker(
                        initialDateTime: controller.endDate,
                        mode: CupertinoDatePickerMode.date,
                        use24hFormat: true,
                        // This shows day of week alongside day of month
                        showDayOfWeek: true,
                        // This is called when the user changes the date.
                        onDateTimeChanged: (DateTime newDate) {
                          controller.endDate = newDate;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "cancel".tr,
                      style: Utils.getTextStyle(
                        baseSize: 16,
                        isBold: false,
                        color: Colors.black,
                        isUrdu: controller.isUrdu,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.back(
                      result: {
                        "startDate": controller.startDate,
                        "endDate": controller.endDate,
                      },
                    ),
                    child: Text(
                      "save".tr,
                      style: Utils.getTextStyle(
                        baseSize: 16,
                        isBold: false,
                        color: Colors.black,
                        isUrdu: controller.isUrdu,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
