import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/app_user.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileController extends GetxController {
  late AppService appService;
  final formStateKey = GlobalKey<FormState>();
  final errorMessage = "".obs;
  final isLoading = false.obs;
  final filePath = "".obs;

  var model = AppUser();

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  final issueDateController = TextEditingController();
  final expiryDateController = TextEditingController();

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();

    model = appService.appUser.value;
    if (model.licenseIssueDate.isNotEmpty &&
        model.licenseExpiryDate.isNotEmpty) {
      issueDateController.text = model.licenseIssueDate;
      expiryDateController.text = model.licenseExpiryDate;
    } else {
      final now = DateTime.now();
      issueDateController.text = Utils.formatDate(date: now);
      expiryDateController.text = Utils.formatDate(
        date: now.add(Duration(days: 1)),
      );
    }
  }

  void selectDate({required bool isIssueDate}) async {
    final context = Get.context;
    if (context == null) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final date = Utils.formatDate(date: picked);

      if (isIssueDate) {
        issueDateController.text = date;
      } else {
        expiryDateController.text = date;
      }
    }
  }

  Future<void> saveData() async {
    if (formStateKey.currentState?.validate() == true) {
      formStateKey.currentState?.save();

      Utils.showProgressDialog(Get.context!);
      if (filePath.value.isNotEmpty) {
        saveUser();
      } else {
        saveUser();
      }
    }
  }

  Future<void> saveUser() async {
    final map = {
      "first_name": model.firstName,
      "last_name": model.lastName,
      "phone": model.phone,
      "license_number": model.licenseNumber,
      "license_category": model.licenseCategory,
      "license_issue_date": issueDateController.text.trim(),
      "license_expiry_date": expiryDateController.text.trim(),
    };

    try {
      await db
          .collection(DatabaseTables.USER_PROFILE)
          .doc(appService.appUser.value.id)
          .update(map)
          .then((_) {
            Get.back();
            Get.back();
            appService.appUser.value.firstName = model.firstName;
            appService.appUser.value.lastName = model.lastName;
            appService.appUser.value.phone = model.phone;
            appService.appUser.value.licenseNumber = model.licenseNumber;
            appService.appUser.value.licenseCategory = model.licenseCategory;
            appService.appUser.value.licenseIssueDate = model.licenseIssueDate;
            appService.appUser.value.licenseExpiryDate =
                model.licenseExpiryDate;
            appService.appUser.refresh();
            appService.getUserProfile();
            Utils.showSnackBar(
              message: "profile_updated_success",
              success: true,
            );
          });
    } catch (e) {
      Get.back();
      Utils.showSnackBar(message: "save_data_failed", success: false);
    }
  }

  // Future<void> uploadImage() async {
  //   final metadata = SettableMetadata(
  //     contentType: 'image/png',
  //     customMetadata: {'picked-file-path': filePath.value},
  //   );

  //   var fileName = "${appService.appUser.value.id}.jpg";

  //   storageRef
  //       .child('/$fileName')
  //       .putFile(File(filePath.value), metadata)
  //       .then((snapshot) {
  //         snapshot.ref.getDownloadURL().then((url) {
  //           final map = <String, dynamic>{};

  //           map["name"] = name;
  //           map["photoUrl"] = url;

  //           db
  //               .collection(DatabaseTables.USER_PROFILE)
  //               .doc(appService.appUser.value.id)
  //               .update(map)
  //               .then((value) {
  //                 Get.back();
  //                 Get.back();
  //                 appService.appUser.value.name = name;
  //                 appService.appUser.value.photoUrl = url;
  //                 appService.appUser.refresh();
  //                 appService.refreshUserData();
  //                 Utils.showSnackBar(
  //                   message: "profile_updated_success",
  //                   success: true,
  //                 );
  //               })
  //               .onError((error, stackTrace) {
  //                 Get.back();
  //                 Utils.showSnackBar(
  //                   message: "Image Upload error: $error",
  //                   success: false,
  //                 );
  //               });
  //         });
  //       })
  //       .onError((error, stackTrace) {
  //         Get.back();
  //         Utils.showSnackBar(
  //           message: "Image Upload error: $error",
  //           success: false,
  //         );
  //       });
  // }

  Future<void> onPickedFile(XFile? pickedFile) async {
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: const Color(0xFF047772),
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true,
            aspectRatioPresets: [CropAspectRatioPreset.square],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset
                  .square, // IMPORTANT: iOS supports only one custom aspect ratio in preset list
            ],
          ),
        ],
      );
      if (croppedFile != null) {
        filePath.value = croppedFile.path;
      }
    }
  }
}
