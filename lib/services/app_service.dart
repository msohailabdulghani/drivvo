import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drivvo/model/app_user.dart';
import 'package:drivvo/model/date_range_model.dart';
import 'package:drivvo/model/vehicle/vehicle_model.dart';
import 'package:drivvo/modules/admin/home/home_controller.dart';
import 'package:drivvo/modules/admin/reports/reports_controller.dart';
import 'package:drivvo/modules/driver/home/driver_home_controller.dart';
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
  final driverVehicleModel = VehicleModel().obs;

  static AppService get to => Get.find();

  bool onBoarding = false;
  var allVehiclesCount = 0.obs;

  var currentVehicleId = "".obs;

  var driverCurrentVehicleId = "".obs;

  var refuelingFilter = true.obs;
  var expenseFilter = true.obs;
  var incomeFilter = true.obs;
  var serviceFilter = true.obs;
  var routeFilter = true.obs;
  var selectedDateRange = Rxn<DateRangeModel>();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  StreamSubscription? _userSubscription;
  StreamSubscription? _vehicleSubscription;
  StreamSubscription? _driverVehicleSubscription;
  bool _isInitializingSubscriptions = false;

  String _languageCode = "";
  String _countryCode = "";
  var savedLanguage = "";
  var notificationTime = "".obs;

  var gasUnit = "m³".obs;
  var fuelUnit = "Liter (L)".obs;
  var selectedDateFormat = "dd MMM yyyy".obs;

  // Currency format observables
  var selectedCurrencySymbol = "Rs".obs;
  var selectedCurrencyCode = "PKR".obs;
  var selectedCurrencyFormat = "Rs 1,000.00".obs;
  var selectedCurrencyName = "Pakistani Rupee".obs;

  final connected = false.obs;
  StreamSubscription<List<ConnectivityResult>>? _connectionSubscription;
  StreamSubscription<User?>? _authSubscription;

  Future<AppService> init() async {
    // Initial connectivity check
    final result = await Connectivity().checkConnectivity();
    _updateStatus(result);

    // Listen for changes
    _connectionSubscription = Connectivity().onConnectivityChanged.listen((
      result,
    ) {
      _updateStatus(result);
    });

    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  void _updateStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi)) {
      connected.value = true;
    } else {
      connected.value = false;
    }
  }

  Locale get locale => Locale(_languageCode, _countryCode);

  @override
  Future<void> onInit() async {
    super.onInit();

    // Listen to Auth changes to keep user data in sync
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((
      User? firebaseUser,
    ) async {
      if (firebaseUser != null) {
        await getUserProfile();
      } else {
        appUser.value = AppUser();
      }
    });

    onBoarding = _box.read<bool>(Constants.ONBOARDING) ?? false;
    allVehiclesCount.value = _box.read<int>(Constants.ALL_VEHICLES_COUNT) ?? 0;

    refuelingFilter.value = _box.read<bool>(Constants.REFUELING_FILTER) ?? true;
    expenseFilter.value = _box.read<bool>(Constants.EXPENSE_FILTER) ?? true;
    incomeFilter.value = _box.read<bool>(Constants.INCOME_FILTER) ?? true;
    serviceFilter.value = _box.read<bool>(Constants.SERVICE_FILTER) ?? true;
    routeFilter.value = _box.read<bool>(Constants.ROUTE_FILTER) ?? true;

    currentVehicleId.value =
        _box.read<String>(Constants.CURRENT_VEHICLE_ID) ?? "";
    driverCurrentVehicleId.value =
        _box.read<String>(Constants.DRIVER_CURRENT_VEHICLE_ID) ?? "";

    selectedDateFormat.value =
        _box.read<String>(Constants.DATE_FORMAT) ?? "dd MMM yyyy";
    fuelUnit.value = _box.read<String>(Constants.FUEL_UNIT) ?? "Liter (L)";
    gasUnit.value = _box.read<String>(Constants.GAS_UNIT) ?? "m³";
    notificationTime.value = _box.read<String>(Constants.NOTIFICATION_TIME) ?? "";

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
    await getDriverCurrentVehicle();
    await getAllVehicleList();
  }

  Future<void> getUserProfile() async {
    // Prevent concurrent initialization
    if (_isInitializingSubscriptions) {
      debugPrint("getUserProfile: Already initializing, skipping");
      return;
    }

    try {
      _isInitializingSubscriptions = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _isInitializingSubscriptions = false;
        return;
      }

      // Cancel existing subscription before creating new one to prevent leaks
      await _userSubscription?.cancel();
      _userSubscription = null;

      final completer = Completer<void>();
      bool isFirst = true;
      bool isCompleted = false;

      _userSubscription = db
          .collection(DatabaseTables.USER_PROFILE)
          .doc(user.uid)
          .snapshots()
          .listen(
            (docSnapshot) {
              try {
                if (docSnapshot.exists) {
                  Map<String, dynamic>? data = docSnapshot.data();
                  if (data != null) {
                    final userData = AppUser.fromJson(data);
                    setProfile(userData);
                  }
                }
                if (isFirst && !isCompleted) {
                  isFirst = false;
                  isCompleted = true;
                  completer.complete();
                  _isInitializingSubscriptions = false;
                }
              } catch (e) {
                debugPrint("Error processing user profile snapshot: $e");
              }
            },
            onError: (e) {
              debugPrint("getUserProfile stream error: $e");
              // Cancel subscription on error to prevent memory leaks
              _userSubscription?.cancel();
              _userSubscription = null;
              _isInitializingSubscriptions = false;
              if (isFirst && !isCompleted) {
                isFirst = false;
                isCompleted = true;
                completer.completeError(e);
              }
            },
            cancelOnError: false, // We handle cancellation manually
          );

      return completer.future;
    } catch (e) {
      _isInitializingSubscriptions = false;
      debugPrint("getUserProfile error: $e");
      // Ensure subscription is canceled on exception
      await _userSubscription?.cancel();
      _userSubscription = null;
      rethrow;
    }
  }

  Future<void> getCurrentVehicle() async {
    try {
      if (currentVehicleId.value.isEmpty || appUser.value.id.isEmpty) {
        // Cancel subscription if conditions not met
        await _vehicleSubscription?.cancel();
        _vehicleSubscription = null;
        return;
      }

      // Cancel existing subscription before creating new one
      await _vehicleSubscription?.cancel();
      _vehicleSubscription = null;

      _vehicleSubscription = db
          .collection(DatabaseTables.USER_PROFILE)
          .doc(appUser.value.id)
          .collection(DatabaseTables.VEHICLES)
          .doc(currentVehicleId.value)
          .snapshots()
          .listen(
            (docSnapshot) async {
              try {
                if (docSnapshot.exists) {
                  Map<String, dynamic>? data = docSnapshot.data();
                  if (data != null) {
                    final vehicle = VehicleModel.fromJson(data);
                    await setVehicle(vehicle);
                  }
                  if (Get.isRegistered<HomeController>()) {
                    await Get.find<HomeController>().loadTimelineData();
                  }

                  if (Get.isRegistered<ReportsController>()) {
                    await Get.find<ReportsController>().calculateAllReports();
                  }
                }
              } catch (e) {
                debugPrint("Error processing vehicle snapshot: $e");
              }
            },
            onError: (e) {
              debugPrint("getCurrentVehicle stream error: $e");
              // Cancel subscription on error to prevent memory leaks
              _vehicleSubscription?.cancel();
              _vehicleSubscription = null;
            },
            cancelOnError: false, // We handle cancellation manually
          );

      return;
    } catch (e) {
      debugPrint("getCurrentVehicle error: $e");
      // Ensure subscription is canceled on exception
      await _vehicleSubscription?.cancel();
      _vehicleSubscription = null;
    }
  }

  Future<void> getDriverCurrentVehicle() async {
    try {
      if (driverCurrentVehicleId.value.isEmpty ||
          appUser.value.adminId.isEmpty) {
        // Cancel subscription if conditions not met
        await _driverVehicleSubscription?.cancel();
        _driverVehicleSubscription = null;
        return;
      }

      // Cancel existing subscription before creating new one
      await _driverVehicleSubscription?.cancel();
      _driverVehicleSubscription = null;

      _driverVehicleSubscription = db
          .collection(DatabaseTables.USER_PROFILE)
          .doc(appUser.value.adminId)
          .collection(DatabaseTables.VEHICLES)
          .doc(driverCurrentVehicleId.value)
          .snapshots()
          .listen(
            (docSnapshot) async {
              try {
                if (docSnapshot.exists) {
                  Map<String, dynamic>? data = docSnapshot.data();
                  if (data != null) {
                    final vehicle = VehicleModel.fromJson(data);
                    await setDriverVehicle(vehicle);
                  }

                  if (Get.isRegistered<DriverHomeController>()) {
                    await Get.find<DriverHomeController>().loadTimelineData();
                  }
                }
              } catch (e) {
                debugPrint("Error processing driver vehicle snapshot: $e");
              }
            },
            onError: (e) {
              debugPrint("getDriverCurrentVehicle stream error: $e");
              // Cancel subscription on error to prevent memory leaks
              _driverVehicleSubscription?.cancel();
              _driverVehicleSubscription = null;
            },
            cancelOnError: false, // We handle cancellation manually
          );

      return;
    } catch (e) {
      debugPrint("getDriverCurrentVehicle error: $e");
      // Ensure subscription is canceled on exception
      await _driverVehicleSubscription?.cancel();
      _driverVehicleSubscription = null;
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

  Future<void> setDriverVehicle(VehicleModel vehicle) async {
    driverVehicleModel.value = vehicle;
    await _box.write(Constants.DRIVER_VEHICLE, vehicle.toJson(vehicle.id));
  }

  Future<void> setDateFormat(String value) async {
    selectedDateFormat.value = value;
    await _box.write(Constants.DATE_FORMAT, value);
  }

  Future<void> setNotificationTime(String value) async {
    notificationTime.value = value;
    await _box.write(Constants.NOTIFICATION_TIME, value);
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

  Future<void> setDriverCurrentVehicleId(String id) async {
    driverCurrentVehicleId.value = id;
    await _box.write(Constants.DRIVER_CURRENT_VEHICLE_ID, id);
  }

  Future<void> setOnboarding({required bool value}) async {
    onBoarding = value;
    await _box.write(Constants.ONBOARDING, value);
  }

  // Future<void> setAllVehicleCount({required int count}) async {
  //   allVehilcesCount.value = count;
  //   await _box.write(Constants.ALL_VEHICLES_COUNT, count);
  // }

  Future<void> getAllVehicleList() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(DatabaseTables.USER_PROFILE)
          .doc(appUser.value.id)
          .collection(DatabaseTables.VEHICLES)
          .get();

      if (snapshot.docs.isNotEmpty) {
        allVehiclesCount.value = snapshot.docs.length;
        await _box.write(Constants.ALL_VEHICLES_COUNT, snapshot.docs.length);
        return;
      }
    } catch (e) {
      debugPrint("getAllVehicleList error: $e");
      return;
    }
    return;
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

  void changeLanguage(String langCode, String country) {
    _languageCode = langCode;
    _countryCode = country;
    _box.write(Constants.LANGUAGE_CODE, langCode);
    _box.write(Constants.COUNTRY_CODE, country);
    Get.updateLocale(Locale(langCode, country));
  }

  @override
  void onClose() {
    // Ensure all subscriptions are properly canceled
    _userSubscription?.cancel();
    _userSubscription = null;
    _vehicleSubscription?.cancel();
    _vehicleSubscription = null;
    _driverVehicleSubscription?.cancel();
    _driverVehicleSubscription = null;
    _connectionSubscription?.cancel();
    _connectionSubscription = null;
    _authSubscription?.cancel();
    _authSubscription = null;

    _isInitializingSubscriptions = false;
    super.onClose();
  }
}
