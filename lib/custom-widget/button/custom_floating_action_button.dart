import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final Function onPressed;

  const CustomFloatingActionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => onPressed(),
      shape: const CircleBorder(),
      foregroundColor: Colors.white,
      backgroundColor: Utils.appColor,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
