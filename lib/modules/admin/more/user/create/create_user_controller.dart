import 'dart:convert';

import 'package:drivvo/model/app_user.dart';
import 'package:drivvo/model/onboarding_model.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CreateUserController extends GetxController {
  late AppService appService;
  final formStateKey = GlobalKey<FormState>();
  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  final issueDateController = TextEditingController();
  final expiryDateController = TextEditingController();
  final passwordController = TextEditingController();

  var showPwd = true.obs;
  // Loading state
  var isLoading = false.obs;
  var model = AppUser();

  // Cloud Function URL
  static const String _functionUrl =
      'https://us-central1-drivoo-b5d4e.cloudfunctions.net/createUser';

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();
  }

  void selectDate({required bool isIssueDate}) async {
    final context = Get.context;
    if (context == null) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final date = Utils.formatDate(date: picked);

      if (isIssueDate) {
        issueDateController.text = date;
      } else {
        expiryDateController.text = date;
      }
    }
  }

  void onSelectUser(OnboardingModel? value) {
    if (value != null) {
      model.userType = value.title.tr;
    }
  }

  Future<void> saveUser() async {
    debugPrint('=== saveUser() called ===');
    debugPrint('Form validation: ${formStateKey.currentState?.validate()}');

    if (formStateKey.currentState?.validate() == true) {
      formStateKey.currentState?.save();

      debugPrint('Form validated and saved');
      debugPrint('Email: ${model.email}');
      debugPrint('Password length: ${passwordController.text.length}');
      debugPrint('FirstName: ${model.firstName}');
      debugPrint('LastName: ${model.lastName}');
      debugPrint('UserType: ${model.userType}');
      debugPrint('AdminId: ${appService.appUser.value.id}');

      Utils.showProgressDialog();

      try {
        debugPrint('=== Preparing HTTP request to Cloud Function ===');
        debugPrint('URL: $_functionUrl');

        final payload = {
          'email': model.email,
          'password': passwordController.text,
          'firstName': model.firstName,
          'lastName': model.lastName,
          'userType': model.userType,
          'adminId': appService.appUser.value.id,
        };

        debugPrint('Payload: $payload');

        final response = await http.post(
          Uri.parse(_functionUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        );

        debugPrint('=== Response received ===');
        debugPrint('Status code: ${response.statusCode}');
        debugPrint('Body: ${response.body}');

        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (response.statusCode == 200 && data['success'] == true) {
          final uid = data['uid'];
          if (uid == null || uid.toString().isEmpty) {
            Get.back();
            Utils.showSnackBar(
              message: 'user_registration_incomplete',
              success: false,
            );
            return;
          }
          await Utils.saveData(userDocId: uid);
          passwordController.text = "";
          formStateKey.currentState?.reset();

          Get.back(closeOverlays: true);
          Utils.showSnackBar(message: "user_registered_success", success: true);
        } else {
          Get.back();
          final code = data['code'] ?? '';
          if (code == 'already-exists') {
            Utils.showSnackBar(message: 'email_already_in_use', success: false);
          } else {
            Utils.showSnackBar(
              message: data['message'] ?? 'save_data_failed',
              success: false,
            );
          }
        }
      } catch (e, stackTrace) {
        if (kDebugMode) {
          debugPrint('=== Exception ===');
          debugPrint('Error: $e');
          debugPrint('StackTrace: $stackTrace');
        }

        Get.back();
        Utils.showSnackBar(message: 'network_error_message', success: false);
      }
    } else {
      debugPrint('Form validation FAILED');
    }
  }

  @override
  void onClose() {
    issueDateController.dispose();
    expiryDateController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
