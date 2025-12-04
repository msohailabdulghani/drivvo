import 'dart:io';
import 'package:drivvo/custom-widget/button/custom_button.dart';
import 'package:drivvo/custom-widget/profile_image.dart';
import 'package:drivvo/modules/common/update-profile/update_profile_controller.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  const UpdateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "update_profile".tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:
                Get.locale?.languageCode == Constants.DEFAULT_LANGUAGE_CODE
                ? 20
                : 22,
            fontFamily:
                Get.locale?.languageCode == Constants.DEFAULT_LANGUAGE_CODE
                ? "D-FONT-R"
                : "U-FONT-R",
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  decoration: const BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Form(
                    key: controller.formStateKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Obx(
                                () => SizedBox(
                                  width: 130,
                                  height: 130,
                                  child: controller.filePath.isNotEmpty
                                      ? CircleAvatar(
                                          foregroundColor: const Color(
                                            0xFF169EC5,
                                          ),
                                          backgroundImage: FileImage(
                                            File(controller.filePath.value),
                                          ),
                                          radius: 48.0,
                                        )
                                      : ProfileImage(
                                          photoUrl: controller
                                              .appService
                                              .appUser
                                              .value
                                              .photoUrl,
                                          width: 120,
                                          height: 120,
                                          radius: 100,
                                          placeholder:
                                              "assets/images/default.png",
                                        ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => {},
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0XffFB5C7C),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.edit,
                                      size:
                                          MediaQuery.of(context).size.width *
                                          0.047,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        CustomButton(title: "update".tr, onTap: () {}),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void showResponseDialog() async {
  //   final ImagePicker imgPicker = ImagePicker();

  //   Get.defaultDialog(
  //     title: "Choose Option",
  //     backgroundColor: Colors.white,
  //     content: Padding(
  //       padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
  //       child: Column(
  //         children: [
  //           GestureDetector(
  //             behavior: HitTestBehavior.opaque,
  //             onTap: () async {
  //               Get.back();
  //               final pickedFile = await imgPicker.pickImage(
  //                 source: ImageSource.camera,
  //                 imageQuality: 85,
  //                 maxWidth: 400,
  //                 maxHeight: 400,
  //               );
  //               if (pickedFile != null) {
  //                 controller.onPickedFile(pickedFile);
  //               }
  //             },
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   "Take Photo",
  //                   style: const TextStyle(
  //                     fontWeight: FontWeight.w600,
  //                     color: Color(0xff000000),
  //                     fontSize: 14,
  //                   ),
  //                 ),
  //                 const Icon(Icons.camera_alt, color: Colors.black, size: 18),
  //               ],
  //             ),
  //           ),
  //           const SizedBox(height: 5),
  //           const Divider(thickness: 0.5, color: Color(0x20000000)),
  //           const SizedBox(height: 5),
  //           GestureDetector(
  //             behavior: HitTestBehavior.opaque,
  //             onTap: () async {
  //               Get.back();
  //               final pickedFile = await imgPicker.pickImage(
  //                 source: ImageSource.gallery,
  //                 imageQuality: 85,
  //                 maxWidth: 400,
  //                 maxHeight: 400,
  //               );
  //               if (pickedFile != null) {
  //                 controller.onPickedFile(pickedFile);
  //               }
  //             },
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   "Gallery",
  //                   style: const TextStyle(
  //                     fontWeight: FontWeight.w600,
  //                     color: Color(0xff000000),
  //                     fontSize: 14,
  //                   ),
  //                 ),
  //                 const Icon(Icons.camera_alt, color: Colors.black, size: 18),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
