import 'package:cloud_firestore/cloud_firestore.dart';

class IncomeModel {
  late String userId;
  late String vehicleId;
  late String time;
  late DateTime date;
  late int odometer;
  late String incomeType;
  late int value;
  late String driverName;
  late String filePath;
  late String notes;
  late String imagePath;
  late String driverId;
  Map<String, dynamic> rawMap = {};

  IncomeModel() {
    userId = "";
    vehicleId = "";
    time = "";
    date = DateTime.now();
    odometer = 0;
    incomeType = "";
    value = 0;
    driverName = "";
    filePath = "";
    notes = "";
    imagePath = "";
    driverId = "";
  }

  IncomeModel.fromJson(Map<String, dynamic> json) {
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
    incomeType = json["income_type"] ?? "";
    value = json["value"] ?? 0;
    driverName = json["driver_name"] ?? "";
    filePath = json["file_path"] ?? "";
    notes = json["notes"] ?? "";
    imagePath = json["image_path"] ?? "";
    driverId = json["driver_id"] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "vehicle_id": vehicleId,
      "time": time,
      "date": date.toIso8601String(),
      "odometer": odometer,
      "income_type": incomeType,
      "value": value,
      "driver_name": driverName,
      "file_path": filePath,
      "notes": notes,
      "image_path": imagePath,
      "driver_id": driverId,
    };
  }
}
