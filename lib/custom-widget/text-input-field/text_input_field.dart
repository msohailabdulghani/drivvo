import 'package:drivvo/custom-widget/common/label_text.dart';
import 'package:drivvo/custom-widget/text-input-field/form_label_text.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';

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
  final Function()? onTap;
  final String? initialValue;
  final int? maxLength;
  final int? maxLines;
  final bool isUrdu;
  final TextEditingController? controller;

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
    this.onTap,
    this.initialValue,
    this.maxLength,
    this.maxLines,
    required this.isUrdu,
    this.controller,
    this.focusNode,
    this.onFieldSubmitted,
  });

  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;

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
          readOnly: readOnly,
          maxLines: maxLines,
          style: Utils.getTextStyle(
            baseSize: 14,
            isBold: false,
            color: Colors.black,
            isUrdu: isUrdu,
          ),
          maxLength: maxLength,
          initialValue: controller != null ? null : initialValue,
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          keyboardType: type,
          textInputAction: inputAction,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: sufixIcon,
          ),
          onChanged: onChange != null ? (v) => onChange!(v) : null,
          onTap: onTap != null ? () => onTap!() : null,
          onSaved: (value) => onSaved(value),
          validator: (value) => onValidate(value),
          onFieldSubmitted:
              onFieldSubmitted ??
              (_) {
                if (inputAction == TextInputAction.next) {
                  FocusScope.of(context).nextFocus();
                }
              },
        ),
      ],
    );
  }
}
