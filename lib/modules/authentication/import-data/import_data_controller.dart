import 'dart:convert';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ImportDataController extends GetxController {
  late AppService appService;

  var isFromSetting = false.obs;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    isFromSetting.value = Get.arguments;
    super.onInit();
  }

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  void navigateVehicleView() {
    Get.offAllNamed(AppRoutes.CREATE_VEHICLES_VIEW, arguments: true);
  }

  Future<void> pickAndImportData() async {
    try {
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else {
        directory = await getDownloadsDirectory();
      }

      if (directory == null || !await directory.exists()) {
        directory = await getApplicationDocumentsDirectory();
      }
      final List<FileSystemEntity> files = directory.listSync();
      final List<File> jsonFiles = files
          .whereType<File>()
          .where(
            (file) =>
                file.path.toLowerCase().endsWith('.json') &&
                file.path
                    .split(Platform.pathSeparator)
                    .last
                    .startsWith('Vehicle_'),
          )
          .toList();

      // Sort by modification time (newest first)
      jsonFiles.sort(
        (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
      );

      if (jsonFiles.isEmpty) {
        Utils.showSnackBar(message: "no_backups_found", success: false);
        return;
      }

      Get.bottomSheet(
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "select_backup".tr,
                  style: Utils.getTextStyle(
                    baseSize: 18,
                    isBold: true,
                    color: Colors.black,
                    isUrdu: isUrdu,
                  ),
                ),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: jsonFiles.length,
                  separatorBuilder: (_, _) => const Divider(),
                  itemBuilder: (context, index) {
                    final file = jsonFiles[index];
                    final fileName = file.path
                        .split(Platform.pathSeparator)
                        .last;
                    final date = file.lastModifiedSync();

                    return ListTile(
                      leading: const Icon(
                        Icons.description,
                        color: Color(0xFF00796B),
                      ),
                      title: Text(fileName),
                      subtitle: Text(Utils.formatDateWithTime(date: date)),
                      onTap: () {
                        Get.back(); // Close bottom sheet
                        _importFile(file);
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.blue),
                            onPressed: () {
                              // ignore: deprecated_member_use
                              Share.shareXFiles([
                                XFile(file.path),
                              ], text: 'Vehicle Data Backup');
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              Utils.showAlertDialog(
                                confirmMsg: "are_you_sure_delete".tr,
                                isUrdu: isUrdu,
                                onTapYes: () {
                                  _deleteFile(file);
                                  Get.back(); // Close alert dialog
                                  Get.back(); // Close bottom sheet
                                  pickAndImportData(); // Refresh list
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        isScrollControlled: true,
      );
    } catch (e) {
      debugPrint("Error listing backups: $e");
      Utils.showSnackBar(message: "failed_list_backups", success: false);
    }
  }

  Future<void> _deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        Get.back(closeOverlays: true);
        Utils.showSnackBar(
          message: "backup_deleted_successfully",
          success: true,
        );
      }
    } catch (e) {
      debugPrint("Error deleting backup: $e");
      Utils.showSnackBar(message: "failed_delete_backup", success: false);
    }
  }

  Future<void> _importFile(File file) async {
    try {
      Utils.showProgressDialog();
      final fileContent = await file.readAsString();
      final Map<String, dynamic> jsonData = jsonDecode(fileContent);

      // Basic validation
      if (!jsonData.containsKey('vehicleId') || !jsonData.containsKey('data')) {
        if (Get.isDialogOpen == true) Get.back();
        Utils.showSnackBar(message: "invalid_json_format", success: false);
        return;
      }

      final vehicleId = jsonData['vehicleId'];
      final data = jsonData['data'];

      // Call Cloud Function
      final functions = FirebaseFunctions.instance;
      await functions.httpsCallable('importVehicleData').call({
        "vehicleId": vehicleId,
        "data": data,
      });

      // Refresh user data/vehicles
      await appService.getAllVehicleList();

      // If specific vehicle ID imported, set it as current if none selected
      if (appService.currentVehicleId.value.isEmpty && vehicleId != null) {
        await appService.setCurrentVehicleId(vehicleId.toString());
      }

      if (Get.isDialogOpen == true) Get.back();

      Utils.showSnackBar(message: "data_imported_successfully", success: true);

      // Navigate
      if (appService.allVehiclesCount.value > 0) {
        Get.offAllNamed(AppRoutes.ADMIN_ROOT_VIEW);
      } else {
        Get.offAllNamed(AppRoutes.ADMIN_ROOT_VIEW);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      debugPrint("Error importing data: $e");
      Utils.showSnackBar(message: "failed_import_data", success: false);
    }
  }
}
