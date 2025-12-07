import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormLabelText extends StatelessWidget {
  final String title;
  final bool isUrdu;

  const FormLabelText({super.key, required this.title, required this.isUrdu});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title.tr,
          style: Utils.getTextStyle(
            baseSize: 14,
            isBold: false,
            color: Colors.black,
            isUrdu: isUrdu,
          ),
        ),
        const Text(
          "*",
          style: TextStyle(color: Colors.red, fontFamily: "D-FONT-M"),
        ),
      ],
    );
  }
}
