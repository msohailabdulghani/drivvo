import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/app_user.dart';
import 'package:drivvo/model/expense/expense_model.dart';
import 'package:drivvo/model/income/income_model.dart';
import 'package:drivvo/model/refueling/refueling_model.dart';
import 'package:drivvo/model/service/service_model.dart';
import 'package:drivvo/modules/home/home_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  late AppService appService;
  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  final list = ["General", "Refueling", "Expense", "Income", "Service"];
  var selectedName = "General".obs;

  // Date range
  var startDate = DateTime.now().subtract(const Duration(days: 5)).obs;
  var endDate = DateTime.now().obs;

  // General Tab Calculations
  var totalBalance = 0.0.obs;
  var totalCost = 0.0.obs;
  var totalIncome = 0.0.obs;
  var totalDistance = 0.0.obs;

  // Per day / Per km calculations
  var balanceByDay = 0.0.obs;
  var balanceByKm = 0.0.obs;
  var costByDay = 0.0.obs;
  var costByKm = 0.0.obs;
  var incomeByDay = 0.0.obs;
  var incomeByKm = 0.0.obs;
  var dailyAverageDistance = 0.0.obs;

  // Refueling Tab
  var refuelingCost = 0.0.obs;
  var refuelingDistance = 0.0.obs;
  var refuelingCostByDay = 0.0.obs;
  var refuelingCostByKm = 0.0.obs;
  var refuelingDailyAverage = 0.0.obs;

  // Expense Tab
  var expenseCost = 0.0.obs;
  var expenseDistance = 0.0.obs;
  var expenseCostByDay = 0.0.obs;
  var expenseCostByKm = 0.0.obs;
  var expenseDailyAverage = 0.0.obs;

  // Income Tab
  var incomeCost = 0.0.obs;
  var incomeDistance = 0.0.obs;
  var incomeCostByDay = 0.0.obs;
  var incomeCostByKm = 0.0.obs;
  var incomeDailyAverage = 0.0.obs;

  // Service Tab
  var serviceCost = 0.0.obs;
  var serviceDistance = 0.0.obs;
  var serviceCostByDay = 0.0.obs;
  var serviceCostByKm = 0.0.obs;
  var serviceDailyAverage = 0.0.obs;

  // Charts dropdown
  var selectedChartType = "Select".obs;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();

    tabController = TabController(length: list.length, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        selectedName.value = list[tabController.index];
      }
    });

    final home = Get.find<HomeController>();
    startDate.value = home.getStartDate();
    endDate.value = home.getEndDate();

    calculateAllReports();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void onSelect(String name) {
    selectedName.value = name;
    final index = list.indexOf(name);
    if (index != -1 && tabController.index != index) {
      tabController.animateTo(index);
    }
  }

  String get formattedDateRange {
    final formatter = DateFormat('MMM d');
    final yearFormatter = DateFormat('MMM d, yyyy');
    return "${formatter.format(startDate.value)} - ${yearFormatter.format(endDate.value)}";
  }

  Future<void> selectDateRange() async {
    final result = await Get.toNamed(
      AppRoutes.DATE_RANGE,
      arguments: {"startDate": startDate.value, "endDate": endDate.value},
    );
    if (result != null) {
      final sd = result["startDate"] as DateTime?;
      final ed = result["endDate"] as DateTime?;
      if (sd != null && ed != null) {
        startDate.value = DateTime(sd.year, sd.month, sd.day);
        endDate.value = DateTime(ed.year, ed.month, ed.day);
        calculateAllReports();
      }
    }
  }

  Future<void> calculateAllReports() async {
    var user = AppUser();
    var docSnapshot = await FirebaseFirestore.instance
        .collection(DatabaseTables.USER_PROFILE)
        .doc(appService.appUser.value.id)
        .get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      if (data != null) {
        user = AppUser.fromJson(data);
      }
    }

    // Filter data by date range
    final filteredRefueling = _filterRefuelingByDate(user.refuelingList);
    final filteredExpenses = _filterExpensesByDate(user.expenseList);
    final filteredIncomes = _filterIncomesByDate(user.incomeList);
    final filteredServices = _filterServicesByDate(user.serviceList);

    // Calculate days in range
    final days = endDate.value.difference(startDate.value).inDays + 1;

    // final home = Get.find<HomeController>();
    // final iniOdo = home.getFirstOdometer();
    // final endOdo = home.getlastOdometer();
    // final value = endOdo - iniOdo;
    // Calculate Refueling
    refuelingCost.value = _calculateRefuelingTotal(filteredRefueling);
    refuelingDistance.value = _calculateRefuelingDistance(filteredRefueling);
    refuelingCostByDay.value = days > 0 ? refuelingCost.value / days : 0;
    refuelingCostByKm.value = refuelingDistance.value > 0
        ? refuelingCost.value / refuelingDistance.value
        : 0;
    refuelingDailyAverage.value = days > 0 ? refuelingDistance.value / days : 0;

    // Calculate Expenses
    expenseCost.value = _calculateExpenseTotal(filteredExpenses);
    expenseDistance.value = _calculateExpenseDistance(filteredExpenses);
    expenseCostByDay.value = days > 0 ? expenseCost.value / days : 0;
    expenseCostByKm.value = expenseDistance.value > 0
        ? expenseCost.value / expenseDistance.value
        : 0;
    expenseDailyAverage.value = days > 0 ? expenseDistance.value / days : 0;

    // Calculate Income
    incomeCost.value = _calculateIncomeTotal(filteredIncomes);
    incomeDistance.value = _calculateIncomeDistance(filteredIncomes);
    incomeCostByDay.value = days > 0 ? incomeCost.value / days : 0;
    incomeCostByKm.value = incomeDistance.value > 0
        ? incomeCost.value / incomeDistance.value
        : 0;
    incomeDailyAverage.value = days > 0 ? incomeDistance.value / days : 0;

    // Calculate Service
    serviceCost.value = _calculateServiceTotal(filteredServices);
    serviceDistance.value = _calculateServiceDistance(filteredServices);
    serviceCostByDay.value = days > 0 ? serviceCost.value / days : 0;
    serviceCostByKm.value = serviceDistance.value > 0
        ? serviceCost.value / serviceDistance.value
        : 0;
    serviceDailyAverage.value = days > 0 ? serviceDistance.value / days : 0;

    // Calculate General (combined)
    totalCost.value =
        refuelingCost.value + expenseCost.value + serviceCost.value;
    totalIncome.value = incomeCost.value;
    totalBalance.value = totalIncome.value - totalCost.value;
    totalDistance.value =
        refuelingDistance.value +
        expenseDistance.value +
        incomeDistance.value +
        serviceDistance.value;

    // Per day / Per km for General
    balanceByDay.value = days > 0 ? totalBalance.value / days : 0;
    balanceByKm.value = totalDistance.value > 0
        ? totalBalance.value / totalDistance.value
        : 0;
    costByDay.value = days > 0 ? totalCost.value / days : 0;
    costByKm.value = totalDistance.value > 0
        ? totalCost.value / totalDistance.value
        : 0;
    incomeByDay.value = days > 0 ? totalIncome.value / days : 0;
    incomeByKm.value = totalDistance.value > 0
        ? totalIncome.value / totalDistance.value
        : 0;
    dailyAverageDistance.value = days > 0 ? totalDistance.value / days : 0;
  }

  //Filter methods
  List<RefuelingModel> _filterRefuelingByDate(List<RefuelingModel> list) {
    return list.where((item) {
      final date = item.date;
      return date.isAfter(startDate.value.subtract(const Duration(days: 1))) &&
          date.isBefore(endDate.value.add(const Duration(days: 1)));
    }).toList();
  }

  List<ExpenseModel> _filterExpensesByDate(List<ExpenseModel> list) {
    return list.where((item) {
      final date = item.date;
      return date.isAfter(startDate.value.subtract(const Duration(days: 1))) &&
          date.isBefore(endDate.value.add(const Duration(days: 1)));
    }).toList();
  }

  List<IncomeModel> _filterIncomesByDate(List<IncomeModel> list) {
    return list.where((item) {
      final date = item.date;
      return date.isAfter(startDate.value.subtract(const Duration(days: 1))) &&
          date.isBefore(endDate.value.add(const Duration(days: 1)));
    }).toList();
  }

  List<ServiceModel> _filterServicesByDate(List<ServiceModel> list) {
    return list.where((item) {
      final date = item.date;
      return date.isAfter(startDate.value.subtract(const Duration(days: 1))) &&
          date.isBefore(endDate.value.add(const Duration(days: 1)));
    }).toList();
  }

  // DateTime? _parseDate(String dateStr) {
  //   if (dateStr.isEmpty) return null;
  //   try {
  //     return DateFormat("dd MMM yyyy").parse(dateStr);
  //   } catch (e) {
  //     debugPrint("Error parsing date: $e");
  //     return null;
  //   }
  // }

  // Calculation methods
  double _calculateRefuelingTotal(List<RefuelingModel> list) {
    double total = 0;
    for (var item in list) {
      total += double.tryParse(item.totalCost) ?? 0;
    }
    return total;
  }

  double _calculateRefuelingDistance(List<RefuelingModel> list) {
    if (list.isEmpty) return 0;
    double minOdometer = double.infinity;
    double maxOdometer = 0;
    for (var item in list) {
      final odometer = double.tryParse(item.odometer) ?? 0;
      if (odometer < minOdometer) minOdometer = odometer;
      if (odometer > maxOdometer) maxOdometer = odometer;
    }
    return minOdometer == double.infinity ? 0 : maxOdometer - minOdometer;
  }

  double _calculateExpenseTotal(List<ExpenseModel> list) {
    double total = 0;
    for (var item in list) {
      total += double.tryParse(item.totalAmount) ?? 0;
    }
    return total;
  }

  double _calculateExpenseDistance(List<ExpenseModel> list) {
    if (list.isEmpty) return 0;
    double minOdometer = double.infinity;
    double maxOdometer = 0;
    for (var item in list) {
      final odometer = double.tryParse(item.odometer) ?? 0;
      if (odometer < minOdometer) minOdometer = odometer;
      if (odometer > maxOdometer) maxOdometer = odometer;
    }
    return minOdometer == double.infinity ? 0 : maxOdometer - minOdometer;
  }

  double _calculateIncomeTotal(List<IncomeModel> list) {
    double total = 0;
    for (var item in list) {
      total += double.tryParse(item.value) ?? 0;
    }
    return total;
  }

  double _calculateIncomeDistance(List<IncomeModel> list) {
    if (list.isEmpty) return 0;
    double minOdometer = double.infinity;
    double maxOdometer = 0;
    for (var item in list) {
      final odometer = double.tryParse(item.odometer) ?? 0;
      if (odometer < minOdometer) minOdometer = odometer;
      if (odometer > maxOdometer) maxOdometer = odometer;
    }
    return minOdometer == double.infinity ? 0 : maxOdometer - minOdometer;
  }

  double _calculateServiceTotal(List<ServiceModel> list) {
    double total = 0;
    for (var item in list) {
      total += double.tryParse(item.totalAmount) ?? 0;
    }
    return total;
  }

  double _calculateServiceDistance(List<ServiceModel> list) {
    if (list.isEmpty) return 0;
    double minOdometer = double.infinity;
    double maxOdometer = 0;
    for (var item in list) {
      final odometer = double.tryParse(item.odometer) ?? 0;
      if (odometer < minOdometer) minOdometer = odometer;
      if (odometer > maxOdometer) maxOdometer = odometer;
    }
    return minOdometer == double.infinity ? 0 : maxOdometer - minOdometer;
  }

  String formatCurrency(double value) {
    return "\$${value.toStringAsFixed(2)}";
  }

  String formatDistance(double value) {
    return "${value.toStringAsFixed(0)} km";
  }
}
