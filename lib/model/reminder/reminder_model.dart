import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel {
  late String id;
  late String type;
  late String subType;
  late int odometer;
  late String notes;
  late bool oneTime;
  late String period;
  late DateTime startDate;
  late DateTime endDate;

  // New recurrence fields
  late bool oneTimeByDistance;
  late bool oneTimeByDate;

  late bool repeatByDistance;
  late int repeatDistanceInterval;

  late bool repeatByTime;
  late int repeatTimeInterval;
  late String repeatTimeUnit; // 'day', 'week', 'month', 'year'

  ReminderModel() {
    id = "";
    type = "";
    subType = "";
    odometer = 0;
    notes = "";
    oneTime = false;
    period = "";
    startDate = DateTime.now();
    endDate = DateTime.now();

    oneTimeByDistance = false;
    oneTimeByDate = true;

    repeatByDistance = false;
    repeatDistanceInterval = 0;

    repeatByTime = false;
    repeatTimeInterval = 0;
    repeatTimeUnit = "month";
  }

  ReminderModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? "";
    type = json["type"] ?? "";
    subType = json["sub_type"] ?? "";
    odometer = json["odometer"] ?? 0;
    notes = json["notes"] ?? "";
    period = json["period"] ?? "";
    oneTime = json["one_time"] ?? false;
    startDate = (json["start_date"] as Timestamp?)?.toDate() ?? DateTime.now();
    endDate = (json["end_date"] as Timestamp?)?.toDate() ?? DateTime.now();

    oneTimeByDistance = json["one_time_by_distance"] ?? false;
    oneTimeByDate = json["one_time_by_date"] ?? true;

    repeatByDistance = json["repeat_by_distance"] ?? false;
    repeatDistanceInterval = json["repeat_distance_interval"] ?? 0;

    repeatByTime = json["repeat_by_time"] ?? false;
    repeatTimeInterval = json["repeat_time_interval"] ?? 0;
    repeatTimeUnit = json["repeat_time_unit"] ?? "month";
  }
}
