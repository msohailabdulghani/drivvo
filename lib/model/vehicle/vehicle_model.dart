class VehicleModel {
  late String id;
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

  VehicleModel() {
    id = "";
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
  }

  VehicleModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? "";
    vehicleType = json["vehicle_type"] ?? "";
    name = json["name"] ?? "";
    manufacturer = json["manufacturer"] ?? "";
    model = json["model"] ?? "";
    licensePlate = json["license_plate"] ?? "";
    year = (json["year"] ?? 0).toInt();
    tankConfiguration = json["tank_configuration"] ?? "";
    fuelType = json["fuel_type"] ?? "";
    fuelCapacity = json["fuel_capacity"] ?? "";
    distanceUnit = json["distance_unit"] ?? "";
    chassisNumber = json["chassis_number"] ?? "";
    identificationNumber = json["identification_number"] ?? "";
    notes = json["notes"] ?? "";
  }

  Map<String, dynamic> toJson(String id) {
    return {
      "id": id,
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
    };
  }
}
