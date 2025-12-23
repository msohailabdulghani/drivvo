import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomReportCard extends StatelessWidget {
  final bool isUrdu;
  final String imageUrl;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String total;
  final Color totalColor;
  final String byDay;
  final String byKm;

  const CustomReportCard({
    super.key,
    required this.isUrdu,
    required this.imageUrl,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.total,
    required this.totalColor,
    required this.byDay,
    required this.byKm,
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
              Image.asset(
                imageUrl,
                height: 40,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image, size: 40, color: Colors.grey);
                },
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Utils.getTextStyle(
                  baseSize: 14,
                  isBold: true,
                  color: iconColor,
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
              color: totalColor,
              isUrdu: isUrdu,
            ),
          ),
          const SizedBox(height: 8),
          Container(height: 1, color: Colors.grey[200]),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "by_day".tr,
                    style: Utils.getTextStyle(
                      baseSize: 10,
                      isBold: false,
                      color: Colors.grey[500]!,
                      isUrdu: isUrdu,
                    ),
                  ),
                  Text(
                    byDay,
                    style: Utils.getTextStyle(
                      baseSize: 13,
                      isBold: true,
                      color: Colors.black87,
                      isUrdu: isUrdu,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "by_km".tr,
                    style: Utils.getTextStyle(
                      baseSize: 10,
                      isBold: false,
                      color: Colors.grey[500]!,
                      isUrdu: isUrdu,
                    ),
                  ),
                  Text(
                    byKm,
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
        ],
      ),
    );
  }
}
