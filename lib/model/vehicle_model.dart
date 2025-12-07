class VehicleModel {
  late String vehicleType;
  late String name;
  late String manufacturer;
  late String model;
  late String licensePlate;
  late int year;
  late String tankConfiguration;
  late String fuelType;
  late String fuelCapacity;
  late String distanceUnit;
  late String chassisNumber;
  late String identificationNumber;
  late String notes;
  late bool activeVehicle;

  VehicleModel() {
    vehicleType = "";
    name = "";
    manufacturer = "";
    model = "";
    licensePlate = "";
    year = 0;
    tankConfiguration = "";
    fuelType = "";
    fuelCapacity = "";
    distanceUnit = "";
    chassisNumber = "";
    identificationNumber = "";
    notes = "";
    activeVehicle = false;
  }

  VehicleModel.fromJson(Map<String, dynamic> json) {
    vehicleType = json["vehicle_type"] ?? "";
    name = json["name"] ?? "";
    manufacturer = json["manufacturer"] ?? "";
    model = json["model"] ?? "";
    licensePlate = json["license_plate"] ?? "";
    year = json["year"] ?? 0;
    tankConfiguration = json["tank_configuration"] ?? "";
    fuelType = json["fuel_type"] ?? "";
    fuelCapacity = json["fuel_capacity"] ?? "";
    distanceUnit = json["distance_unit"] ?? "";
    chassisNumber = json["chassis_number"] ?? "";
    identificationNumber = json["identification_number"] ?? "";
    notes = json["notes"] ?? "";
    activeVehicle = json["active_vehicle"] ?? false;
  }

  Map<String, dynamic> toJson() {
    return {
      "vehicle_type": vehicleType,
      "name": name,
      "manufacturer": manufacturer,
      "model": model,
      "license_plate": licensePlate,
      "year": year,
      "tank_configuration": tankConfiguration,
      "fuel_type": fuelType,
      "fuel_capacity": fuelCapacity,
      "distance_unit": distanceUnit,
      "chassis_number": chassisNumber,
      "identification_number": identificationNumber,
      "notes": notes,
      "active_vehicle": activeVehicle,
    };
  }
}
