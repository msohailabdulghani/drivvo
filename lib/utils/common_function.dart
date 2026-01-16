import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/app_user.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
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
}
