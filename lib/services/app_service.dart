import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/app_user.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppService extends GetxService {
  late GetStorage _box;
  final appUser = AppUser().obs;

  static AppService get to => Get.find();

  bool onBoarding = false;
  bool importData = false;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  String _languageCode = "";
  String _countryCode = "";
  var savedLanguage = "";

  Future<AppService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  Locale get locale => Locale(_languageCode, _countryCode);

  @override
  Future<void> onInit() async {
    super.onInit();

    onBoarding = _box.read<bool>(Constants.ONBOARDING) ?? false;
    importData = _box.read<bool>(Constants.IMPORT_DATA) ?? false;

    //for the needs in setting
    savedLanguage = _box.read<String>(Constants.LANGUAGE_CODE) ?? 'en';

    _languageCode =
        _box.read<String>(Constants.LANGUAGE_CODE) ??
        Constants.DEFAULT_LANGUAGE_CODE;
    _countryCode =
        _box.read<String>(Constants.COUNTRY_CODE) ??
        Constants.DEFAULT_COUNTRY_CODE;

    // Load and apply saved language
    final savedLanguageCode =
        _box.read<String>(Constants.LANGUAGE_CODE) ?? 'en';
    final locale = Locale(savedLanguageCode);
    Get.updateLocale(locale);

    dynamic user = _box.read(Constants.USER_PROFILE);
    if (user == null) {
      return;
    }
    appUser.value = AppUser.fromJson(user);
    getUserProfile();
  }

  Future<void> getUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }
      var docSnapshot = await db
          .collection(DatabaseTables.USER_PROFILE)
          .doc(user.uid)
          .get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        if (data != null) {
          final userData = AppUser.fromJson(data);
          setProfile(userData);
        }
      }
    } catch (e) {
      Utils.showSnackBar(message: "Failed to load profile", success: false);
    }
  }

  Future<void> setProfile(AppUser user) async {
    appUser.value = user;
    await _box.write(Constants.USER_PROFILE, user.toJson());
  }

  Future<void> setOnboarding({required bool value}) async {
    onBoarding = value;
    await _box.write(Constants.ONBOARDING, value);
  }

  Future<void> setImportData({required bool value}) async {
    importData = value;
    await _box.write(Constants.IMPORT_DATA, value);
  }

  Future<void> logOut() async {
    try {
      if (appUser.value.signInMethod == Constants.GOOGLE) {
        await GoogleSignIn().signOut();
      }
      await FirebaseAuth.instance.signOut();
      setProfile(AppUser());
      Get.offAllNamed(AppRoutes.LOGIN_VIEW);
      Utils.showSnackBar(message: "You have been logged out.", success: true);
    } catch (e) {
      Utils.showSnackBar(
        message: "Failed to logout. Please try again.",
        success: false,
      );
    }
  }

  Future<void> deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Utils.showSnackBar(message: "something_went_wrong".tr, success: false);
      return;
    }

    Utils.showProgressDialog(Get.context!);

    try {
      await user.delete();

      Get.back(); // close progress dialog
      await FirebaseAuth.instance.signOut();

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

  void changeLanguage(String langCode, String country) {
    _languageCode = langCode;
    _countryCode = country;
    _box.write(Constants.LANGUAGE_CODE, langCode);
    _box.write(Constants.COUNTRY_CODE, country);
    Get.updateLocale(Locale(langCode, country));
  }
}
