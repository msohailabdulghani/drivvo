import 'package:drivvo/custom-widget/text-input-field/form_label_text.dart';
import 'package:flutter/material.dart';

class CardTextInputField extends StatelessWidget {
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
  final Function()? onTap;
  final String? initialValue;
  final int? maxLength;
  final bool isUrdu;
  final TextEditingController controller;

  const CardTextInputField({
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
    this.onTap,
    this.initialValue,
    this.maxLength,
    required this.isUrdu,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   labelText,
        //   style: TextStyle(
        //     fontWeight: FontWeight.normal,
        //     color: Colors.black,
        //     fontSize: Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE
        //         ? 16
        //         : 14,
        //     fontFamily: Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE
        //         ? "U-FONT-R"
        //         : "D-FONT-R",
        //   ),
        // ),
        FormLabelText(title: labelText, isUrdu: isUrdu),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
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
          ),
          onTap: onTap != null ? () => onTap!() : null,
          onSaved: (value) => onSaved(value),
          validator: (value) => onValidate(value),
        ),
      ],
    );
  }
}
