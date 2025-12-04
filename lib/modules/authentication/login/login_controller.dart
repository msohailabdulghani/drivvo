import 'package:drivvo/services/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formStateKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  late AppService appService;

  var showPwd = false.obs;

  // final FirebaseFirestore db = FirebaseFirestore.instance;
  // final GoogleSignIn google = GoogleSignIn();

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();
  }

  Future<void> onTapLogin() async {
    if (formStateKey.currentState?.validate() == true) {
      formStateKey.currentState?.save();
      // Utils.showProgressDialog(Get.context!);
      // try {
      //   await FirebaseAuth.instance
      //       .signInWithEmailAndPassword(
      //         email: loginEmail,
      //         password: loginPassword,
      //       )
      //       .then((e) async {
      //         var docSnapshot = await db
      //             .collection(DatabaseTables.USER_PROFILE)
      //             .doc(appService.appUser.value.id)
      //             .get();
      //         if (docSnapshot.exists) {
      //           Map<String, dynamic>? data = docSnapshot.data();
      //           if (data != null) {
      //             final user = AppUser.fromJson(data);
      //             appService.appUser.value = user;
      //             appService.setProfile(user);
      //           }
      //         }

      //         // Ensure user data is loaded and subscription is checked
      //         // await appService.refreshUserData();
      //         await IAPService.to.checkSubscriptionStatus();
      //         appService.setIsUserLogin(true);
      //         Get.back();
      //         navigateToNext();
      //       });
      // } on FirebaseAuthException catch (e) {
      //   if (e.code == "user-not-found") {
      //     Get.back();
      //     Utils.showSnackBar(message: "no_user_found", success: false);
      //   } else if (e.code == "wrong-password") {
      //     Get.back();
      //     Utils.showSnackBar(message: "wrong_password", success: false);
      //   } else if (e.code == "invalid-credential") {
      //     Get.back();
      //     Utils.showSnackBar(
      //       message: "invalid_email_or_password",
      //       success: false,
      //     );
      //   } else if (e.code == "too-many-requests") {
      //     Get.back();
      //     Utils.showSnackBar(message: "too_many_requests", success: false);
      //   }
      // } finally {
      //   isLoading.value = false;
      // }
    }
  }

  // Future<User?> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await google.signIn();
  //     if (googleUser == null) return null;

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     Utils.showProgressDialog(Get.context!);

  //     final userCredential = await auth.signInWithCredential(credential);
  //     final user = userCredential.user;

  //     if (user != null) {
  //       var id = user.uid;

  //       final map = <String, dynamic>{};

  //       map["id"] = id;
  //       map["email"] = user.email;
  //       map["name"] = user.displayName;
  //       map["phone"] = "";
  //       map["photoUrl"] = user.photoURL;
  //       map["sign_in_method"] = Constants.GOOGLE;

  //       await db
  //           .collection(DatabaseTables.USER_PROFILE)
  //           .doc(id)
  //           .set(map, SetOptions(merge: true))
  //           .then((_) async {
  //             final appUser = AppUser();
  //             appUser.id = id;
  //             appUser.email = emailController.text;
  //             appUser.name = user.displayName ?? "";
  //             appService.setProfile(appUser);
  //             Get.back();
  //             Get.back();
  //             navigateToNext();
  //             appService.refreshUserData();
  //             // Ensure user data is loaded and subscription is checked
  //             // await appService.refreshUserData();
  //             await IAPService.to.checkSubscriptionStatus();
  //             appService.setIsUserLogin(true);
  //           })
  //           .catchError((error) {
  //             Get.back();
  //             Utils.showSnackBar(message: "Error: $error", success: false);
  //           });
  //     }
  //   } catch (e) {
  //     Get.back();
  //     debugPrint('Google sign-in failed: $e');
  //     return null;
  //   }
  //   return null;
  // }

  // void navigateToNext() async {
  //   bool hasData = await isUserExist();

  //   if (hasData) {
  //     Get.offAllNamed(AppRoutes.ROOT_VIEW);
  //   } else {
  //     Get.offAllNamed(AppRoutes.MODE);
  //   }
  // }

  // Future<bool> isUserExist() async {
  //   final user = auth.currentUser;
  //   if (user == null || user.uid.isEmpty) return false;

  //   try {
  //     final doc = await db
  //         .collection(DatabaseTables.BORDING)
  //         .doc(user.uid)
  //         .get();
  //     return doc.exists;
  //   } catch (_) {
  //     return false;
  //   }
  // }
}
