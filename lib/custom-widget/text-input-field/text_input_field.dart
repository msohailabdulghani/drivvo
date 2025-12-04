import 'package:drivvo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextInputField extends StatelessWidget {
  final bool isRequired;
  final bool isNext;
  final bool obscureText;
  final bool readOnly;
  final String labelText;
  final String hintText;
  final TextInputAction inputAction;
  final TextInputType type;
  final Icon? prefixIcon;
  final Icon? sufixIcon;
  final Function(String? value) onSaved;
  final Function(String? value) onValidate;
  final Function(String? value)? onChange;
  final String? initialValue;
  final int? maxLength;

  const TextInputField({
    super.key,
    required this.isRequired,
    required this.isNext,
    required this.obscureText,
    required this.readOnly,
    required this.labelText,
    required this.hintText,
    required this.inputAction,
    required this.type,
    this.prefixIcon,
    this.sufixIcon,
    required this.onSaved,
    required this.onValidate,
    this.onChange,
    this.initialValue,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE
                ? 16
                : 14,
            fontFamily: Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE
                ? "U-FONT-R"
                : "D-FONT-R",
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          readOnly: readOnly,
          initialValue: initialValue,
          obscureText: obscureText,
          keyboardType: type,
          textInputAction: inputAction,
          decoration: InputDecoration(
            filled: true,
            hintText: hintText,
            contentPadding: prefixIcon != null
                ? const EdgeInsets.symmetric(vertical: 16)
                : const EdgeInsets.all(16),
            prefixIcon: prefixIcon,
            suffixIcon: sufixIcon,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: Colors.grey[200]!, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: Colors.grey[200]!, width: 2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: Colors.grey[200]!, width: 2),
            ),
          ),
          onSaved: (value) => onSaved(value),
          validator: (value) => onValidate(value),
          onChanged: (value) => onChange?.call(value),
        ),
      ],
    );
  }
}
