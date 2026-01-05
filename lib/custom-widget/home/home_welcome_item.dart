import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class HomeWelcomeItem extends StatelessWidget {
  final bool isUrdu;
  final DateTime accountCreatedDate;

  const HomeWelcomeItem({
    super.key,
    required this.isUrdu,
    required this.accountCreatedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Timeline Line and Star
              SizedBox(
                width: 44,
                child: Column(
                  children: [
                    // Top line
                    Container(
                      width: 3,
                      height: 20,
                      color: const Color(0xFF424242),
                    ),
                    // Star Icon
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFB74D),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                    // Bottom line
                    Expanded(
                      child: Container(
                        width: 3,
                        color: const Color(0xFF424242),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, top: 12, bottom: 8),
                  child: Row(
                    children: [
                      // Check Icon
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Utils.appColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Text
                      Expanded(
                        child: Text(
                          'started_monitoring_your_vehicle'.tr,
                          style: Utils.getTextStyle(
                            baseSize: 13,
                            isBold: false,
                            color: Colors.grey[600]!,
                            isUrdu: isUrdu,
                          ),
                        ),
                      ),
                      // Date
                      Text(
                        Utils.formatAccountDate(accountCreatedDate),
                        textDirection: TextDirection.ltr,
                        style: Utils.getTextStyle(
                          baseSize: 12,
                          isBold: false,
                          color: Colors.grey[500]!,
                          isUrdu: isUrdu,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Timeline Line and End
              SizedBox(
                width: 44,
                child: Column(
                  children: [
                    // Top line
                    Container(
                      width: 3,
                      height: 20,
                      color: const Color(0xFF424242),
                    ),
                    // End circle
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Utils.appColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: Utils.appColor, width: 2),
                      ),
                      child: const Icon(
                        Icons.local_gas_station,
                        color: Utils.appColor,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
              // Content - Welcome to Drivvo
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8, bottom: 16),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'welcome_to'.tr,
                            style: Utils.getTextStyle(
                              baseSize: 14,
                              isBold: false,
                              color: Colors.grey[600]!,
                              isUrdu: isUrdu,
                            ),
                          ),
                          Text(
                            'Drivvo',
                            style: Utils.getTextStyle(
                              baseSize: 22,
                              isBold: true,
                              color: Colors.black87,
                              isUrdu: isUrdu,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
