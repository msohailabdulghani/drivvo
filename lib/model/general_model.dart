class GeneralModel {
  final String id;
  final String name;
  final String fuelType;
  final String location;

  GeneralModel({
    required this.id,
    required this.name,
    this.fuelType = "",
    this.location = "",
  });

  factory GeneralModel.fromJson(Map<String, dynamic> json) {
    return GeneralModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      fuelType: json["fuel_type"] ?? "",
      location: json["location"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "fuel_type": fuelType,
      "location": location,
    };
  }
}
