import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomOutlineButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isUrdu;
  final Color btnColor;
  final VoidCallback onTap;
  const CustomOutlineButton({
    super.key,
    required this.title,
    required this.icon,
    required this.isUrdu,
    required this.btnColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => onTap(),
      icon: Icon(icon, size: 22),
      label: Text(
        title.tr,
        style: Utils.getTextStyle(
          baseSize: 16,
          isBold: false,
          color: btnColor,
          isUrdu: isUrdu,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: btnColor.withValues(alpha: 0.1),
        foregroundColor: btnColor, // Text and Icon color
        side: BorderSide(color: btnColor), // Border color
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
