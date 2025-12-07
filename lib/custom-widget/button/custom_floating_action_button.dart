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
      backgroundColor: const Color(0xFF047772),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
