import 'package:drivvo/modules/authentication/import-data/import_data_controller.dart';
import 'package:drivvo/utils/common_function.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImportDataView extends GetView<ImportDataController> {
  const ImportDataView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              Text(
                'LOQO',
                style: Utils.getTextStyle(
                  baseSize: 40,
                  isBold: true,
                  color: Color(0xFF00796B),
                  isUrdu: controller.isUrdu,
                ),
              ),
              const Spacer(flex: 1),
              Text(
                controller.isFromSetting.value
                    ? 'import_export_data'.tr
                    : 'import_data_title'.tr,
                style: Utils.getTextStyle(
                  baseSize: 22,
                  isBold: true,
                  color: Colors.black,
                  isUrdu: controller.isUrdu,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'import_data_description'.tr,
                textAlign: TextAlign.center,
                style: Utils.getTextStyle(
                  baseSize: 14,
                  isBold: false,
                  color: Colors.black,
                  isUrdu: controller.isUrdu,
                ),
              ),
              const Spacer(flex: 2),
              ImportOptionButton(
                imagePath: "assets/images/import_data.png",
                title: 'import_yes'.tr,
                subtitle: 'import_yes_sub'.tr,
                onTap: () => controller.pickAndImportData(),
              ),
              const SizedBox(height: 16),
              controller.isFromSetting.value
                  ? ImportOptionButton(
                      imagePath: "assets/images/fresh_start.png",
                      title: 'export_data'.tr,
                      subtitle: 'export_data_sub'.tr,
                      onTap: () => Utils.showAlertDialog(
                        confirmMsg:
                            "${"confirm_export_data".tr} \n${controller.appService.vehicleModel.value.name}-${controller.appService.vehicleModel.value.manufacturer}-${controller.appService.vehicleModel.value.modelYear} data?",
                        onTapYes: () => CommonFunction.exportVehicleData(),
                        isUrdu: controller.isUrdu,
                      ),
                    )
                  : ImportOptionButton(
                      imagePath: "assets/images/fresh_start.png",
                      title: 'import_no'.tr,
                      subtitle: 'import_no_sub'.tr,
                      onTap: () => controller.navigateVehicleView(),
                    ),

              const Spacer(flex: 3),
              if (!controller.isFromSetting.value) ...[
                Text(
                  'import_later_note'.tr,
                  style: Utils.getTextStyle(
                    baseSize: 14,
                    isBold: false,
                    color: Colors.black,
                    isUrdu: controller.isUrdu,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable Button Widget
class ImportOptionButton extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ImportOptionButton({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  bool get _isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Utils.appColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
          child: Row(
            children: [
              Image.asset(imagePath, height: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: _isUrdu ? 18 : 16,
                        fontFamily: _isUrdu ? "U-FONT-R" : "D-FONT-R",
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: _isUrdu ? 16 : 14,
                        fontFamily: _isUrdu ? "U-FONT-R" : "D-FONT-R",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
