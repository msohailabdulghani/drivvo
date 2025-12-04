import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormLabelText extends StatelessWidget {
  final String text;
  const FormLabelText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text.tr,
          style: const TextStyle(
            fontFamily: "D-FONT-R",
            fontSize: 16,
          ),
        ),
        const Text(
          "*",
          style: TextStyle(
            color: Colors.red,
            fontFamily: "D-FONT-M",
          ),
        ),
      ],
    );
  }
}
