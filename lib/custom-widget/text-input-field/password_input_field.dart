import 'package:drivvo/custom-widget/common/label_text.dart';
import 'package:drivvo/custom-widget/text-input-field/form_label_text.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';

class PasswordInputField extends StatelessWidget {
  final bool isRequired;
  final bool isNext;
  final bool obscureText;
  final bool readOnly;
  final String labelText;
  final String hintText;
  final TextInputAction inputAction;
  final TextInputType type;
  final IconButton? suffixIcon;
  final Function(String? value) onSaved;
  final Function(String? value) onChanged;
  final Function() onPessed;
  final Function(String? value) onValidate;
  final String? initialValue;
  final int? maxLength;
  final bool isUrdu;

  const PasswordInputField({
    super.key,
    required this.isRequired,
    required this.isNext,
    required this.obscureText,
    required this.readOnly,
    required this.labelText,
    required this.hintText,
    required this.inputAction,
    required this.type,
    this.suffixIcon,
    required this.onSaved,
    required this.onChanged,
    required this.onPessed,
    required this.onValidate,
    this.initialValue,
    this.maxLength,
    required this.isUrdu,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isRequired
            ? FormLabelText(title: labelText, isUrdu: isUrdu)
            : LabelText(title: labelText, isUrdu: isUrdu),
        const SizedBox(height: 4),
        TextFormField(
          obscureText: obscureText,
          keyboardType: type,
          textInputAction: inputAction,
          style: Utils.getTextStyle(
            baseSize: 14,
            isBold: false,
            color: Colors.black,
            isUrdu: isUrdu,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
          ),
          onChanged: (value) => onChanged(value),
          onSaved: (value) => onSaved(value),
          validator: (value) => onValidate(value),
          onTap: () => onPessed(),
        ),
      ],
    );
  }
}
