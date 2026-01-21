import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/app_user.dart';
import 'package:drivvo/model/general_model.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/services/iap_service.dart';
import 'package:drivvo/utils/common_function.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  String email = "";
  String password = "";
  late AppService appService;
  final formStateKey = GlobalKey<FormState>();

  var showPwd = true.obs;

  final google = GoogleSignIn();
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();
  }

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  Future<void> onTapLogin() async {
    if (formStateKey.currentState?.validate() == true) {
      formStateKey.currentState?.save();
      Utils.showProgressDialog();
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final user = auth.currentUser;
        if (user != null) {
          await naviagteToMain(user, false);
          await appService.getUserProfile();
        } else {
          Get.back();
          Utils.showSnackBar(message: "authentication_failed", success: false);
        }
      } on FirebaseAuthException catch (e) {
        Utils.getFirebaseException(e);
      } catch (e) {
        Get.back();
        Utils.showSnackBar(message: "something_wrong".tr, success: false);
      }
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await google.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      Utils.showProgressDialog();

      final userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        var id = user.uid;

        final map = <String, dynamic>{};
        final snapshot = await FirebaseFirestore.instance
            .collection(DatabaseTables.USER_PROFILE)
            .doc(id)
            .get();

        map["id"] = id;
        map["email"] = user.email;
        map["name"] = user.displayName;
        map["photoUrl"] = user.photoURL;
        map["sign_in_method"] = Constants.GOOGLE;

        if (!snapshot.exists) {
          map["last_odometer"] = 0;
          map["user_type"] = Constants.ADMIN;
        }

        await db
            .collection(DatabaseTables.USER_PROFILE)
            .doc(id)
            .set(map, SetOptions(merge: true));

        await naviagteToMain(user, true);
        await appService.getUserProfile();

        if (userCredential.additionalUserInfo?.isNewUser == true) {
          await saveData();
        }
      } else {
        Get.back();
      }
    } catch (e) {
      Get.back();
      Utils.showSnackBar(message: "google_signin_failed", success: false);
      return null;
    }
    return null;
  }

  Future<User?> signInWithApple() async {
    try {
      Utils.showProgressDialog();

      final appleProvider = AppleAuthProvider()
        ..addScope('email')
        ..addScope('name');

      final userCredential = await FirebaseAuth.instance.signInWithProvider(
        appleProvider,
      );

      final user = userCredential.user;
      if (user == null) {
        Get.back();
        return null;
      }

      final id = user.uid;
      final docRef = FirebaseFirestore.instance
          .collection(DatabaseTables.USER_PROFILE)
          .doc(id);

      final snapshot = await docRef.get();
      final map = <String, dynamic>{"id": id, "photoUrl": user.photoURL};

      if (user.email != null) {
        map["email"] = user.email;
      }

      if (user.displayName != null) {
        map["name"] = user.displayName;
      }

      if (!snapshot.exists) {
        map["sign_in_method"] = Constants.APPLE;
        map["last_odometer"] = 0;
        map["user_type"] = Constants.ADMIN;
      }

      await docRef.set(map, SetOptions(merge: true));

      await naviagteToMain(user, true);
      await appService.getUserProfile();

      if (userCredential.additionalUserInfo?.isNewUser == true) {
        await saveData();
      }

      return user;
    } catch (e, stack) {
      debugPrint("Apple Sign In Error: $e");
      debugPrintStack(stackTrace: stack);
      Get.back();
      Utils.showSnackBar(message: "apple_signin_failed", success: false);
      return null;
    }
  }

  Future<void> naviagteToMain(User user, bool google) async {
    if (google) {
      final appUser = AppUser();
      appUser.id = user.uid;
      appUser.email = user.email ?? "";
      appUser.firstName = user.displayName ?? "";
      appService.setProfile(appUser);
    }

    final snapshot = await FirebaseFirestore.instance
        .collection(DatabaseTables.USER_PROFILE)
        .doc(user.uid)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data();
      if (data != null) {
        Get.back(closeOverlays: true);
        final userData = AppUser.fromJson(data);
        await appService.setProfile(userData);

        try {
          await appService.getAllVehicleList();
        } catch (e) {
          debugPrint("Error fetching vehicle list: $e");
        }

        if (appService.appUser.value.userType == Constants.ADMIN) {
          if (appService.allVehiclesCount.value > 0) {
            Get.offAllNamed(AppRoutes.ADMIN_ROOT_VIEW);
          } else {
            Get.offAllNamed(AppRoutes.IMPORT_DATA_VIEW, arguments: false);
            // Get.offAllNamed(AppRoutes.CREATE_VEHICLES_VIEW, arguments: true);
          }
        } else {
          try {
            await CommonFunction.checkAdminSubscription(
              adminId: appService.appUser.value.adminId,
            );
          } catch (e) {
            debugPrint("Error: $e");
          }
          Get.offAllNamed(AppRoutes.DRIVER_ROOT_VIEW);
        }

        try {
          await IAPService.to.checkSubscriptionStatus();
        } catch (e) {
          // Log error but continue navigation
          debugPrint('Failed to check subscription status (Login): $e');
        }
      } else {
        Get.back();
      }
    } else {
      Get.back(closeOverlays: true);
      Utils.showSnackBar(message: "something_wrong".tr, success: false);
      return;
    }
  }

  Future<void> saveData() async {
    String? collectionPath;
    List<GeneralModel> generalList = [];

    for (int i = 0; i < 6; i++) {
      switch (i) {
        case 0:
          collectionPath = DatabaseTables.EXPENSE_TYPES;
          break;
        case 1:
          collectionPath = DatabaseTables.INCOME_TYPES;
          break;
        case 2:
          collectionPath = DatabaseTables.SERVICE_TYPES;
          break;
        case 3:
          collectionPath = DatabaseTables.PAYMENT_METHOD;
          break;
        case 4:
          collectionPath = DatabaseTables.REASONS;
          break;
        case 5:
          collectionPath = DatabaseTables.FUEL;
          break;
        default:
          debugPrint("Unknown title: $i");
          return;
      }
      if (collectionPath.isNotEmpty) {
        generalList.clear();
        try {
          final snapshot = await db.collection(collectionPath).get();

          if (snapshot.docs.isNotEmpty) {
            generalList = snapshot.docs.map((doc) {
              return GeneralModel.fromJson(doc.data());
            }).toList();

            if (generalList.isNotEmpty) {
              for (var e in generalList) {
                final map = e.toJson();

                await FirebaseFirestore.instance
                    .collection(DatabaseTables.USER_PROFILE)
                    .doc(appService.appUser.value.id)
                    .collection(collectionPath)
                    .doc()
                    .set(map);
              }
            }
          } else {
            debugPrint("No data found in $collectionPath");
          }
        } catch (e) {
          debugPrint("Error fetching $collectionPath: $e");
        }
      }
    }
  }
}
