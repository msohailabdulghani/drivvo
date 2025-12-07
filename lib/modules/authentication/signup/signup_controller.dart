import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  late AppService appService;

  final formStateKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var showPwd = true.obs;
  var showConPwd = true.obs;

  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();
  }

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  Future<void> onTapSignUp() async {
    if (formStateKey.currentState?.validate() == true) {
      formStateKey.currentState?.save();
      Utils.showProgressDialog(Get.context!);
      try {
        UserCredential userCredential = await auth
            .createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );

        User? user = userCredential.user;
        if (user != null) {
          final id = user.uid;
          final map = <String, dynamic>{};

          map["id"] = id;
          map["email"] = emailController.text;
          map["name"] = nameController.text;
          map["phone"] = "";
          map["photoUrl"] = "";
          map["sign_in_method"] = "email";

          await db
              .collection(DatabaseTables.USER_PROFILE)
              .doc(id)
              .set(map)
              .then((_) {
                Get.back();
                nameController.text = "";
                emailController.text = "";
                passwordController.text = "";
                formStateKey.currentState?.reset();

                Utils.showSnackBar(
                  message: "user_registered_success",
                  success: true,
                );
                Future.delayed(const Duration(milliseconds: 500), () {
                  Get.offAllNamed(AppRoutes.LOGIN_VIEW);
                });
              })
              .catchError((error) {
                Get.back();
                Utils.showSnackBar(message: "save_data_failed", success: false);
              });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          Get.back();
          Utils.showSnackBar(message: "email_already_in_use", success: false);
        } else if (e.code == 'weak-password') {
          Get.back();
          Utils.showSnackBar(message: "weak_password", success: false);
        }
      } catch (e) {
        Get.back();
        Utils.showSnackBar(message: 'save_data_failed', success: false);
      }
    }
  }
}
