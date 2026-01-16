import 'package:drivvo/custom-widget/button/custom_floating_action_button.dart';
import 'package:drivvo/custom-widget/common/error_refresh_view.dart';
import 'package:drivvo/custom-widget/common/refresh_indicator_view.dart';
import 'package:drivvo/custom-widget/text-input-field/search_text_input_field.dart';
import 'package:drivvo/custom-widget/text-input-field/text_input_field.dart';
import 'package:drivvo/modules/admin/home/expense/type/expense_type_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseTypeView extends GetView<ExpenseTypeController> {
  const ExpenseTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "expense_type".tr,
          style: Utils.getTextStyle(
            baseSize: 18,
            isBold: true,
            color: Colors.white,
            isUrdu: controller.isUrdu,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => controller.onTapBack(),
            icon: Text(
              "save".tr,
              style: Utils.getTextStyle(
                baseSize: 14,
                isBold: true,
                color: Colors.white,
                isUrdu: controller.isUrdu,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          Get.toNamed(
            AppRoutes.CREATE_GENERAL_VIEW,
            arguments: Constants.EXPENSE_TYPES,
          )?.then((e) => controller.getExpeseTypes());
        },
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
                    : controller.filterList.isEmpty
                    ? ErrorRefreshView(
                        onRefresh: () => controller.getExpeseTypes(),
                      )
                    : ListView.builder(
                        itemCount: controller.filterList.length,
                        itemBuilder: (context, index) {
                          final model = controller.filterList[index];
                          return GestureDetector(
                            onTap: () {},
                            child: Obx(
                              () => Column(
                                children: [
                                  Padding(
                                    padding: controller.isUrdu
                                        ? const EdgeInsets.only(right: 10)
                                        : const EdgeInsets.only(left: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                        Checkbox(
                                          value: model.isChecked.value,
                                          onChanged: (bool? value) {
                                            model.isChecked.value =
                                                !model.isChecked.value;
                                          },
                                        ),
                                        //   if (model.isChecked.value)
                                        //     Expanded(
                                        //       child: TextFormField(
                                        //         initialValue: model.value.value,
                                        //         style: Utils.getTextStyle(
                                        //           baseSize: 14,
                                        //           isBold: false,
                                        //           color: Colors.black,
                                        //           isUrdu: controller.isUrdu,
                                        //         ),
                                        //         decoration: InputDecoration(
                                        //           contentPadding:
                                        //               const EdgeInsets.all(0),
                                        //           border: UnderlineInputBorder(),
                                        //           errorBorder:
                                        //               UnderlineInputBorder(),
                                        //           enabledBorder:
                                        //               UnderlineInputBorder(),
                                        //           focusedBorder:
                                        //               UnderlineInputBorder(),
                                        //           label: Text("value".tr),
                                        //         ),
                                        //         keyboardType:
                                        //             TextInputType.number,
                                        //         textInputAction:
                                        //             TextInputAction.done,
                                        //         onChanged: (value) {
                                        //           model.value.value = value;
                                        //         },
                                        //         onSaved: (value) {},
                                        //         validator: (value) {
                                        //           return;
                                        //         },
                                        //       ),
                                        //     ),
                                      ],
                                    ),
                                  ),
                                  if (model.isChecked.value)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: TextInputField(
                                        initialValue: model.value.value
                                            .toString(),
                                        isUrdu: controller.isUrdu,
                                        isRequired: false,
                                        isNext: true,
                                        obscureText: false,
                                        readOnly: false,
                                        labelText: "value".tr,
                                        hintText: "100".tr,
                                        inputAction:
                                            index ==
                                                controller.filterList.length - 1
                                            ? TextInputAction.done
                                            : TextInputAction.next,
                                        focusNode: model.focusNode,
                                        onFieldSubmitted: (_) {
                                          if (index <
                                              controller.filterList.length -
                                                  1) {
                                            FocusScope.of(context).requestFocus(
                                              controller
                                                  .filterList[index + 1]
                                                  .focusNode,
                                            );
                                          } else {
                                            FocusScope.of(context).unfocus();
                                          }
                                        },
                                        type: TextInputType.number,
                                        onTap: () {},
                                        onSaved: (value) {},
                                        onChange: (value) {
                                          if (value != null &&
                                              value.isNotEmpty) {
                                            final parsedValue = int.tryParse(
                                              value,
                                            );
                                            if (parsedValue != null) {
                                              model.value.value = parsedValue;
                                            }
                                          }
                                        },
                                        onValidate: (value) => null,
                                      ),
                                    ),
                                  if (model.isChecked.value)
                                    SizedBox(height: 10),
                                  Divider(),
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
    );
  }
}
