import 'package:circular_menu/circular_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/app_user.dart';
import 'package:drivvo/model/timeline_entry.dart';
import 'package:drivvo/model/vehicle/vehicle_model.dart';
import 'package:drivvo/modules/admin/reports/reports_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DriverHomeController extends GetxController {
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
      // final user = FirebaseAuth.instance.currentUser;
      // if (user == null) {
      //   isLoading.value = false;
      //   return;
      // }

      // if (forceFetch || appService.appUser.value.id.isEmpty) {
      //   var docSnapshot = await db
      //       .collection(DatabaseTables.USER_PROFILE)
      //       .doc(user.uid)
      //       .get();
      //   if (docSnapshot.exists) {
      //     Map<String, dynamic>? data = docSnapshot.data();
      //     if (data != null) {
      //       appUser = AppUser.fromJson(data);
      //       appService.setProfile(appUser);
      //     }
      //   }
      // } else {
      //   appUser = appService.appUser.value;
      // }

      appUser = appService.appUser.value;
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
                amount: data.totalCost.toString(),
                isIncome: false,
                icon: Icons.local_gas_station,
                iconBgColor: const Color(0xFFFB9601),
                originalData: data,
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
                amount: data.totalAmount.toString(),
                isIncome: false,
                icon: Icons.receipt_long,
                iconBgColor: Colors.red,
                originalData: data,
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
                amount: data.totalAmount.toString(),
                isIncome: false,
                icon: Icons.build,
                iconBgColor: Colors.brown,
                originalData: data,
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
                amount: data.value.toString(),
                isIncome: true,
                icon: Icons.attach_money,
                iconBgColor: Colors.green,
                originalData: data,
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
                amount: data.total.toString(),
                isIncome: false,
                icon: Icons.route,
                iconBgColor: const Color(0xFF5E7E8D),
                routeOdometer:
                    "${data.initialOdometer} - ${data.finalOdometer}",
                routeStartDate: data.startDate,
                routeEndDate: data.endDate,
                origin: data.origin,
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

  void checkVehicleAndNavigate({required String routeName}) {
    if (appService.currentVehicleId.value.isEmpty) {
      Utils.showSnackBar(
        message: "vehicle_must_be_selected_first".tr,
        success: false,
      );
      return;
    } else {
      Get.toNamed(routeName);
    }
  }

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

  int getFirstOdometer() {
    if (allEntries.isNotEmpty) {
      final odo = allEntries.last.odometer;
      return odo;
    } else {
      return 0;
    }
  }

  int getlastOdometer() {
    if (allEntries.isNotEmpty) {
      final odo = allEntries.first.odometer;
      return odo;
    } else {
      return 0;
    }
  }

  Future<void> deleteEntry(TimelineEntry entry) async {
    try {
      if (entry.originalData == null) return;

      // Show confirmation dialog
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: Text('delete_entry'.tr),
          content: Text('are_you_sure_delete_entry'.tr),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('cancel'.tr),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: Text(
                'delete'.tr,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

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
          return;
      }

      await db
          .collection(DatabaseTables.USER_PROFILE)
          .doc(appService.appUser.value.id)
          .update({
            fieldName: FieldValue.arrayRemove([entry.originalData.rawMap]),
          });

      await loadTimelineData(forceFetch: true);

      if (Get.isRegistered<ReportsController>()) {
        await Get.find<ReportsController>().calculateAllReports();
      }

      if (Get.isDialogOpen == true) Get.back();
      Utils.showSnackBar(message: "entry_deleted".tr, success: true);
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
