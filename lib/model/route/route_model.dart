import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/app_user.dart';

class RouteModel {
  late String userId;
  late String vehicleId;
  late String origin;
  late DateTime startDate;
  late String startTime;
  late DateTime endDate;
  late String endTime;
  late int initialOdometer;
  late String destination;
  late int finalOdometer;
  late int valuePerKm;
  late int total;
  late String reason;
  late String filePath;
  late String notes;
  late String imagePath;
  late String driverId;
  Map<String, dynamic> rawMap = {};

  late AppUser driver;

  RouteModel() {
    userId = "";
    vehicleId = "";
    origin = "";
    startDate = DateTime.now();
    startTime = "";
    endDate = DateTime.now();
    endTime = "";
    initialOdometer = 0;
    destination = "";
    finalOdometer = 0;
    valuePerKm = 0;
    total = 0;
    reason = "";
    filePath = "";
    notes = "";
    imagePath = "";
    driverId = "";
    driver = AppUser();
  }

  RouteModel.fromJson(Map<String, dynamic> json) {
    rawMap = Map<String, dynamic>.from(json);
    userId = json["user_id"] ?? "";
    vehicleId = json["vehicle_id"] ?? "";
    origin = json["origin"] ?? "";
    final startDateValue = json["start_date"];
    if (startDateValue is Timestamp) {
      startDate = startDateValue.toDate();
    } else if (startDateValue is String) {
      startDate = DateTime.tryParse(startDateValue) ?? DateTime.now();
    } else {
      startDate = DateTime.now();
    }
    startTime = json["start_time"] ?? "";
    final endDateValue = json["end_date"];
    if (endDateValue is Timestamp) {
      endDate = endDateValue.toDate();
    } else if (endDateValue is String) {
      endDate = DateTime.tryParse(endDateValue) ?? DateTime.now();
    } else {
      endDate = DateTime.now();
    }
    endTime = json["end_time"] ?? "";
    initialOdometer = json["initial_odometer"] ?? 0;
    destination = json["destination"] ?? "";
    finalOdometer = json["final_odometer"] ?? 0;
    valuePerKm = json["value_per_km"] ?? 0;
    total = json["total"] ?? 0;
    reason = json["reason"] ?? "";
    filePath = json["file_path"] ?? "";
    notes = json["notes"] ?? "";
    imagePath = json["image_path"] ?? "";
    driverId = json["driver_id"] ?? "";

    final driverData = json["driver"];
    if (driverData is Map<String, dynamic>) {
      driver = AppUser.fromJson(driverData);
    } else {
      driver = AppUser();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "vehicle_id": vehicleId,
      "origin": origin,
      "start_date": startDate.toIso8601String(),
      "start_time": startTime,
      "end_date": endDate.toIso8601String(),
      "end_time": endTime,
      "initial_odometer": initialOdometer,
      "destination": destination,
      "final_odometer": finalOdometer,
      "value_per_km": valuePerKm,
      "total": total,
      "driver": driver.toJson(),
      "reason": reason,
      "file_path": filePath,
      "notes": notes,
      "image_path": imagePath,
      "driver_id": driverId,
    };
  }
}
