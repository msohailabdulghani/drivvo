class ReminderModel {
  late String userId;
  late String vehicleId;
  late String date;
  late double odometer;
  late String reminderType;
  late String reminder;
  late String notes;

  ReminderModel() {
    userId = "";
    vehicleId = "";
    date = "";
    odometer = 0.0;
    reminderType = "";
    reminder = "";
    notes = "";
  }

  ReminderModel.fromJson(Map<String, dynamic> json) {
    userId = json["user_id"] ?? "";
    vehicleId = json["vehicle_id"] ?? "";
    date = json["date"] ?? "";
    odometer = (json["odometer"] ?? 0).toDouble();
    reminderType = json["reminder_type"] ?? "";
    reminder = json["reminder"] ?? "";
    notes = json["notes"] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "vehicle_id": vehicleId,
      "date": date,
      "odometer": odometer,
      "reminder_type": reminderType,
      "reminder": reminder,
      "notes": notes,
    };
  }
}
