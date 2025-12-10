import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoreOptionButton extends StatelessWidget {
  final bool isUrdu;
  final bool moreOptionsExpanded;
  final VoidCallback onTap;

  const MoreOptionButton({
    super.key,
    required this.isUrdu,
    required this.moreOptionsExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Utils.appColor),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              moreOptionsExpanded ? Icons.remove : Icons.add,
              color: Utils.appColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'more_options'.tr,
              style: Utils.getTextStyle(
                baseSize: 15,
                isBold: true,
                color: Utils.appColor,
                isUrdu: isUrdu,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
