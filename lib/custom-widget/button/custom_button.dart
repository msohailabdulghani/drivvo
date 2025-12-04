import 'package:drivvo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function onTap;

  const CustomButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => onTap(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF047772),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE
                ? 18
                : 16,
            fontFamily: Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE
                ? "U-FONT-R"
                : "D-FONT-R",
          ),
        ),
      ),
    );
  }
}
