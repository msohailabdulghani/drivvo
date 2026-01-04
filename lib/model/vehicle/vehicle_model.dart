import 'package:drivvo/model/expense/expense_model.dart';
import 'package:drivvo/model/income/income_model.dart';
import 'package:drivvo/model/refueling/refueling_model.dart';
import 'package:drivvo/model/route/route_model.dart';
import 'package:drivvo/model/service/service_model.dart';

class VehicleModel {
  late String id;
  late String vehicleType;
  late String name;
  late String manufacturer;
  late int modelYear;
  late String licensePlate;
  late String tankConfiguration;
  late String mainFuelType;
  late String mainFuelCapacity;
  late String secFuelType;
  late String secFuelCapacity;
  late String distanceUnit;
  late String chassisNumber;
  late String identificationNumber;
  late String notes;

  late int lastOdometer;
  late String assignUserId;

  late List<RefuelingModel> refuelingList;
  late List<ExpenseModel> expenseList;
  late List<ServiceModel> serviceList;
  late List<IncomeModel> incomeList;
  late List<RouteModel> routeList;

  VehicleModel() {
    id = "";
    vehicleType = "";
    name = "";
    manufacturer = "";
    modelYear = 0;
    licensePlate = "";
    tankConfiguration = "";
    mainFuelType = "";
    mainFuelCapacity = "";
    secFuelType = "";
    secFuelCapacity = "";
    distanceUnit = "";
    chassisNumber = "";
    identificationNumber = "";
    notes = "";

    lastOdometer = 0;
    assignUserId = "";

    refuelingList = [];
    expenseList = [];
    serviceList = [];
    incomeList = [];
    routeList = [];
  }

  VehicleModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? "";
    vehicleType = json["vehicle_type"] ?? "";
    name = json["name"] ?? "";
    manufacturer = json["manufacturer"] ?? "";
    modelYear = json["model_year"] ?? 0;
    licensePlate = json["license_plate"] ?? "";
    tankConfiguration = json["tank_configuration"] ?? "";
    mainFuelType = json["main_fuel_type"] ?? "";
    mainFuelCapacity = json["main_fuel_capacity"] ?? "";
    secFuelType = json["sec_fuel_type"] ?? "";
    secFuelCapacity = json["sec_fuel_capacity"] ?? "";
    distanceUnit = json["distance_unit"] ?? "";
    chassisNumber = json["chassis_number"] ?? "";
    identificationNumber = json["identification_number"] ?? "";
    notes = json["notes"] ?? "";

    lastOdometer = json["last_odometer"] ?? 0;
    assignUserId = json["assign_user_id"] ?? "";

    refuelingList =
        (json["refueling_list"] as List<dynamic>?)
            ?.map((e) => RefuelingModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    expenseList =
        (json["expense_list"] as List<dynamic>?)
            ?.map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    serviceList =
        (json["service_list"] as List<dynamic>?)
            ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    incomeList =
        (json["income_list"] as List<dynamic>?)
            ?.map((e) => IncomeModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    routeList =
        (json["route_list"] as List<dynamic>?)
            ?.map((e) => RouteModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
  }

  Map<String, dynamic> toJson(String id) {
    return {
      "id": id,
      "vehicle_type": vehicleType,
      "name": name,
      "manufacturer": manufacturer,
      "model_year": modelYear,
      "license_plate": licensePlate,
      "tank_configuration": tankConfiguration,
      "main_fuel_type": mainFuelType,
      "main_fuel_capacity": mainFuelCapacity,
      "sec_fuel_type": secFuelType,
      "sec_fuel_capacity": secFuelCapacity,
      "distance_unit": distanceUnit,
      "chassis_number": chassisNumber,
      "identification_number": identificationNumber,
      "notes": notes,

      "last_odometer": lastOdometer,
      "assign_user_id": assignUserId,

      "refueling_list": refuelingList.map((e) => e.toJson()).toList(),
      "expense_list": expenseList.map((e) => e.toJson()).toList(),
      "service_list": serviceList.map((e) => e.toJson()).toList(),
      "income_list": incomeList.map((e) => e.toJson()).toList(),
      "route_list": routeList.map((e) => e.toJson()).toList(),
    };
  }
}
