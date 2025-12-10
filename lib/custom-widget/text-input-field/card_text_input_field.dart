import 'package:drivvo/custom-widget/common/label_text.dart';
import 'package:drivvo/custom-widget/text-input-field/form_label_text.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';

class CardTextInputField extends StatelessWidget {
  final bool isRequired;
  final bool isNext;
  final bool obscureText;
  final bool readOnly;
  final String labelText;
  final String hintText;
  final Icon? prefixIcon;
  final Icon? sufixIcon;
  final Function(String? value) onSaved;
  final Function(String? value) onValidate;
  final Function(String? value)? onChange;
  final Function()? onTap;
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
    this.prefixIcon,
    this.sufixIcon,
    required this.onSaved,
    required this.onValidate,
    this.onChange,
    this.onTap,
    this.maxLength,
    required this.isUrdu,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isRequired
            ? FormLabelText(title: labelText, isUrdu: isUrdu)
            : LabelText(title: labelText, isUrdu: isUrdu),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          obscureText: obscureText,
          style: Utils.getTextStyle(
            baseSize: 14,
            isBold: false,
            color: Colors.black,
            isUrdu: isUrdu,
          ),
          decoration: InputDecoration(
            hintText: hintText,
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
