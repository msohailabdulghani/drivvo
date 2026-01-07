import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/expense/expense_type_model.dart';

class ExpenseModel {
  late String userId;
  late String vehicleId;
  late String time;
  late DateTime date;
  late int odometer;
  late int totalAmount;
  late String place;
  late String driverName;
  late String paymentMethod;
  late String reason;
  late String filePath;
  late String notes;
  late String imagePath;
  late String driverId;
  late List<ExpenseTypeModel> expenseTypes;
  Map<String, dynamic> rawMap = {};

  ExpenseModel() {
    userId = "";
    vehicleId = "";
    time = "";
    date = DateTime.now();
    odometer = 0;
    totalAmount = 0;
    place = "";
    driverName = "";
    paymentMethod = "";
    reason = "";
    filePath = "";
    notes = "";
    imagePath = "";
    driverId = "";
    expenseTypes = [];
  }

  ExpenseModel.fromJson(Map<String, dynamic> json) {
    rawMap = Map<String, dynamic>.from(json);
    userId = json["user_id"] ?? "";
    vehicleId = json["vehicle_id"] ?? "";
    time = json["time"] ?? "";
    final dateValue = json["date"];
    if (dateValue is Timestamp) {
      date = dateValue.toDate();
    } else if (dateValue is String) {
      date = DateTime.tryParse(dateValue) ?? DateTime.now();
    } else {
      date = DateTime.now();
    }
    odometer = json["odometer"] ?? 0;
    totalAmount = json["total_amount"] ?? 0;
    place = json["place"] ?? "";
    driverName = json["driver_name"] ?? "";
    paymentMethod = json["payment_method"] ?? "";
    reason = json["reason"] ?? "";
    filePath = json["file_path"] ?? "";
    notes = json["notes"] ?? "";
    imagePath = json["image_path"] ?? "";
    driverId = json["driver_id"] ?? "";
    expenseTypes =
        (json["expense_types"] as List<dynamic>?)
            ?.map((e) => ExpenseTypeModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "vehicle_id": vehicleId,
      "time": time,
      "date": date.toIso8601String(),
      "odometer": odometer,
      "total_amount": totalAmount,
      "place": place,
      "driver_name": driverName,
      "payment_method": paymentMethod,
      "reason": reason,
      "file_path": filePath,
      "notes": notes,
      "image_path": imagePath,
      "driver_id": driverId,
      "expense_types": expenseTypes.map((e) => e.toJson()).toList(),
    };
  }
}
