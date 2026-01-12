import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivvo/model/expense/expense_model.dart';
import 'package:drivvo/model/expense/expense_type_model.dart';
import 'package:drivvo/model/last_record_model.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/database_tables.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpdateExpenseController extends GetxController {
  late AppService appService;
  final formKey = GlobalKey<FormState>();

  var expenseTypesList = <ExpenseTypeModel>[].obs;

  var totalAmount = 0.obs;
  var lastOdometer = 0.obs;

  var filePath = "".obs;
  var model = ExpenseModel().obs;

  late Map<String, dynamic> oldExpenseMap;

  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final expenseTypeController = TextEditingController();
  final placeController = TextEditingController();
  final paymentMethodController = TextEditingController();
  final reasonController = TextEditingController();
  final driverController = TextEditingController();

  var showConfilctingCard = false.obs;
  late LastRecordModel lastRecord;

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;
  bool get isAdmin => appService.appUser.value.userType == Constants.ADMIN;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();

    lastRecord = appService.appUser.value.lastRecordModel;

    if (Get.arguments != null && Get.arguments is Map) {
      final ExpenseModel expense = Get.arguments['expense'];
      model.value = expense;
      oldExpenseMap = expense.rawMap;

      // Initialize lists and observables
      expenseTypesList.value = List.from(expense.expenseTypes);
      calculateTotal();
      filePath.value = expense.filePath;

      // Initialize with existing data
      dateController.text = Utils.formatDate(date: expense.date);
      timeController.text = expense.time;
      placeController.text = expense.place;
      paymentMethodController.text = expense.paymentMethod;
      reasonController.text = expense.reason;

      driverController.text = expense.driver.firstName.isNotEmpty
          ? '${expense.driver.firstName} ${expense.driver.lastName}'
          : "";

      lastOdometer.value = isAdmin
          ? appService.vehicleModel.value.lastOdometer
          : appService.driverVehicleModel.value.lastOdometer;

      // Update expense type controller display based on types list
      updateExpenseTypeDisplay();
    }
  }

  void updateExpenseTypeDisplay() {
    if (expenseTypesList.isEmpty) {
      expenseTypeController.text = "select_expense_type".tr;
    } else {
      expenseTypeController.text = expenseTypesList
          .map((e) => e.name)
          .join(", ");
    }
  }

  @override
  void onClose() {
    dateController.dispose();
    timeController.dispose();
    expenseTypeController.dispose();
    placeController.dispose();
    paymentMethodController.dispose();
    reasonController.dispose();
    driverController.dispose();
    super.onClose();
  }

  void selectDate() async {
    final context = Get.context;
    if (context == null) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: model.value.date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      dateController.text = Utils.formatDate(date: picked);
      model.value.date = picked;
    }
  }

  void selectTime() async {
    final context = Get.context;
    if (context == null) return;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(model.value.date),
    );
    if (picked != null) {
      final now = DateTime.now();
      final dt = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      final time = DateFormat('hh:mm a').format(dt);
      timeController.text = time;
      model.value.time = time;
    }
  }

  Future<void> updateExpense() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();

      DateTime modelDate = DateTime(
        model.value.date.year,
        model.value.date.month,
        model.value.date.day,
      );
      DateTime lastDate = DateTime(
        lastRecord.date.year,
        lastRecord.date.month,
        lastRecord.date.day,
      );

      if (modelDate.isBefore(lastDate)) {
        debugPrint("Last Date is bigger");
        showConfilctingCard.value = true;
        return;
      }

      if (totalAmount.value == 0) {
        Utils.showSnackBar(
          message: "expense_detail_required".tr,
          success: false,
        );
        return;
      }

      Utils.showProgressDialog();

      String? uploadedImageUrl;
      if (filePath.value.isNotEmpty) {
        try {
          uploadedImageUrl = await Utils.uploadImage(
            collectionPath: DatabaseTables.INCOME_IMAGES,
            filePath: filePath.value,
          );
          model.value.imagePath = uploadedImageUrl;
        } catch (e) {
          if (Get.isDialogOpen == true) Get.back();
          Utils.showSnackBar(message: "image_upload_failed".tr, success: false);
          return;
        }
      }

      final newExpenseMap = {
        "user_id": appService.appUser.value.id,
        "vehicle_id": appService.currentVehicleId.value,
        "time": timeController.text.trim(),
        "date": model.value.date,
        "odometer": model.value.odometer,
        "total_amount": totalAmount.value,
        "place": placeController.text.trim(),
        "payment_method": paymentMethodController.text.trim(),
        "reason": reasonController.text.trim(),
        "file_path": filePath.value,
        "notes": model.value.notes,
        "driver_id": isAdmin
            ? (oldExpenseMap["driver_id"] ?? "")
            : appService.appUser.value.id,
        "expense_types": expenseTypesList.map((e) => e.toJson()).toList(),
        "driver": isAdmin
            ? model.value.driver.toJson()
            : appService.appUser.value.toJson(),
      };

      final lastRecordMap = {
        "type": "expense",
        "date": model.value.date,
        "odometer": model.value.odometer >= lastOdometer.value
            ? model.value.odometer
            : lastOdometer.value,
      };

      try {
        final adminId = isAdmin
            ? appService.appUser.value.id
            : appService.appUser.value.adminId;

        final vehicleId = isAdmin
            ? appService.currentVehicleId.value
            : appService.driverCurrentVehicleId.value;

        final vehicleRef = FirebaseFirestore.instance
            .collection(DatabaseTables.USER_PROFILE)
            .doc(adminId)
            .collection(DatabaseTables.VEHICLES)
            .doc(vehicleId);

        final userRef = FirebaseFirestore.instance
            .collection(DatabaseTables.USER_PROFILE)
            .doc(appService.appUser.value.id);

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          transaction.update(vehicleRef, {
            'expense_list': FieldValue.arrayRemove([oldExpenseMap]),
          });

          transaction.update(vehicleRef, {
            'expense_list': FieldValue.arrayUnion([newExpenseMap]),
          });

          if (model.value.odometer >= lastOdometer.value) {
            transaction.update(vehicleRef, {
              "last_odometer": model.value.odometer,
            });
          }

          transaction.set(userRef, {
            "last_record": lastRecordMap,
          }, SetOptions(merge: true));
        });

        if (Get.isDialogOpen == true) Get.back();
        Get.back();
        Utils.showSnackBar(message: "expense_updated".tr, success: true);
      } on FirebaseException catch (e) {
        Utils.getFirebaseException(e);
      } catch (e) {
        if (Get.isDialogOpen == true) Get.back();
        debugPrint("Error updating expense: $e");
        Utils.showSnackBar(message: "something_wrong".tr, success: false);
      }
    }
  }

  void removeItem(int index) {
    if (index < 0 || index >= expenseTypesList.length) return;
    expenseTypesList.removeAt(index);
    calculateTotal();
    updateExpenseTypeDisplay();
    expenseTypesList.refresh();
  }

  void calculateTotal() {
    totalAmount.value = expenseTypesList
        .where((e) => e.isChecked.value)
        .fold(0, (a1, e) => a1 + e.value.value);
  }
}
