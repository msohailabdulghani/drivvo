import 'package:circular_menu/circular_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/app_user.dart';
import 'package:drivvo/model/timeline_entry.dart';
import 'package:drivvo/model/vehicle/vehicle_model.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  late AppService appService;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final GlobalKey<CircularMenuState> circularMenuKey =
      GlobalKey<CircularMenuState>();

  final now = DateTime.now();
  var appUser = AppUser();

  // Loading state
  var isLoading = true.obs;

  // Timeline entries grouped by month
  var groupedEntries = <String, List<TimelineEntry>>{}.obs;

  // All timeline entries sorted by date
  var allEntries = <TimelineEntry>[].obs;

  // Current vehicle
  var currentVehicle = VehicleModel().obs;

  var initialSelection = "".obs;
  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();
    loadTimelineData(forceFetch: true);
    loadCurrentVehicle();
  }

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  /// Get the count of disabled (filtered out) categories
  /// Returns the number of filters that are turned OFF
  int get disabledFilterCount {
    int count = 0;
    if (!appService.refuelingFilter.value) count++;
    if (!appService.expenseFilter.value) count++;
    if (!appService.incomeFilter.value) count++;
    if (!appService.serviceFilter.value) count++;
    if (!appService.routeFilter.value) count++;
    return count;
  }

  /// Check if any filter is applied (any category is hidden)
  bool get hasActiveFilter => disabledFilterCount > 0;

  // Track which timeline entry is currently expanded (by unique key)
  var expandedEntryKey = Rxn<String>();

  // Toggle expansion of a timeline entry
  void toggleEntryExpansion(String entryKey) {
    if (expandedEntryKey.value == entryKey) {
      expandedEntryKey.value = null; // Collapse if already expanded
    } else {
      expandedEntryKey.value = entryKey; // Expand this entry
    }
  }

  // Check if a specific entry is expanded
  bool isEntryExpanded(String entryKey) {
    return expandedEntryKey.value == entryKey;
  }

  // Refresh timeline data
  Future<void> refreshData() async {
    await loadTimelineData(forceFetch: true);
  }

  // Helper function to parse date string to DateTime
  DateTime parseDate(String dateStr) {
    try {
      // Try parsing "dd MMM yyyy" format (e.g., "17 Dec 2025")
      return DateFormat("dd MMM yyyy").parse(dateStr);
    } catch (e) {
      try {
        // Try parsing "dd/MM/yyyy" format
        return DateFormat("dd/MM/yyyy").parse(dateStr);
      } catch (e) {
        // Return current date as fallback
        return DateTime.now();
      }
    }
  }

  // Load current vehicle
  Future<void> loadCurrentVehicle() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final snapshot = await db
          .collection(DatabaseTables.USER_PROFILE)
          .doc(user.uid)
          .collection(DatabaseTables.VEHICLES)
          .where('active_vehicle', isEqualTo: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        currentVehicle.value = VehicleModel.fromJson(
          snapshot.docs.first.data(),
        );
      }
    } catch (e) {
      debugPrint("Error loading current vehicle: $e");
    }
  }

  Future<void> loadTimelineData({bool forceFetch = false}) async {
    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        isLoading.value = false;
        return;
      }

      if (forceFetch || appService.appUser.value.id.isEmpty) {
        var docSnapshot = await db
            .collection(DatabaseTables.USER_PROFILE)
            .doc(user.uid)
            .get();
        if (docSnapshot.exists) {
          Map<String, dynamic>? data = docSnapshot.data();
          if (data != null) {
            appUser = AppUser.fromJson(data);
            appService.setProfile(appUser);
          }
        }
      } else {
        appUser = appService.appUser.value;
      }

      final List<TimelineEntry> entries = [];

      if (appService.refuelingFilter.value) {
        for (var data in appUser.refuelingList) {
          if (data.vehicleId == appService.currentVehicleId.value) {
            entries.add(
              TimelineEntry(
                type: TimelineEntryType.refueling,
                title: 'refueling'.tr,
                date: data.date,
                odometer: data.odometer,
                amount: 'Rs${data.totalCost}',
                isIncome: false,
                icon: Icons.local_gas_station,
                iconBgColor: const Color(0xFFFB9601),
              ),
            );
          }
        }
      }

      if (appService.expenseFilter.value) {
        for (var data in appUser.expenseList) {
          if (data.vehicleId == appService.currentVehicleId.value) {
            entries.add(
              TimelineEntry(
                type: TimelineEntryType.expense,
                title: 'expense'.tr,
                odometer: data.odometer,
                date: data.date,
                amount: 'Rs${data.totalAmount}',
                isIncome: false,
                icon: Icons.receipt_long,
                iconBgColor: Colors.red,
              ),
            );
          }
        }
      }

      if (appService.serviceFilter.value) {
        for (var data in appUser.serviceList) {
          if (data.vehicleId == appService.currentVehicleId.value) {
            entries.add(
              TimelineEntry(
                type: TimelineEntryType.service,
                title: 'service'.tr,
                date: data.date,
                odometer: data.odometer,
                amount: 'Rs${data.totalAmount}',
                isIncome: false,
                icon: Icons.build,
                iconBgColor: Colors.brown,
              ),
            );
          }
        }
      }

      if (appService.incomeFilter.value) {
        for (var data in appUser.incomeList) {
          if (data.vehicleId == appService.currentVehicleId.value) {
            entries.add(
              TimelineEntry(
                type: TimelineEntryType.income,
                title: data.incomeType.isNotEmpty
                    ? data.incomeType
                    : 'income'.tr,
                date: data.date,
                odometer: data.odometer,
                amount: 'Rs${data.value}',
                isIncome: true,
                icon: Icons.attach_money,
                iconBgColor: Colors.green,
              ),
            );
          }
        }
      }

      if (appService.routeFilter.value) {
        for (var data in appUser.routeList) {
          if (data.vehicleId == appService.currentVehicleId.value) {
            entries.add(
              TimelineEntry(
                type: TimelineEntryType.route,
                title: data.destination,
                date: data.startDate,
                odometer: data.finalOdometer,
                amount: 'Rs${data.total}',
                isIncome: false,
                icon: Icons.route,
                iconBgColor: const Color(0xFF5E7E8D),
                routeOdometer:
                    "${data.initialOdometer} - ${data.finalOdometer}",
                routeStartDate: data.startDate,
                routeEndDate: data.endDate,
                origin: data.origin,
              ),
            );
          }
        }
      }

      // Filter entries by date range locally
      var filteredEntries = entries;
      final selectedRange = appService.selectedDateRange.value;
      if (selectedRange != null &&
          selectedRange.startDate != null &&
          selectedRange.endDate != null) {
        // Normalize search dates to start/end of day
        final startSearch = DateTime(
          selectedRange.startDate!.year,
          selectedRange.startDate!.month,
          selectedRange.startDate!.day,
        );
        final endSearch = DateTime(
          selectedRange.endDate!.year,
          selectedRange.endDate!.month,
          selectedRange.endDate!.day,
          23,
          59,
          59,
        );

        filteredEntries = entries.where((entry) {
          return entry.date.isAfter(
                startSearch.subtract(const Duration(seconds: 1)),
              ) &&
              entry.date.isBefore(endSearch.add(const Duration(seconds: 1)));
        }).toList();
      }

      // Sort entries by date (newest first)
      filteredEntries.sort((a, b) => b.date.compareTo(a.date));
      allEntries.value = filteredEntries;

      // Group entries by month-year
      final Map<String, List<TimelineEntry>> grouped = {};
      for (var entry in filteredEntries) {
        final key = entry.monthYearKey;
        if (!grouped.containsKey(key)) {
          grouped[key] = [];
        }
        grouped[key]!.add(entry);
      }
      groupedEntries.value = grouped;

      isLoading.value = false;
    } catch (e) {
      debugPrint("Error loading timeline data: $e");
      isLoading.value = false;
      Utils.showSnackBar(
        message: "Failed to load timeline data",
        success: false,
      );
    }
  }

  void selectVehicleError({required String routeName}) {
    if (appService.currentVehicleId.value.isEmpty) {
      Utils.showSnackBar(
        message: "vehicle_must_be_selected_first".tr,
        success: false,
      );
      return;
    }else{
      Get.toNamed(routeName);
    }
  }
  //! Load all timeline data from Firebase
  // Future<void> loadTimelineData() async {
  //   try {
  //     isLoading.value = true;
  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user == null) {
  //       isLoading.value = false;
  //       return;
  //     }

  //     final List<TimelineEntry> entries = [];

  //     final formater = DateFormat("dd MMM yyyy");

  //     // Load Refueling entries
  //     final refuelingSnapshot = await db
  //         .collection(DatabaseTables.USER_PROFILE)
  //         .doc(user.uid)
  //         .collection(DatabaseTables.REFUELING)
  //         .get();

  //     for (var doc in refuelingSnapshot.docs) {
  //       final data = RefuelingModel.fromJson(doc.data());
  //       entries.add(
  //         TimelineEntry(
  //           type: TimelineEntryType.refueling,
  //           title: 'refueling'.tr,
  //           odometer: '${data.odometer} km',
  //           // date: data.createdAt,
  //           date: formater.parse(data.date),
  //           amount: 'Rs${data.totalCost}',
  //           isIncome: false,
  //           icon: Icons.local_gas_station,
  //           iconBgColor: const Color(0xFFFB9601),
  //         ),
  //       );
  //     }

  //     // Load Expense entries
  //     final expenseSnapshot = await db
  //         .collection(DatabaseTables.USER_PROFILE)
  //         .doc(user.uid)
  //         .collection(DatabaseTables.EXPENSES)
  //         .get();

  //     for (var doc in expenseSnapshot.docs) {
  //       final data = ExpenseModel.fromJson(doc.data());
  //       entries.add(
  //         TimelineEntry(
  //           type: TimelineEntryType.expense,
  //           title: 'expense'.tr,
  //           odometer: '${data.odometer} km',
  //       // date: data.createdAt,
  //           date: formater.parse(data.date),
  //           amount: 'Rs${data.totalAmount}',
  //           isIncome: false,
  //           icon: Icons.receipt_long,
  //           iconBgColor: Colors.red,
  //         ),
  //       );
  //     }

  //     // Load Service entries
  //     final serviceSnapshot = await db
  //         .collection(DatabaseTables.USER_PROFILE)
  //         .doc(user.uid)
  //         .collection(DatabaseTables.SERVICES)
  //         .get();

  //     for (var doc in serviceSnapshot.docs) {
  //       final data = ServiceModel.fromJson(doc.data());
  //       entries.add(
  //         TimelineEntry(
  //           type: TimelineEntryType.service,
  //           title: 'service'.tr,
  //           odometer: '${data.odometer} km',
  //    // date: data.createdAt,
  //           date: formater.parse(data.date),
  //           amount: 'Rs${data.totalAmount}',
  //           isIncome: false,
  //           icon: Icons.build,
  //           iconBgColor: Colors.brown,
  //         ),
  //       );
  //     }

  //     // Load Income entries
  //     final incomeSnapshot = await db
  //         .collection(DatabaseTables.USER_PROFILE)
  //         .doc(user.uid)
  //         .collection(DatabaseTables.INCOMES)
  //         .get();

  //     for (var doc in incomeSnapshot.docs) {
  //       final data = IncomeModel.fromJson(doc.data());
  //       entries.add(
  //         TimelineEntry(
  //           type: TimelineEntryType.income,
  //           title: data.incomeType.isNotEmpty ? data.incomeType : 'income'.tr,
  //           odometer: '${data.odometer} km',
  //          // date: data.createdAt,
  //           date: formater.parse(data.date),
  //           amount: 'Rs${data.value}',
  //           isIncome: true,
  //           icon: Icons.attach_money,
  //           iconBgColor: Colors.green,
  //         ),
  //       );
  //     }

  //     // Load Route entries
  //     final routeSnapshot = await db
  //         .collection(DatabaseTables.USER_PROFILE)
  //         .doc(user.uid)
  //         .collection(DatabaseTables.ROUTES)
  //         .get();

  //     for (var doc in routeSnapshot.docs) {
  //       final data = RouteModel.fromJson(doc.data());
  //       // Parse date from startDate string
  //       DateTime routeDate = DateTime.now();
  //       try {
  //         final parts = data.startDate.split('/');
  //         if (parts.length == 3) {
  //           routeDate = DateTime(
  //             int.parse(parts[2]),
  //             int.parse(parts[1]),
  //             int.parse(parts[0]),
  //           );
  //         }
  //       } catch (e) {
  //         debugPrint("Error parsing route date: $e");
  //       }

  //       entries.add(
  //         TimelineEntry(
  //           type: TimelineEntryType.route,
  //           title: data.origin.isNotEmpty ? data.origin : 'route'.tr,
  //           odometer: '${data.finalOdometer.toInt()} km',
  //           date: routeDate,
  //           amount: 'Rs${data.total.toInt()}',
  //           isIncome: true,
  //           icon: Icons.route,
  //           iconBgColor: const Color(0xFF5E7E8D),
  //         ),
  //       );
  //     }

  //     // Sort entries by date (newest first)
  //     entries.sort((a, b) => b.date.compareTo(a.date));
  //     allEntries.value = entries;

  //     // Group entries by month-year
  //     final Map<String, List<TimelineEntry>> grouped = {};
  //     for (var entry in entries) {
  //       final key = entry.monthYearKey;
  //       if (!grouped.containsKey(key)) {
  //         grouped[key] = [];
  //       }
  //       grouped[key]!.add(entry);
  //     }
  //     groupedEntries.value = grouped;

  //     isLoading.value = false;
  //   } catch (e) {
  //     debugPrint("Error loading timeline data: $e");
  //     isLoading.value = false;
  //     Utils.showSnackBar(
  //       message: "Failed to load timeline data",
  //       success: false,
  //     );
  //   }
  // }

  // Get the user's account creation date
  DateTime get accountCreatedDate {
    final user = FirebaseAuth.instance.currentUser;
    return user?.metadata.creationTime ?? DateTime.now();
  }

  DateTime getStartDate() {
    if (allEntries.isNotEmpty) {
      return allEntries.last.date;
    } else {
      return now;
    }
  }

  DateTime getEndDate() {
    if (allEntries.isNotEmpty) {
      return allEntries.first.date;
    } else {
      return now;
    }
  }

  double getFirstOdometer() {
    if (allEntries.isNotEmpty) {
      final odo = double.parse(allEntries.last.odometer);
      return odo;
    } else {
      return 0.0;
    }
  }

  double getlastOdometer() {
    if (allEntries.isNotEmpty) {
      final odo = double.parse(allEntries.first.odometer);
      return odo;
    } else {
      return 0.0;
    }
  }

  // double getLastOdometer() {
  //    if (allEntries.isNotEmpty) {
  //     final odo = double.parse(allEntries.first.odometer);
  //     return odo;
  //     try {
  //      return double.parse(allEntries.first.odometer.replaceAll(' km', ''));
  //    } catch (e) {
  //      debugPrint("Error parsing last odometer: $e");
  //       return 0.0;
  //    }
  //    } else {
  //      return 0.0;
  //    }
  //  }
}
