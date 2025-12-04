import 'package:drivvo/services/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  late AppService appService;

  final formStateKey = GlobalKey<FormState>();

  String email = "";
  String password = "";

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var showPwd = false.obs;
  var showConPwd = false.obs;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();
  }

  Future<void> onTapSignUp() async {
    if (formStateKey.currentState?.validate() == true) {
      formStateKey.currentState?.save();
      //   Utils.showProgressDialog(Get.context!);
      //   try {
      //     UserCredential userCredential = await auth
      //         .createUserWithEmailAndPassword(
      //           email: emailController.text,
      //           password: passwordController.text,
      //         );

      //     User? user = userCredential.user;
      //     if (user != null) {
      //       final id = user.uid;
      //       final map = <String, dynamic>{};

      //       map["id"] = id;
      //       map["email"] = emailController.text;
      //       map["name"] = "";
      //       map["phone"] = "";
      //       map["photoUrl"] = "";
      //       map["sign_in_method"] = "email";

      //       await db
      //           .collection(DatabaseTables.USER_PROFILE)
      //           .doc(id)
      //           .set(map)
      //           .then((_) {
      //             final appUser = AppUser();
      //             appUser.id = id;
      //             appUser.email = emailController.text;

      //             selectedTabIndex.value = 0;

      //             appService.setProfile(appUser);
      //           })
      //           .catchError((error) {
      //             Get.back();
      //             Utils.showSnackBar(message: "Error: $error", success: false);
      //           });
      //     }

      //     Get.back();

      //     emailController.text = "";
      //     passwordController.text = "";
      //     confirmPasswordController.text = "";
      //     signinFormStateKey.currentState?.reset();

      //     Utils.showSnackBar(message: "user_registered_success", success: true);
      //   } on FirebaseAuthException catch (e) {
      //     if (e.code == 'email-already-in-use') {
      //       Get.back();
      //       Utils.showSnackBar(message: "email_already_in_use", success: false);
      //     } else if (e.code == 'weak-password') {
      //       Get.back();
      //       Utils.showSnackBar(message: "weak_password", success: false);
      //     }
      //   } catch (e) {
      //     Get.back();
      //     Utils.showSnackBar(message: 'Error ${e.toString()}', success: false);
      //   }
    }
  }
}
