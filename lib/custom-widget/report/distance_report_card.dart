import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DistanceReportCard extends StatelessWidget {
  final bool isUrdu;
  final String imageUrl;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String total;
  final String dailyAverage;

  const DistanceReportCard({
    super.key,
    required this.isUrdu,
    required this.imageUrl,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.total,
    required this.dailyAverage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(imageUrl, height: 40),
              const SizedBox(width: 8),
              Text(
                title,
                style: Utils.getTextStyle(
                  baseSize: 14,
                  isBold: true,
                  color: Colors.blue,
                  isUrdu: isUrdu,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "total".tr,
            style: Utils.getTextStyle(
              baseSize: 12,
              isBold: false,
              color: Colors.grey[500]!,
              isUrdu: isUrdu,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            total,
            style: Utils.getTextStyle(
              baseSize: 20,
              isBold: true,
              color: Colors.black87,
              isUrdu: isUrdu,
            ),
          ),
          const SizedBox(height: 8),
          Container(height: 1, color: Colors.grey[200]),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "daily_average".tr,
                style: Utils.getTextStyle(
                  baseSize: 10,
                  isBold: false,
                  color: Colors.grey[500]!,
                  isUrdu: isUrdu,
                ),
              ),
              Text(
                dailyAverage,
                style: Utils.getTextStyle(
                  baseSize: 13,
                  isBold: true,
                  color: Colors.black87,
                  isUrdu: isUrdu,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
