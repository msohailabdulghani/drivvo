import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';

class LabelText extends StatelessWidget {
  final String title;
  final bool isUrdu;

  const LabelText({super.key, required this.title, required this.isUrdu});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Utils.getTextStyle(
        baseSize: 14,
        isBold: false,
        color: Colors.black,
        isUrdu: isUrdu,
      ),
    );
  }
}
