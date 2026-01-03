import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/app_user.dart';
import 'package:drivvo/model/vehicle/vehicle_model.dart';

class UserVehicleModel {
  late String id;
  late DateTime startDate;
  late AppUser user;
  late VehicleModel vehicle;

  UserVehicleModel() {
    id = "";
    startDate = DateTime.now();
    user = AppUser();
    vehicle = VehicleModel();
  }

  UserVehicleModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? "";
    startDate = (json["start_date"] as Timestamp?)?.toDate() ?? DateTime.now();
    user = json["user"] != null ? AppUser.fromJson(json["user"]) : AppUser();
    vehicle = json["vehicle"] != null
        ? VehicleModel.fromJson(json["vehicle"])
        : VehicleModel();
  }
}
