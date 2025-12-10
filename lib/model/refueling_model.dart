class RefuelingModel {
  late String id;
  late String vehicleId;
  late String time;
  late String date;
  late double odometer;
  late double price;
  late double liter;
  late double totalCost;
  late String fuelType;
  late String fuelStation;
  late bool fullTank;
  late bool missedPrevious;
  late String paymentMethod;
  late String notes;

  RefuelingModel() {
    id = "";
    vehicleId = "";
    time = "";
    date = "";
    odometer = 0.0;
    price = 0.0;
    liter = 0.0;
    totalCost = 0.0;
    fuelType = "";
    fuelStation = "";
    fullTank = true;
    missedPrevious = false;
    paymentMethod = "";
    notes = "";
  }

  RefuelingModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? "";
    vehicleId = json["vehicle_id"] ?? "";
    time = json["time"] ?? "";
    date = json["date"] ?? "";
    odometer = (json["odometer"] ?? 0).toDouble();
    price = (json["price"] ?? 0).toDouble();
    liter = (json["liter"] ?? 0).toDouble();
    totalCost = (json["total_cost"] ?? 0).toDouble();
    fuelType = json["fuel_type"] ?? "";
    fuelStation = json["fuel_station"] ?? "";
    fullTank = json["full_tank"] ?? true;
    missedPrevious = json["missed_previous"] ?? false;
    paymentMethod = json["payment_method"] ?? "";
    notes = json["notes"] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "vehicle_id": vehicleId,
      "time": time,
      "date": date,
      "odometer": odometer,
      "price": price,
      "liter": liter,
      "total_cost": totalCost,
      "fuel_type": fuelType,
      "fuel_station": fuelStation,
      "full_tank": fullTank,
      "missed_previous": missedPrevious,
      "payment_method": paymentMethod,
      "notes": notes,
    };
  }
}
