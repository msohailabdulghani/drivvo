import 'dart:async';

import 'package:drivvo/model/app_user.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppService extends GetxService {
  late GetStorage _box;
  final appUser = AppUser().obs;

  static AppService get to => Get.find();

  bool onBoarding = false;
  //final FirebaseFirestore db = FirebaseFirestore.instance;

  String _languageCode = "";
  String _countryCode = "";

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
    // final user = FirebaseAuth.instance.currentUser;
    // if (user == null) {
    //   return;
    // }

    // // Refresh user profile (use Firebase UID)
    // var docSnapshot = await db
    //     .collection(DatabaseTables.USER_PROFILE)
    //     .doc(user.uid)
    //     .get();
    // if (docSnapshot.exists) {
    //   Map<String, dynamic>? data = docSnapshot.data();
    //   if (data != null) {
    //     final userData = AppUser.fromJson(data);
    //     setProfile(userData);
    //   }
    // }
  }

  Future<void> setProfile(AppUser user) async {
    appUser.value = user;
    await _box.write(Constants.USER_PROFILE, user.toJson());
  }

  Future<void> setBoring({required bool value}) async {
    onBoarding = value;
    await _box.write(Constants.ONBOARDING, value);
  }

  Future<void> logOut() async {
    // if (appUser.value.signInMethod == Constants.GOOGLE) {
    //   await GoogleSignIn().signOut();
    // } else if (appUser.value.signInMethod == Constants.FACEBOOK) {
    //   await FacebookAuth.instance.logOut();
    // }
    // setProfile(AppUser());
    // setIsUserLogin(false);
    // await FirebaseAuth.instance.signOut();
    Get.offAllNamed(AppRoutes.LOGIN);
    Utils.showSnackBar(message: "You have been logout.", success: true);
  }

  void changeLanguage(String langCode, String country) {
    _languageCode = langCode;
    _countryCode = country;
    _box.write(Constants.LANGUAGE_CODE, langCode);
    _box.write(Constants.COUNTRY_CODE, country);
    Get.updateLocale(Locale(langCode, country));
  }


}
