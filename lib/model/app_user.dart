import 'package:drivvo/model/last_record_model.dart';

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
  //late String notificationTime;

  late String adminId;
  late String userType;

  late bool isSubscribed;
  late String productId;
  late String purchaseToken;

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
    // notificationTime = "12:00 PM";

    adminId = "";
    userType = "";

    isSubscribed = false;
    productId = "";
    purchaseToken = "";

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

    //    notificationTime = json["notification_time"] ?? "12:00 PM";

    userType = json["user_type"] ?? "";
    adminId = json["admin_id"] ?? "";

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
      "user_type": userType,
      "admin_id": adminId,
    };
  }
}
