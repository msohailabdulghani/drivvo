import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseTypeModel {
  final String id;
  final String name;
  final RxInt value;
  final RxBool isChecked;
  final FocusNode focusNode = FocusNode();

  ExpenseTypeModel({
    required this.id,
    required this.name,
    int value = 0,
    bool isChecked = false,
  }) : value = value.obs,
       isChecked = isChecked.obs;

  /// Empty model (optional)
  factory ExpenseTypeModel.empty() {
    return ExpenseTypeModel(id: "", name: "");
  }

  /// From Firestore
  factory ExpenseTypeModel.fromJson(Map<String, dynamic> json) {
    return ExpenseTypeModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      value: json["value"] ?? 0,
      isChecked: json["isChecked"] ?? false,
    );
  }

  /// To Firestore
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "value": value.value,
      "isChecked": isChecked.value,
    };
  }
}
