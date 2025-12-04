import 'package:drivvo/modules/root/root_controller.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootView extends GetView<RootController> {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          controller.currentIndex.value = 0;
        }
      },
      child: Obx(
        () => Scaffold(
          body: controller.currentPage,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFbceaf9), Color(0xFF8bb9ff)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: Color(0XffFB5C7C),
              showSelectedLabels: true,
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:
                    Get.locale?.languageCode == Constants.DEFAULT_LANGUAGE_CODE
                    ? 12
                    : 14,
                color: Colors.black,
                fontFamily:
                    Get.locale?.languageCode == Constants.DEFAULT_LANGUAGE_CODE
                    ? "D-FONT-R"
                    : "U-FONT-R",
              ),
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:
                    Get.locale?.languageCode == Constants.DEFAULT_LANGUAGE_CODE
                    ? 12
                    : 14,
                height: 0,
                fontFamily:
                    Get.locale?.languageCode == Constants.DEFAULT_LANGUAGE_CODE
                    ? "D-FONT-R"
                    : "U-FONT-R",
              ),
              unselectedItemColor: Colors.black45,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              currentIndex: controller.currentIndex.value,
              showUnselectedLabels: true,
              onTap: (index) => {controller.changePageInRoot(index)},
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: "home".tr,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month),
                  label: "calender".tr,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.medical_information_outlined),
                  label: "pills".tr,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: "settings".tr,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: "more".tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:safe_x/modules/root/root_controller.dart';

// class RootView extends GetView<RootController> {
//   const RootView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) {
//         if (!didPop) {
//           controller.currentIndex.value = 0;
//         }
//       },
//       child: Obx(
//         () => Scaffold(
//           body: controller.currentPage,
//           bottomNavigationBar: Container(
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFbceaf9), Color(0xFF8bb9ff)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),

//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withAlpha(100),
//                   blurRadius: 1,
//                   offset: const Offset(0, 1),
//                 ),
//               ],
//             ),
//             child: BottomNavigationBar(
//               currentIndex: controller.currentIndex.value,
//               showUnselectedLabels: true,
//               onTap: (index) => {controller.changePageInRoot(index)},
//               items: [
//                 BottomNavigationBarItem(
//                   icon: Image.asset(
//                     controller.currentIndex.value == 0
//                         ? "assets/images/home.png"
//                         : "assets/images/homeee.png",
//                     width: controller.currentIndex.value == 0 ? 24 : 28,
//                     height: controller.currentIndex.value == 0 ? 24 : 28,
//                     fit: BoxFit.cover,
//                     // color: controller.currentIndex.value == 0
//                     //     ? Colors.transparent
//                     //     : Colors.grey,
//                   ), //Icon(Icons.home_outlined),
//                   label: "Home",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.calendar_month),
//                   label: "Calender",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.medical_information_outlined),
//                   label: "Pills",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.settings),
//                   label: "Settings",
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
