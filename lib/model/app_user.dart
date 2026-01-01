import 'package:drivvo/model/expense/expense_model.dart';
import 'package:drivvo/model/income/income_model.dart';
import 'package:drivvo/model/last_record_model.dart';
import 'package:drivvo/model/refueling/refueling_model.dart';
import 'package:drivvo/model/route/route_model.dart';
import 'package:drivvo/model/service/service_model.dart';

class AppUser {
  late String id;
  late String firstName;
  late String lastName;
  late String email;
  late String phone;
  late String photoUrl;
  late String licenseNumber;
  late String licenseCategory;
  late String licenseIssueDate;
  late String licenseExpiryDate;
  late String signInMethod;
  late String password;
  late String confirmPassword;
  late String notificationTime;

  late bool isSubscribed;
  late String productId;
  late String purchaseToken;

  late int lastOdometer;

  late List<RefuelingModel> refuelingList;
  late List<ExpenseModel> expenseList;
  late List<ServiceModel> serviceList;
  late List<IncomeModel> incomeList;
  late List<RouteModel> routeList;

  late LastRecordModel lastRecordModel;

  AppUser() {
    id = "";
    firstName = "";
    lastName = "";
    email = "";
    phone = "";
    photoUrl = "";
    licenseNumber = "";
    licenseCategory = "";
    licenseIssueDate = "";
    licenseExpiryDate = "";
    signInMethod = "";
    password = "";
    confirmPassword = "";
    notificationTime = "12:00 PM";

    isSubscribed = false;
    productId = "";
    purchaseToken = "";

    lastOdometer = 0;

    refuelingList = [];
    expenseList = [];
    serviceList = [];
    incomeList = [];
    routeList = [];

    lastRecordModel = LastRecordModel();
  }

  AppUser.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? "";
    firstName = json["first_name"] ?? "";
    lastName = json["last_name"] ?? "";
    email = json["email"] ?? "";
    phone = json["phone"] ?? "";
    photoUrl = json["photo_url"] ?? "";
    licenseNumber = json["license_number"] ?? "";
    licenseCategory = json["license_category"] ?? "";
    licenseIssueDate = json["license_issue_date"] ?? "";
    licenseExpiryDate = json["license_expiry_date"] ?? "";
    signInMethod = json["sign_in_method"] ?? "";
    password = json["password"] ?? "";
    confirmPassword = json["confirmPassword"] ?? "";

    isSubscribed = json["isEntitled"] ?? false;
    productId = json["productId"] ?? "";
    purchaseToken = json["purchaseToken"] ?? "";

    lastOdometer = json["last_odometer"] ?? 0;
    notificationTime = json["notification_time"] ?? "12:00 PM";

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
    lastRecordModel = json["last_record"] != null
        ? LastRecordModel.fromJson(json["last_record"] as Map<String, dynamic>)
        : LastRecordModel();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "phone": phone,
      "photo_url": photoUrl,
      "license_number": licenseNumber,
      "license_category": licenseCategory,
      "license_issue_date": licenseIssueDate,
      "license_expiry_date": licenseExpiryDate,
    };
  }
}
