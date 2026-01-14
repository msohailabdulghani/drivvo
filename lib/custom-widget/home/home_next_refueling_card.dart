import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeNextRefuelingCard extends StatelessWidget {
  final bool isUrdu;
  final int nextRefuelingOdometer;
  final DateTime? nextRefuelingDate;
  final double avgConsumption;
  final String distanceUnit;

  const HomeNextRefuelingCard({
    super.key,
    required this.isUrdu,
    required this.nextRefuelingOdometer,
    required this.nextRefuelingDate,
    required this.avgConsumption,
    this.distanceUnit = "km",
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 44,
            child: Column(
              children: [
                // Line above dot
                Container(width: 3, height: 10, color: const Color(0xFF424242)),
                // Dot
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Color(0xFFFB9601),
                    borderRadius: BorderRadius.circular(120),
                  ),
                  child: Icon(
                    Icons.local_gas_station,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                Expanded(
                  child: Container(width: 3, color: const Color(0xFF424242)),
                ),
                Container(width: 3, height: 10, color: const Color(0xFF424242)),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 10, left: 10, bottom: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Main content row (always visible)
                  Row(
                    children: [
                      // Title and Odometer
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "next_refueling".tr,
                              style: Utils.getTextStyle(
                                baseSize: 15,
                                isBold: true,
                                color: Colors.black87,
                                isUrdu: isUrdu,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  Icons.speed,
                                  color: Colors.grey[500],
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$nextRefuelingOdometer km',
                                  style: Utils.getTextStyle(
                                    baseSize: 12,
                                    isBold: false,
                                    color: Colors.grey[500]!,
                                    isUrdu: isUrdu,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Date
                      Text(
                        nextRefuelingDate != null
                            ? DateFormat(
                                'dd MMM yyyy',
                              ).format(nextRefuelingDate!)
                            : '-- -- ----',
                        style: Utils.getTextStyle(
                          baseSize: 12,
                          isBold: false,
                          color: Colors.grey[500]!,
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
    );
  }
}
