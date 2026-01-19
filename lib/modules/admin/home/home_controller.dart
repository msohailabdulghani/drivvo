import 'package:circular_menu/circular_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/timeline_entry.dart';
import 'package:drivvo/model/vehicle/vehicle_model.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  late AppService appService;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final GlobalKey<CircularMenuState> circularMenuKey =
      GlobalKey<CircularMenuState>();

  final now = DateTime.now();

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
    loadTimelineData();
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
    await loadTimelineData();
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

  // Prediction variables
  var nextRefuelingOdometer = 0.obs;
  var nextRefuelingDate = Rxn<DateTime>();
  var avgConsumption = 0.0.obs;

  Future<void> loadTimelineData() async {
    try {
      isLoading.value = true;

      final vehicle = appService.vehicleModel.value;
      final List<TimelineEntry> entries = [];

      if (appService.refuelingFilter.value) {
        for (var data in vehicle.refuelingList) {
          if (data.vehicleId == appService.currentVehicleId.value) {
            entries.add(
              TimelineEntry(
                type: TimelineEntryType.refueling,
                title: 'refueling'.tr,
                date: data.date,
                odometer: data.odometer,
                amount: data.totalCost.toString(),
                isIncome: false,
                icon: Icons.local_gas_station,
                iconBgColor: const Color(0xFFFB9601),
                driveName: data.driverId.isNotEmpty
                    ? "${data.driver.firstName} ${data.driver.lastName}"
                    : "",
                originalData: data,
              ),
            );
          }
        }
      }

      if (appService.expenseFilter.value) {
        for (var data in vehicle.expenseList) {
          if (data.vehicleId == appService.currentVehicleId.value) {
            entries.add(
              TimelineEntry(
                type: TimelineEntryType.expense,
                title: 'expense'.tr,
                odometer: data.odometer,
                date: data.date,
                amount: data.totalAmount.toString(),
                isIncome: false,
                icon: Icons.receipt_long,
                iconBgColor: Colors.red,
                driveName: data.driverId.isNotEmpty
                    ? "${data.driver.firstName} ${data.driver.lastName}"
                    : "",
                originalData: data,
              ),
            );
          }
        }
      }

      if (appService.serviceFilter.value) {
        for (var data in vehicle.serviceList) {
          if (data.vehicleId == appService.currentVehicleId.value) {
            entries.add(
              TimelineEntry(
                type: TimelineEntryType.service,
                title: 'service'.tr,
                date: data.date,
                odometer: data.odometer,
                amount: data.totalAmount.toString(),
                isIncome: false,
                icon: Icons.build,
                iconBgColor: Colors.brown,
                driveName: data.driverId.isNotEmpty
                    ? "${data.driver.firstName} ${data.driver.lastName}"
                    : "",
                originalData: data,
              ),
            );
          }
        }
      }

      if (appService.incomeFilter.value) {
        for (var data in vehicle.incomeList) {
          if (data.vehicleId == appService.currentVehicleId.value) {
            entries.add(
              TimelineEntry(
                type: TimelineEntryType.income,
                title: data.incomeType.isNotEmpty
                    ? data.incomeType
                    : 'income'.tr,
                date: data.date,
                odometer: data.odometer,
                amount: data.value.toString(),
                isIncome: true,
                icon: Icons.attach_money,
                iconBgColor: Colors.green,
                driveName: data.driverId.isNotEmpty
                    ? "${data.driver.firstName} ${data.driver.lastName}"
                    : "",
                originalData: data,
              ),
            );
          }
        }
      }

      if (appService.routeFilter.value) {
        for (var data in vehicle.routeList) {
          if (data.vehicleId == appService.currentVehicleId.value) {
            entries.add(
              TimelineEntry(
                type: TimelineEntryType.route,
                title: data.destination,
                date: data.startDate,
                odometer: data.finalOdometer,
                amount: data.total.toString(),
                isIncome: false,
                icon: Icons.route,
                iconBgColor: const Color(0xFF5E7E8D),
                routeOdometer:
                    "${data.initialOdometer} - ${data.finalOdometer}",
                routeStartDate: data.startDate,
                routeEndDate: data.endDate,
                origin: data.origin,
                driveName: data.driverId.isNotEmpty
                    ? "${data.driver.firstName} ${data.driver.lastName}"
                    : "",
                originalData: data,
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

      // Calculate predictions
      calculateNextRefueling();

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

  void calculateNextRefueling() {
    try {
      final vehicle = appService.vehicleModel.value;
      // Get refuelings for current vehicle
      final refuelings = vehicle.refuelingList
          .where((r) => r.vehicleId == appService.currentVehicleId.value)
          .toList();

      if (refuelings.isEmpty) {
        nextRefuelingOdometer.value = 0;
        nextRefuelingDate.value = null;
        avgConsumption.value = 0.0;
        return;
      }

      // Sort by odometer (ascending)
      refuelings.sort((a, b) => a.odometer.compareTo(b.odometer));

      var lastRefuel = refuelings.last;

      // Default Fallbacks (matching observed Drivvo behavior)
      double efficiency = 11.0;
      double dailyDistance = 5.5;

      if (refuelings.length > 1) {
        // Calculate Total Distance
        double totalDist =
            (refuelings.last.odometer - refuelings.first.odometer).toDouble();

        // Calculate Total Consumed Liters (Sum of all EXCEPT the last one)
        double consumedLiters = 0;
        for (int i = 0; i < refuelings.length - 1; i++) {
          double l = refuelings[i].liter.toDouble();
          // Fallback if liter is 0 (due to int type or empty) but we have cost info
          if (l == 0 &&
              refuelings[i].price > 0 &&
              refuelings[i].totalCost > 0) {
            l = refuelings[i].totalCost / refuelings[i].price;
          }
          consumedLiters += l;
        }

        // Calculate Total Days (Precise)
        double totalDays =
            refuelings.last.date.difference(refuelings.first.date).inMinutes /
            1440.0;
        if (totalDays <= 0) totalDays = 1.0;

        if (consumedLiters > 0) {
          efficiency = totalDist / consumedLiters;
        }

        if (totalDist > 0) {
          dailyDistance = totalDist / totalDays;
        }
      }

      avgConsumption.value = efficiency;

      // Predict Next Refueling
      double lastLiter = lastRefuel.liter.toDouble();
      if (lastLiter == 0 && lastRefuel.price > 0 && lastRefuel.totalCost > 0) {
        lastLiter = lastRefuel.totalCost / lastRefuel.price;
      }

      //! Skip prediction if we can't determine last refueling amount
      if (lastLiter <= 0) {
        nextRefuelingOdometer.value = 0;
        nextRefuelingDate.value = null;
        return;
      }

      // Prediction = Based on liters added in LAST refueling
      double predictedRange = lastLiter * efficiency;

      // Next Odo = Last Refuel Odo + Range
      int nextOdo = lastRefuel.odometer + predictedRange.round();
      nextRefuelingOdometer.value = nextOdo;
      // Predict Date
      // Base prediction on Last Refuel Date, not Now
      if (dailyDistance > 0) {
        // days = range / dailyDistance
        int daysRemaining = (predictedRange / dailyDistance).round();
        nextRefuelingDate.value = lastRefuel.date.add(
          Duration(days: daysRemaining),
        );
      } else {
        nextRefuelingDate.value = null;
      }
    } catch (e) {
      debugPrint("Error calculating prediction: $e");
    }
  }

  void checkVehicleAndNavigate({required String routeName}) {
    Get.back();
    if (appService.currentVehicleId.value.isEmpty) {
      Utils.showSnackBar(
        message: "vehicle_must_be_selected_first".tr,
        success: false,
      );
      return;
    }

    Get.toNamed(routeName);
  }

  Future<void> deleteEntry(TimelineEntry entry) async {
    try {
      if (entry.originalData == null) return;
      Get.back();
      Utils.showProgressDialog();

      String fieldName = "";
      switch (entry.type) {
        case TimelineEntryType.refueling:
          fieldName = "refueling_list";
          break;
        case TimelineEntryType.expense:
          fieldName = "expense_list";
          break;
        case TimelineEntryType.service:
          fieldName = "service_list";
          break;
        case TimelineEntryType.income:
          fieldName = "income_list";
          break;
        case TimelineEntryType.route:
          fieldName = "route_list";
          break;
        default:
          if (Get.isDialogOpen == true) Get.back();
          return;
      }

      final vehicleRef = db
          .collection(DatabaseTables.USER_PROFILE)
          .doc(appService.appUser.value.id)
          .collection(DatabaseTables.VEHICLES)
          .doc(appService.currentVehicleId.value);

      // Use transaction for atomic delete operation to prevent race conditions
      await db.runTransaction((transaction) async {
        final entryToRemove = entry.originalData.rawMap;
        // Perform atomic array remove
        transaction.update(vehicleRef, {
          fieldName: FieldValue.arrayRemove([entryToRemove]),
        });
      });

      Get.back(closeOverlays: true);
      Utils.showSnackBar(message: "entry_deleted".tr, success: true);
    } on FirebaseException catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      debugPrint("Firebase error deleting entry: ${e.code} - ${e.message}");
      Utils.showSnackBar(message: "failed_to_delete_entry".tr, success: false);
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      debugPrint("Error deleting entry: $e");
      Utils.showSnackBar(message: "failed_to_delete_entry".tr, success: false);
    }
  }

  void editEntry(TimelineEntry entry) {
    if (entry.originalData == null) return;

    switch (entry.type) {
      case TimelineEntryType.income:
        Get.toNamed(
          AppRoutes.UPDATE_INCOME_VIEW,
          arguments: {'income': entry.originalData},
        );
        break;
      case TimelineEntryType.refueling:
        Get.toNamed(
          AppRoutes.UPDATE_REFUELING_VIEW,
          arguments: {'refueling': entry.originalData},
        );
        break;
      case TimelineEntryType.expense:
        Get.toNamed(
          AppRoutes.UPDATE_EXPENSE_VIEW,
          arguments: {'expense': entry.originalData},
        );
        break;
      case TimelineEntryType.service:
        Get.toNamed(
          AppRoutes.UPDATE_SERVICE_VIEW,
          arguments: {'service': entry.originalData},
        );
        break;
      case TimelineEntryType.route:
        Get.toNamed(
          AppRoutes.UPDATE_ROUTE_VIEW,
          arguments: {'route': entry.originalData},
        );
        break;
      // Add other cases as they are implemented
      default:
        Utils.showSnackBar(
          message: "Edit functionality for ${entry.type.name} is coming soon",
          success: true,
        );
        break;
    }
  }
}
