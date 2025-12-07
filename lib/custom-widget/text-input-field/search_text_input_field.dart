import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchTextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintKey;

  const SearchTextInputField({
    super.key,
    required this.controller,
    required this.hintKey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: Get.mediaQuery.size.width * 0.9,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          hintText: hintKey.tr,
          prefixIcon: const Icon(Icons.search, size: 18),
          contentPadding: const EdgeInsets.all(0),
          fillColor: const Color(0xFFE6E5E5),
          isDense: true,
          hintStyle: const TextStyle(color: Color(0xFF8B8B8F)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
