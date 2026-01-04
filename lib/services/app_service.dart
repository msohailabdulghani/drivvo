import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/app_user.dart';
import 'package:drivvo/model/date_range_model.dart';
import 'package:drivvo/model/vehicle/vehicle_model.dart';
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
  final vehicleModel = VehicleModel().obs;

  static AppService get to => Get.find();

  bool onBoarding = false;
  bool importData = false;
  var currentVehicleId = "".obs;
  var currentVehicle = "".obs;

  var refuelingFilter = true.obs;
  var expenseFilter = true.obs;
  var incomeFilter = true.obs;
  var serviceFilter = true.obs;
  var routeFilter = true.obs;
  var selectedDateRange = Rxn<DateRangeModel>();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  StreamSubscription? _userSubscription;
  StreamSubscription? _vehicleSubscription;

  String _languageCode = "";
  String _countryCode = "";
  var savedLanguage = "";

  var gasUnit = "m³".obs;
  var fuelUnit = "Liter (L)".obs;
  var selectedDateFormat = "dd MMM yyyy".obs;

  // Currency format observables
  var selectedCurrencySymbol = "Rs".obs;
  var selectedCurrencyCode = "PKR".obs;
  var selectedCurrencyFormat = "Rs 1,000.00".obs;
  var selectedCurrencyName = "Pakistani Rupee".obs;

  Future<AppService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  Locale get locale => Locale(_languageCode, _countryCode);

  @override
  Future<void> onInit() async {
    super.onInit();

    currentVehicleId.value =
        _box.read<String>(Constants.CURRENT_VEHICLE_ID) ?? "";
    selectedDateFormat.value =
        _box.read<String>(Constants.DATE_FORMAT) ?? "dd MMM yyyy";
    fuelUnit.value = _box.read<String>(Constants.FUEL_UNIT) ?? "Liter (L)";
    gasUnit.value = _box.read<String>(Constants.GAS_UNIT) ?? "m³";
    currentVehicle.value = _box.read<String>(Constants.CURRENT_VEHICLE) ?? "";
    onBoarding = _box.read<bool>(Constants.ONBOARDING) ?? false;
    importData = _box.read<bool>(Constants.IMPORT_DATA) ?? false;

    refuelingFilter.value = _box.read<bool>(Constants.REFUELING_FILTER) ?? true;
    expenseFilter.value = _box.read<bool>(Constants.EXPENSE_FILTER) ?? true;
    incomeFilter.value = _box.read<bool>(Constants.INCOME_FILTER) ?? true;
    serviceFilter.value = _box.read<bool>(Constants.SERVICE_FILTER) ?? true;
    routeFilter.value = _box.read<bool>(Constants.ROUTE_FILTER) ?? true;

    // Load saved currency format
    selectedCurrencySymbol.value =
        _box.read<String>(Constants.CURRENCY_SYMBOL) ?? "Rs";
    selectedCurrencyCode.value =
        _box.read<String>(Constants.CURRENCY_CODE) ?? "PKR";
    selectedCurrencyFormat.value =
        _box.read<String>(Constants.CURRENCY_FORMAT) ?? "Rs 1,000.00";
    selectedCurrencyName.value =
        _box.read<String>(Constants.CURRENCY_NAME) ?? "Pakistani Rupee";

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
    await getUserProfile();
    await getCurrentVehicle();
  }

  Future<void> getUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      _userSubscription?.cancel();

      final completer = Completer<void>();
      bool isFirst = true;

      _userSubscription = db
          .collection(DatabaseTables.USER_PROFILE)
          .doc(user.uid)
          .snapshots()
          .listen(
            (docSnapshot) {
              if (docSnapshot.exists) {
                Map<String, dynamic>? data = docSnapshot.data();
                if (data != null) {
                  final userData = AppUser.fromJson(data);
                  setProfile(userData);
                }
              }
              if (isFirst) {
                isFirst = false;
                completer.complete();
              }
            },
            onError: (e) {
              debugPrint("getUserProfile error: $e");
              if (isFirst) {
                isFirst = false;
                completer.completeError(e);
              }
            },
          );

      return completer.future;
    } catch (e) {
      debugPrint("getUserProfile error: $e");
    }
  }

  Future<void> getCurrentVehicle() async {
    try {
      if (currentVehicleId.value.isEmpty || appUser.value.id.isEmpty) {
        return;
      }

      _vehicleSubscription?.cancel();

      _vehicleSubscription = db
          .collection(DatabaseTables.USER_PROFILE)
          .doc(appUser.value.id)
          .collection(DatabaseTables.VEHICLES)
          .doc(currentVehicleId.value)
          .snapshots()
          .listen(
            (docSnapshot) {
              if (docSnapshot.exists) {
                Map<String, dynamic>? data = docSnapshot.data();
                if (data != null) {
                  final vehicle = VehicleModel.fromJson(data);
                  setVehicle(vehicle);
                }
              }
            },
            onError: (e) {
              debugPrint("getUserProfile error: $e");
            },
          );

      return;
    } catch (e) {
      debugPrint("getUserProfile error: $e");
    }
  }

  Future<void> setProfile(AppUser user) async {
    appUser.value = user;
    await _box.write(Constants.USER_PROFILE, user.toJson());
  }

  Future<void> setVehicle(VehicleModel vehicle) async {
    vehicleModel.value = vehicle;
    await _box.write(Constants.Vehicle, vehicle.toJson(vehicle.id));
  }

  Future<void> setDateFormat(String value) async {
    selectedDateFormat.value = value;
    await _box.write(Constants.DATE_FORMAT, value);
  }

  Future<void> setCurrencyFormat({
    required String symbol,
    required String code,
    required String format,
    required String name,
  }) async {
    selectedCurrencySymbol.value = symbol;
    selectedCurrencyCode.value = code;
    selectedCurrencyFormat.value = format;
    selectedCurrencyName.value = name;
    await _box.write(Constants.CURRENCY_SYMBOL, symbol);
    await _box.write(Constants.CURRENCY_CODE, code);
    await _box.write(Constants.CURRENCY_FORMAT, format);
    await _box.write(Constants.CURRENCY_NAME, name);
  }

  Future<void> setFuelUnit(String unit) async {
    fuelUnit.value = unit;
    await _box.write(Constants.FUEL_UNIT, unit);
  }

  Future<void> setGasUnit(String unit) async {
    gasUnit.value = unit;
    await _box.write(Constants.GAS_UNIT, unit);
  }

  Future<void> setCurrentVehicleId(String id) async {
    currentVehicleId.value = id;
    await _box.write(Constants.CURRENT_VEHICLE_ID, id);
  }

  Future<void> setCurrentVehicle(String name) async {
    currentVehicle.value = name;
    await _box.write(Constants.CURRENT_VEHICLE, name);
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
      _userSubscription?.cancel();
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

    Utils.showProgressDialog();

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

  @override
  void onClose() {
    _userSubscription?.cancel();
    super.onClose();
  }
}
