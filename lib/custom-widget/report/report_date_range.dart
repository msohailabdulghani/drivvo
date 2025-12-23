import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportDateRange extends StatelessWidget {
  final bool isUrdu;
  final String formattedDateRange;
  final VoidCallback selectDateRange;
  const ReportDateRange({
    super.key,
    required this.isUrdu,
    required this.formattedDateRange,
    required this.selectDateRange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${"period".tr}:",
          style: Utils.getTextStyle(
            baseSize: 14,
            isBold: false,
            color: Colors.grey[600]!,
            isUrdu: isUrdu,
          ),
        ),
        GestureDetector(
          onTap: () => selectDateRange(),
          child: Row(
            children: [
              Text(
                formattedDateRange,
                style: Utils.getTextStyle(
                  baseSize: 14,
                  isBold: true,
                  color: Colors.black87,
                  isUrdu: isUrdu,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
