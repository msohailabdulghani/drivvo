import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/expense/expense_type_model.dart';

class ServiceModel {
  late String userId;
  late String vehicleId;
  late String time;
  late DateTime date;
  late int odometer;
  late int price;
  late int liter;
  late int totalAmount;
  late String fuelType;
  late String fuelStation;
  late bool fullTank;
  late bool missedPrevious;
  late String paymentMethod;
  late String notes;
  late String driverName;
  late List<ExpenseTypeModel> serviceTypes;
  late String filePath;
  late String place;
  late String reason;
  late String imagePath;
  late String driverId;
  Map<String, dynamic> rawMap = {};

  ServiceModel() {
    userId = "";
    vehicleId = "";
    time = "";
    date = DateTime.now();
    odometer = 0;
    price = 0;
    liter = 0;
    totalAmount = 0;
    fuelType = "";
    fuelStation = "";
    fullTank = true;
    missedPrevious = false;
    paymentMethod = "";
    notes = "";
    driverName = "";
    serviceTypes = [];
    filePath = "";
    place = "";
    reason = "";
    imagePath = "";
    driverId = "";
  }

  ServiceModel.fromJson(Map<String, dynamic> json) {
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
    price = json["price"] ?? 0;
    liter = json["liter"] ?? 0;
    totalAmount = json["total_amount"] ?? 0;
    fuelType = json["fuel_type"] ?? "";
    fuelStation = json["fuel_station"] ?? "";
    fullTank = json["full_tank"] ?? true;
    missedPrevious = json["missed_previous"] ?? false;
    paymentMethod = json["payment_method"] ?? "";
    notes = json["notes"] ?? "";
    driverName = json["driver_name"] ?? "";
    filePath = json["file_path"] ?? "";
    place = json["place"] ?? "";
    reason = json["reason"] ?? "";
    imagePath = json["image_path"] ?? "";
    driverId = json["driver_id"] ?? "";
    serviceTypes =
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
      "price": price,
      "liter": liter,
      "total_amount": totalAmount,
      "fuel_type": fuelType,
      "fuel_station": fuelStation,
      "full_tank": fullTank,
      "missed_previous": missedPrevious,
      "payment_method": paymentMethod,
      "notes": notes,
      "driver_name": driverName,
      "file_path": filePath,
      "place": place,
      "reason": reason,
      "image_path": imagePath,
      "driver_id": driverId,
      "expense_types": serviceTypes.map((e) => e.toJson()).toList(),
    };
  }
}
