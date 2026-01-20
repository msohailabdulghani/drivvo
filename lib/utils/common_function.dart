import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:drivvo/model/app_user.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonFunction {
  static final appService = AppService.to;

  // TODO implement in last
  // static Future<void> printFirebaseLog({required String pageName}) async {
  //   await FirebaseAnalytics.instance.logEvent(name: pageName);
  // }

  static Future<void> checkAdminSubscription({required String adminId}) async {
    if (adminId.isEmpty) {
      appService.isAdminSubscribed.value = false;
      return;
    }
    try {
      final response = await FirebaseFirestore.instance
          .collection(DatabaseTables.USER_PROFILE)
          .doc(adminId)
          .get();

      if (response.exists) {
        Map<String, dynamic>? data = response.data();
        if (data != null) {
          final userData = AppUser.fromJson(data);
          if (userData.isSubscribed) {
            appService.isAdminSubscribed.value = true;
            return;
          }
        }
      }
      appService.isAdminSubscribed.value = false;
      return;
    } catch (e) {
      appService.isAdminSubscribed.value = false;
      return;
    }
  }

  static Future<void> sendMail() async {
    String email = "msohailabdulghani@gmail.com";
    Uri mail = Uri.parse("mailto:$email");
    await launchUrl(mail);
  }

  static DateTime accountCreatedDate() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final date = user.metadata.creationTime;
      if (date != null) {
        return date;
      }
    }
    return DateTime.now();
  }

  static Future<void> deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Utils.showSnackBar(message: "something_went_wrong".tr, success: false);
      return;
    }

    Utils.showProgressDialog();

    try {
      await user.delete();

      Get.back();

      try {
        await FirebaseAuth.instance.signOut();
      } catch (_) {
        // Ignore signout errors after successful deletion
      }

      Get.offAllNamed(AppRoutes.LOGIN_VIEW);

      Utils.showSnackBar(message: "account_deleted".tr, success: true);
    } on FirebaseAuthException catch (e) {
      Get.back();

      if (e.code == 'requires-recent-login') {
        Utils.showSnackBar(message: "login_again_to_delete".tr, success: false);
      } else {
        Utils.showSnackBar(message: "account_delete_failed".tr, success: false);
      }
    } catch (e) {
      Get.back();
      Utils.showSnackBar(message: "something_went_wrong".tr, success: false);
    }
  }

  static Future<void> exportVehicleData() async {
    Get.back();
    try {
      if (appService.currentVehicleId.value.isEmpty) {
        Utils.showSnackBar(
          message: "vehicle_must_be_selected_first".tr,
          success: false,
        );
        return;
      }

      Utils.showProgressDialog();

      final functions = FirebaseFunctions.instance;
      final result = await functions.httpsCallable('exportVehicleData').call({
        "vehicleId": appService.currentVehicleId.value,
      });

      final data = result.data;
      final jsonString = jsonEncode(data);

      // Save to file
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else {
        directory = await getDownloadsDirectory();
      }

      if (directory == null || !await directory.exists()) {
        directory = await getApplicationDocumentsDirectory(); // Fallback
      }
      final fileName =
          "Vehicle_${appService.vehicleModel.value.name}_${appService.vehicleModel.value.manufacturer}_${appService.vehicleModel.value.modelYear}_${DateTime.now().millisecondsSinceEpoch}.json";
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(jsonString);

      if (Get.isDialogOpen == true) Get.back();

      // Share/Download
      // ignore:      // Share/Download
      // await Share.shareXFiles([XFile(file.path)], text: 'Vehicle Data Export');

      Utils.showSnackBar(message: "Backup saved successfully", success: true);
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      debugPrint("Error exporting data: $e");
      Utils.showSnackBar(message: "Failed to export data", success: false);
    }
  }
}
