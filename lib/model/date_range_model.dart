class DateRangeModel {
  int id;
  String title;
  DateTime? startDate;
  DateTime? endDate;
  String dateString;

  DateRangeModel({
    required this.id,
    required this.title,
    this.startDate,
    this.endDate,
    required this.dateString,
  });
}
