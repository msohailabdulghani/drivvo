import 'package:drivvo/services/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileController extends GetxController {
  late AppService appService;
  final formStateKey = GlobalKey<FormState>();
  final errorMessage = "".obs;
  final isLoading = false.obs;
  final filePath = "".obs;

  var name = "";

  // final FirebaseFirestore db = FirebaseFirestore.instance;
  // final storageRef = FirebaseStorage.instance.ref().child(
  //   DatabaseTables.USER_IMAGES,
  // );

  @override
  void onInit() {
    appService = Get.find<AppService>();
    super.onInit();
  }

  // Future<void> saveData() async {
  //   if (formStateKey.currentState?.validate() == true) {
  //     formStateKey.currentState?.save();

  //     Utils.showProgressDialog(Get.context!);
  //     if (filePath.value.isNotEmpty) {
  //       uploadImage();
  //       //saveUser();
  //     } else {
  //       saveUser();
  //     }
  //   }
  // }

  // Future<void> saveUser() async {
  //   final map = <String, dynamic>{};
  //   map["name"] = name;

  //   await db
  //       .collection(DatabaseTables.USER_PROFILE)
  //       .doc(appService.appUser.value.id)
  //       .update(map)
  //       .then((_) {
  //         Get.back();
  //         Get.back();
  //         appService.appUser.value.name = name;
  //         appService.appUser.refresh();
  //         appService.refreshUserData();
  //         Utils.showSnackBar(message: "profile_updated_success", success: true);
  //       });
  // }

  // Future<void> uploadImage() async {
  //   final metadata = SettableMetadata(
  //     contentType: 'image/png',
  //     customMetadata: {'picked-file-path': filePath.value},
  //   );

  //   var fileName = "${appService.appUser.value.id}.jpg";

  //   storageRef
  //       .child('/$fileName')
  //       .putFile(File(filePath.value), metadata)
  //       .then((snapshot) {
  //         snapshot.ref.getDownloadURL().then((url) {
  //           final map = <String, dynamic>{};

  //           map["name"] = name;
  //           map["photoUrl"] = url;

  //           db
  //               .collection(DatabaseTables.USER_PROFILE)
  //               .doc(appService.appUser.value.id)
  //               .update(map)
  //               .then((value) {
  //                 Get.back();
  //                 Get.back();
  //                 appService.appUser.value.name = name;
  //                 appService.appUser.value.photoUrl = url;
  //                 appService.appUser.refresh();
  //                 appService.refreshUserData();
  //                 Utils.showSnackBar(
  //                   message: "profile_updated_success",
  //                   success: true,
  //                 );
  //               })
  //               .onError((error, stackTrace) {
  //                 Get.back();
  //                 Utils.showSnackBar(
  //                   message: "Image Upload error: $error",
  //                   success: false,
  //                 );
  //               });
  //         });
  //       })
  //       .onError((error, stackTrace) {
  //         Get.back();
  //         Utils.showSnackBar(
  //           message: "Image Upload error: $error",
  //           success: false,
  //         );
  //       });
  // }

  // Future<void> onPickedFile(XFile? pickedFile) async {
  //   if (pickedFile != null) {
  //     CroppedFile? croppedFile = await ImageCropper().cropImage(
  //       sourcePath: pickedFile.path,
  //       aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
  //       uiSettings: [
  //         AndroidUiSettings(
  //           toolbarTitle: 'Cropper',
  //           toolbarColor: const Color(0XffFB5C7C),
  //           toolbarWidgetColor: Colors.white,
  //           lockAspectRatio: true,
  //           aspectRatioPresets: [CropAspectRatioPreset.square],
  //         ),
  //         IOSUiSettings(
  //           title: 'Cropper',
  //           aspectRatioPresets: [
  //             CropAspectRatioPreset
  //                 .square, // IMPORTANT: iOS supports only one custom aspect ratio in preset list
  //           ],
  //         ),
  //       ],
  //     );
  //     if (croppedFile != null) {
  //       filePath.value = croppedFile.path;
  //     }
  //   }
  // }
}
