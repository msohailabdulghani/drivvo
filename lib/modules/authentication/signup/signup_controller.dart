import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/app_user.dart';
import 'package:drivvo/model/general_model.dart';
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

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
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
      Utils.showProgressDialog();

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
          map["first_name"] = firstNameController.text.trim();
          map["last_name"] = lastNameController.text.trim();
          map["sign_in_method"] = "email";
          map["last_odometer"] = 0;
          map["user_type"] = Constants.ADMIN;

          // Try to write the user profile to Firestore with a limited retry.
          const int maxRetries = 2;
          int attempt = 0;
          bool writeSucceeded = false;

          while (!writeSucceeded && attempt < maxRetries) {
            try {
              attempt++;
              await db.collection(DatabaseTables.USER_PROFILE).doc(id).set(map);
              writeSucceeded = true;
            } catch (writeError) {
              debugPrint(
                'Firestore write attempt $attempt failed: $writeError',
              );
              if (attempt < maxRetries) {
                await Future.delayed(const Duration(milliseconds: 300));
                continue;
              }

              // All retries exhausted — roll back the newly created Auth user.
              Get.back(); // close progress dialog

              try {
                await user.delete();
                debugPrint(
                  'Rolled back auth user after Firestore failure (id=$id)',
                );
              } catch (deleteError) {
                debugPrint(
                  'Failed to delete auth user during rollback: $deleteError',
                );
              }

              Utils.showSnackBar(message: 'save_data_failed', success: false);
              return;
            }
          }

          // If we reach here, Firestore write succeeded.
          Get.back();

          final appUser = AppUser();
          appUser.id = id;
          appUser.email = emailController.text;
          appUser.firstName = firstNameController.text;
          appUser.lastName = lastNameController.text;

          appService.setProfile(appUser);

          firstNameController.text = "";
          lastNameController.text = "";
          emailController.text = "";
          passwordController.text = "";
          formStateKey.currentState?.reset();

          Utils.showSnackBar(message: "user_registered_success", success: true);

          await saveData();
          Future.delayed(const Duration(milliseconds: 500), () {
            Get.offAllNamed(AppRoutes.LOGIN_VIEW);
          });
        }
      } on FirebaseAuthException catch (e) {
        Utils.getFirebaseException(e);
      } catch (e) {
        Get.back();
        Utils.showSnackBar(message: 'save_data_failed', success: false);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
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
