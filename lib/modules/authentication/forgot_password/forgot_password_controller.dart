import 'package:drivvo/services/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final formStateKey = GlobalKey<FormState>();
  late AppService appService;
  TextEditingController emailController = TextEditingController();

  var loading = false.obs;

  var email = "";

  var registeredEmail = "".obs;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();
    getProfile();
  }

  Future<void> onTapForgot() async {
    // if (formStateKey.currentState?.validate() == true) {
    //   formStateKey.currentState?.save();
    //   if (email.isNotEmpty) {
    //     try {
    //       loading.value = true;
    //       await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    //       loading.value = false;
    //       Get.back();
    //       Utils.showSnackBar(
    //         message: "password_reset_link_sent",
    //         success: true,
    //       );
    //     } on FirebaseAuthException catch (e) {
    //       if (e.code == "user-not-found") {
    //         Get.back();
    //         Utils.showSnackBar(message: "no_user_found", success: false);
    //       } else if (e.code == "invalid-email") {
    //         Get.back();
    //         Utils.showSnackBar(
    //           message: "invalid_email_address",
    //           success: false,
    //         );
    //       } else {
    //         Get.back();
    //         Utils.showSnackBar(message: "something_went_wrong", success: false);

    //         loading.value = false;
    //       }
    //     } finally {
    //       loading.value = false;
    //     }
    //   }
    // }
  }

  Future<void> getProfile() async {
    // var docSnapshot = await FirebaseFirestore.instance
    //     .collection(Constants.USER_PROFILE)
    //     .doc(appService.appUser.value.id)
    //     .get();
    // if (docSnapshot.exists) {
    //   Map<String, dynamic>? data = docSnapshot.data();
    //   if (data != null) {
    //     final user = AppUser.fromJson(data);
    //     registeredEmail.value = user.email;
    //   }
    // }
  }
}
