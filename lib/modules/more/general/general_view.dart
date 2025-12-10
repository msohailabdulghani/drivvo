import 'package:drivvo/custom-widget/button/custom_floating_action_button.dart';
import 'package:drivvo/custom-widget/common/custom_app_bar.dart';
import 'package:drivvo/custom-widget/common/error_refresh_view.dart';
import 'package:drivvo/custom-widget/common/refresh_indicator_view.dart';
import 'package:drivvo/custom-widget/text-input-field/search_text_input_field.dart';
import 'package:drivvo/modules/more/general/general_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GeneralView extends GetView<GeneralController> {
  const GeneralView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.back(result: "");
        }
      },
      child: Scaffold(
        floatingActionButton: CustomFloatingActionButton(
          onPressed: () {
            Get.toNamed(
              AppRoutes.CREATE_GENERAL_VIEW,
              arguments: controller.title,
            )?.then((e) => controller.loadDataByTitle());
          },
        ),
        appBar: CustomAppBar(
          name: controller.title.tr,
          isUrdu: controller.isUrdu,
          bgColor: Utils.appColor,
          textColor: Colors.white,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20),
              SearchTextInputField(
                controller: controller.searchInputController,
                hintKey: "search_by_name",
                isUrdu: controller.isUrdu,
              ),
              SizedBox(height: 20),
              Obx(
                () => Expanded(
                  child: controller.isLoading.value
                      ? RefreshIndicatorView()
                      : controller.generalFilterList.isEmpty
                      ? ErrorRefreshView(
                          onRefresh: () => controller.loadDataByTitle(),
                        )
                      : ListView.builder(
                          itemCount: controller.generalFilterList.length,
                          itemBuilder: (context, index) {
                            final model = controller.generalFilterList[index];
                            return GestureDetector(
                              onTap: () {
                                Get.back(result: model.name);
                              },
                              child: Container(
                                width: double.maxFinite,
                                margin: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  bottom: 10,
                                ),
                                padding: controller.isUrdu
                                    ? const EdgeInsets.only(
                                        right: 16,
                                        top: 10,
                                        bottom: 10,
                                      )
                                    : const EdgeInsets.only(
                                        left: 16,
                                        top: 4,
                                        bottom: 4,
                                      ),
                                decoration: BoxDecoration(
                                  //color: const Color(0xFFF7F7F7),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            model.name,
                                            style: Utils.getTextStyle(
                                              baseSize: 15,
                                              isBold: true,
                                              color: Colors.black,
                                              isUrdu: controller.isUrdu,
                                            ),
                                          ),
                                          if (model.fuelType.isNotEmpty)
                                            Text(
                                              "${"type".tr}: ${model.fuelType}",
                                              style: Utils.getTextStyle(
                                                baseSize: 14,
                                                isBold: false,
                                                color: Colors.black,
                                                isUrdu: controller.isUrdu,
                                              ),
                                            ),
                                          if (model.location.isNotEmpty)
                                            Text(
                                              "${"location".tr}: ${model.location}",
                                              style: Utils.getTextStyle(
                                                baseSize: 14,
                                                isBold: false,
                                                color: Colors.black,
                                                isUrdu: controller.isUrdu,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          controller.deleteItem(model),
                                      icon: Icon(
                                        Icons.delete_forever_outlined,
                                        size: 24,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
