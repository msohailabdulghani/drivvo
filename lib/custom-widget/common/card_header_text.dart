import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';

class CardHeaderText extends StatelessWidget {
  final String title;
  final bool isUrdu;
  final Color color;

  const CardHeaderText({
    super.key,
    required this.title,
    required this.isUrdu,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title,
        style: Utils.getTextStyle(
          baseSize: 16,
          isBold: true,
          color: color,
          isUrdu: isUrdu,
        ),
      ),
    );
  }
}
