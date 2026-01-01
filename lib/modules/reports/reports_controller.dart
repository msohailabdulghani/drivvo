import 'package:drivvo/model/app_user.dart';
import 'package:drivvo/model/expense/expense_model.dart';
import 'package:drivvo/model/income/income_model.dart';
import 'package:drivvo/model/refueling/refueling_model.dart';
import 'package:drivvo/model/service/service_model.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';
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
  var totalBalance = 0.obs;
  var totalCost = 0.obs;
  var totalIncome = 0.obs;
  var totalDistance = 0.obs;

  // Per day / Per km calculations
  var balanceByDay = 0.0.obs;
  var balanceByKm = 0.0.obs;
  var costByDay = 0.0.obs;
  var costByKm = 0.0.obs;
  var incomeByDay = 0.0.obs;
  var incomeByKm = 0.0.obs;
  var dailyAverageDistance = 0.0.obs;

  // Refueling Tab
  var refuelingCost = 0.obs;
  var refuelingDistance = 0.obs;
  var refuelingCostByDay = 0.0.obs;
  var refuelingCostByKm = 0.0.obs;
  var refuelingDailyAverage = 0.0.obs;

  // Expense Tab
  var expenseCost = 0.obs;
  var expenseDistance = 0.obs;
  var expenseCostByDay = 0.0.obs;
  var expenseCostByKm = 0.0.obs;
  var expenseDailyAverage = 0.0.obs;

  // Income Tab
  var incomeCost = 0.obs;
  var incomeDistance = 0.obs;
  var incomeCostByDay = 0.0.obs;
  var incomeCostByKm = 0.0.obs;
  var incomeDailyAverage = 0.0.obs;

  // Service Tab
  var serviceCost = 0.obs;
  var serviceDistance = 0.obs;
  var serviceCostByDay = 0.0.obs;
  var serviceCostByKm = 0.0.obs;
  var serviceDailyAverage = 0.0.obs;

  // Charts dropdown
  var selectedChartType = "Select".obs;

  // Chart Data
  var generalMonthlyData = <String, int>{}.obs;
  var expenseVsIncomeData = <String, Map<String, int>>{}.obs;
  var refuelingMonthlyData = <String, int>{}.obs;
  var expenseMonthlyData = <String, int>{}.obs;
  var incomeMonthlyData = <String, int>{}.obs;
  var serviceMonthlyData = <String, int>{}.obs;
  var fuelEfficiencyData = <FlSpot>[].obs;
  var odometerHistoryData = <FlSpot>[].obs;
  var distancePerRefuelingData = <FlSpot>[].obs;
  var fuelPriceData = <FlSpot>[].obs;
  var expenseTypeDistribution = <String, int>{}.obs;
  var serviceTypeDistribution = <String, int>{}.obs;
  var incomeTypeDistribution = <String, int>{}.obs;
  var fuelTypeDistribution = <String, int>{}.obs;

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

    // final home = Get.find<HomeController>();
    // startDate.value = home.getStartDate();
    // endDate.value = home.getEndDate();

    startDate.value = DateTime(endDate.value.year, endDate.value.month, 1);

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

  // Future<void> selectDateRange() async {
  //   final result = await Get.toNamed(
  //     AppRoutes.DATE_RANGE,
  //     arguments: {"startDate": startDate.value, "endDate": endDate.value},
  //   );
  //   if (result != null) {
  //     final sd = result["startDate"] as DateTime?;
  //     final ed = result["endDate"] as DateTime?;
  //     if (sd != null && ed != null) {
  //       startDate.value = DateTime(sd.year, sd.month, sd.day);
  //       endDate.value = DateTime(ed.year, ed.month, ed.day);
  //       calculateAllReports();
  //     }
  //   }
  // }

  Future<void> calculateAllReports() async {
    var user = appService.appUser.value;
    // var docSnapshot = await FirebaseFirestore.instance
    //     .collection(DatabaseTables.USER_PROFILE)
    //     .doc(appService.appUser.value.id)
    //     .get();
    // if (docSnapshot.exists) {
    //   Map<String, dynamic>? data = docSnapshot.data();
    //   if (data != null) {
    //     user = AppUser.fromJson(data);
    //   }
    // }

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

    // Prepare Chart Data
    _prepareCategorizedMonthlyData(
      filteredRefueling,
      filteredExpenses,
      filteredServices,
      filteredIncomes,
    );
    _prepareFuelEfficiencyData(user.refuelingList);
    _prepareDistancePerRefuelingData(user.refuelingList);
    _prepareFuelPriceData(filteredRefueling);
    _prepareExpenseTypeDistribution(filteredExpenses);
    _prepareServiceTypeDistribution(filteredServices);
    _prepareIncomeDistribution(filteredIncomes);
    _prepareFuelTypeDistribution(filteredRefueling);
    _prepareOdometerHistoryData(user);
  }

  void _prepareFuelTypeDistribution(List<RefuelingModel> refuelings) {
    final Map<String, int> distribution = {};
    for (var refuel in refuelings) {
      final int val = refuel.totalCost;
      if (val > 0) {
        final type = refuel.fuelType.isEmpty ? "unknown" : refuel.fuelType;
        distribution[type] = (distribution[type] ?? 0) + val;
      }
    }
    fuelTypeDistribution.value = distribution;
  }

  void _prepareIncomeDistribution(List<IncomeModel> incomes) {
    final Map<String, int> distribution = {};
    for (var income in incomes) {
      final int val = income.value;
      if (val > 0) {
        distribution[income.incomeType] =
            (distribution[income.incomeType] ?? 0) + val;
      }
    }
    incomeTypeDistribution.value = distribution;
  }

  void _prepareServiceTypeDistribution(List<ServiceModel> services) {
    final Map<String, int> distribution = {};
    for (var service in services) {
      for (var type in service.serviceTypes) {
        final int val = type.value.value;
        if (val > 0) {
          distribution[type.name] = (distribution[type.name] ?? 0) + val;
        }
      }
    }
    serviceTypeDistribution.value = distribution;
  }

  void _prepareExpenseTypeDistribution(List<ExpenseModel> expenses) {
    final Map<String, int> distribution = {};
    for (var expense in expenses) {
      for (var type in expense.expenseTypes) {
        final int val = type.value.value;
        if (val > 0) {
          distribution[type.name] = (distribution[type.name] ?? 0) + val;
        }
      }
    }
    expenseTypeDistribution.value = distribution;
  }

  void _prepareCategorizedMonthlyData(
    List<RefuelingModel> refuelings,
    List<ExpenseModel> expenses,
    List<ServiceModel> services,
    List<IncomeModel> incomes,
  ) {
    final formatter = DateFormat('MMM yy');

    Map<String, int> getMonthlyMap(
      List<dynamic> items,
      int Function(dynamic) getCost,
    ) {
      final Map<String, int> map = {};
      for (var item in items) {
        final month = formatter.format(item.date);
        map[month] = (map[month] ?? 0) + getCost(item);
      }
      return map;
    }

    refuelingMonthlyData.value = getMonthlyMap(
      refuelings,
      (item) => (item as RefuelingModel).totalCost,
    );
    expenseMonthlyData.value = getMonthlyMap(
      expenses,
      (item) => (item as ExpenseModel).totalAmount,
    );
    serviceMonthlyData.value = getMonthlyMap(
      services,
      (item) => (item as ServiceModel).totalAmount,
    );
    incomeMonthlyData.value = getMonthlyMap(
      incomes,
      (item) => (item as IncomeModel).value,
    );

    // General monthly data (combined cost: refuel + expense + service)
    final Map<String, int> generalMap = {};
    void merge(Map<String, int> source) {
      source.forEach((key, value) {
        generalMap[key] = (generalMap[key] ?? 0) + value;
      });
    }

    merge(refuelingMonthlyData);
    merge(expenseMonthlyData);
    merge(serviceMonthlyData);
    generalMonthlyData.value = generalMap;

    // Preparation of Expense vs Income comparison data
    final Map<String, Map<String, int>> comparison = {};
    final allMonths = {...generalMap.keys, ...incomeMonthlyData.keys};
    for (var month in allMonths) {
      comparison[month] = {
        'expense': generalMap[month] ?? 0,
        'income': incomeMonthlyData[month] ?? 0,
      };
    }
    expenseVsIncomeData.value = comparison;
  }

  void _prepareFuelEfficiencyData(List<RefuelingModel> allRefuelings) {
    if (allRefuelings.length < 2) {
      fuelEfficiencyData.value = [];
      return;
    }

    // Sort by date/odometer
    final sorted = List<RefuelingModel>.from(allRefuelings);
    sorted.sort((a, b) => a.odometer.compareTo(b.odometer));

    final List<FlSpot> spots = [];
    int validEntryIndex = 0;
    for (int i = 1; i < sorted.length; i++) {
      final current = sorted[i];
      final previous = sorted[i - 1];

      // Check if current is in range
      if (current.date.isAfter(
            startDate.value.subtract(const Duration(days: 1)),
          ) &&
          current.date.isBefore(endDate.value.add(const Duration(days: 1)))) {
        final dist = current.odometer - previous.odometer;
        final liters = current.liter;

        if (liters > 0 && dist > 0) {
          final efficiency = dist / liters;
          spots.add(FlSpot(validEntryIndex.toDouble(), efficiency));
          validEntryIndex++;
        }
      }
    }
    fuelEfficiencyData.value = spots;
  }

  void _prepareDistancePerRefuelingData(List<RefuelingModel> allRefuelings) {
    if (allRefuelings.length < 2) {
      distancePerRefuelingData.value = [];
      return;
    }

    // Sort by date
    final sorted = List<RefuelingModel>.from(allRefuelings);
    sorted.sort((a, b) => a.date.compareTo(b.date));

    final List<FlSpot> spots = [];
    for (int i = 1; i < sorted.length; i++) {
      final current = sorted[i];
      final previous = sorted[i - 1];

      if (current.date.isAfter(
            startDate.value.subtract(const Duration(days: 1)),
          ) &&
          current.date.isBefore(endDate.value.add(const Duration(days: 1)))) {
        final currentOdo = current.odometer;
        final previousOdo = previous.odometer;

        if (currentOdo > previousOdo) {
          final dist = currentOdo - previousOdo;
          spots.add(
            FlSpot(
              current.date.millisecondsSinceEpoch.toDouble(),
              dist.toDouble(),
            ),
          );
        }
      }
    }
    distancePerRefuelingData.value = spots;
  }

  void _prepareFuelPriceData(List<RefuelingModel> refuelings) {
    if (refuelings.isEmpty) {
      fuelPriceData.value = [];
      return;
    }

    // Sort by date
    final sorted = List<RefuelingModel>.from(refuelings);
    sorted.sort((a, b) => a.date.compareTo(b.date));

    final List<FlSpot> spots = [];
    for (var refuel in sorted) {
      final p = refuel.price;
      if (p > 0) {
        spots.add(
          FlSpot(refuel.date.millisecondsSinceEpoch.toDouble(), p.toDouble()),
        );
      }
    }
    fuelPriceData.value = spots;
  }

  void _prepareOdometerHistoryData(AppUser user) {
    final List<Map<String, dynamic>> allEntries = [];

    for (var item in user.refuelingList) {
      allEntries.add({'date': item.date, 'odometer': item.odometer});
    }
    for (var item in user.expenseList) {
      allEntries.add({'date': item.date, 'odometer': item.odometer});
    }
    for (var item in user.serviceList) {
      allEntries.add({'date': item.date, 'odometer': item.odometer});
    }
    for (var item in user.incomeList) {
      allEntries.add({'date': item.date, 'odometer': item.odometer});
    }

    if (allEntries.isEmpty) {
      odometerHistoryData.value = [];
      return;
    }

    // Sort by date
    allEntries.sort(
      (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime),
    );

    final List<FlSpot> spots = [];
    for (var entry in allEntries) {
      int odo = entry['odometer'];
      if (odo > 0) {
        spots.add(
          FlSpot(
            (entry['date'] as DateTime).millisecondsSinceEpoch.toDouble(),
            odo.toDouble(),
          ),
        );
      }
    }
    odometerHistoryData.value = spots;
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
  int _calculateRefuelingTotal(List<RefuelingModel> list) {
    int total = 0;
    for (var item in list) {
      total += item.totalCost;
    }
    return total;
  }

  int _calculateRefuelingDistance(List<RefuelingModel> list) {
    if (list.isEmpty) return 0;

    int minOdometer = list.first.odometer;
    int maxOdometer = list.first.odometer;
    for (var item in list.skip(1)) {
      final odometer = item.odometer;
      if (odometer < minOdometer) minOdometer = odometer;
      if (odometer > maxOdometer) maxOdometer = odometer;
    }
    return maxOdometer - minOdometer;
  }

  int _calculateExpenseTotal(List<ExpenseModel> list) {
    int total = 0;
    for (var item in list) {
      total += item.totalAmount;
    }
    return total;
  }

  int _calculateExpenseDistance(List<ExpenseModel> list) {
    if (list.isEmpty) return 0;

    int minOdometer = list.first.odometer;
    int maxOdometer = list.first.odometer;
    for (var item in list.skip(1)) {
      final odometer = item.odometer;
      if (odometer < minOdometer) minOdometer = odometer;
      if (odometer > maxOdometer) maxOdometer = odometer;
    }
    return maxOdometer - minOdometer;
  }

  int _calculateIncomeTotal(List<IncomeModel> list) {
    int total = 0;
    for (var item in list) {
      total += item.value;
    }
    return total;
  }

  int _calculateIncomeDistance(List<IncomeModel> list) {
    if (list.isEmpty) return 0;

    int minOdometer = list.first.odometer;
    int maxOdometer = list.first.odometer;
    for (var item in list.skip(1)) {
      final odometer = item.odometer;
      if (odometer < minOdometer) minOdometer = odometer;
      if (odometer > maxOdometer) maxOdometer = odometer;
    }
    return maxOdometer - minOdometer;
  }

  int _calculateServiceTotal(List<ServiceModel> list) {
    int total = 0;
    for (var item in list) {
      total += item.totalAmount;
    }
    return total;
  }

  int _calculateServiceDistance(List<ServiceModel> list) {
    if (list.isEmpty) return 0;

    int minOdometer = list.first.odometer;
    int maxOdometer = list.first.odometer;
    for (var item in list.skip(1)) {
      final odometer = item.odometer;
      if (odometer < minOdometer) minOdometer = odometer;
      if (odometer > maxOdometer) maxOdometer = odometer;
    }
    return maxOdometer - minOdometer;
  }

  String formatCurrency(int value) {
    return "${appService.selectedCurrencySymbol.value} $value";
  }

  String formatDistance(int value) {
    return "${value.toStringAsFixed(0)} km";
  }

  Future<void> selectDateRange() async {
    final context = Get.context;
    if (context == null) {
      debugPrint('Cannot show date picker: context is null');
      return;
    }

    final DateTime now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      initialDateRange: DateTimeRange(
        start: startDate.value,
        end: endDate.value,
      ),
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      startDate.value = picked.start;
      endDate.value = picked.end;

      calculateAllReports();
    }
  }
}
