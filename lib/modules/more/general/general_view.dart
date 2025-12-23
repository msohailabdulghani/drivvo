import 'package:drivvo/custom-widget/button/custom_floating_action_button.dart';
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
          Get.back(result: controller.selectedTitle);
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Get.back(result: controller.selectedTitle),
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: Text(
            controller.title.tr,
            style: Utils.getTextStyle(
              baseSize: 18,
              isBold: true,
              color: Colors.white,
              isUrdu: controller.isUrdu,
            ),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Utils.appColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: SearchTextInputField(
                  controller: controller.searchInputController,
                  hintKey: "search_by_name",
                  isUrdu: controller.isUrdu,
                  fillColors: Colors.white,
                ),
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
                          padding: EdgeInsets.only(bottom: 66),
                          itemCount: controller.generalFilterList.length,
                          itemBuilder: (context, index) {
                            final model = controller.generalFilterList[index];
                            return GestureDetector(
                              onTap: () => controller.selectedTitle.isNotEmpty
                                  ? Get.back(result: model.name)
                                  : null,
                              child: Container(
                                width: double.maxFinite,
                                margin: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  bottom: 10,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  //color: const Color(0xFFF7F7F7),
                                  color: Colors.white,
                                  border: Border.all(
                                    color:
                                        controller.selectedTitle == model.name
                                        ? Utils.appColor
                                        : Colors.grey.shade300,
                                    width:
                                        controller.selectedTitle == model.name
                                        ? 2
                                        : 1,
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
                                              baseSize: 16,
                                              isBold: false,
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
                                                color: Colors.grey.shade500,
                                                isUrdu: controller.isUrdu,
                                              ),
                                            ),
                                          if (model.location.isNotEmpty)
                                            Text(
                                              "${"location".tr}: ${model.location}",
                                              style: Utils.getTextStyle(
                                                baseSize: 14,
                                                isBold: false,
                                                color: Colors.grey.shade700,
                                                isUrdu: controller.isUrdu,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Utils.showAlertDialog(
                                        confirmMsg: "are_you_sure_delete".tr,
                                        onTapYes: () =>
                                            controller.deleteItem(model),
                                        isUrdu: controller.isUrdu,
                                      ),
                                      child: Icon(
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
