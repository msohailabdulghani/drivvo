import 'package:drivvo/modules/root/root_controller.dart';
import 'package:drivvo/utils/utils.dart';
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
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 5,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.white,
                selectedItemColor: Color(0xFF00796B),
                showSelectedLabels: true,
                unselectedLabelStyle: Utils.getTextStyle(
                  baseSize: 14,
                  color: Colors.black,
                  isBold: false,
                  isUrdu: controller.isUrdu,
                ),
                selectedLabelStyle: Utils.getTextStyle(
                  baseSize: 14,
                  color: Colors.black,
                  isBold: true,
                  isUrdu: controller.isUrdu,
                ),
                unselectedItemColor: Colors.black45,
                type: BottomNavigationBarType.fixed,
                currentIndex: controller.currentIndex.value,
                showUnselectedLabels: true,
                onTap: (index) => {controller.changePageInRoot(index)},
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      "assets/images/home.png",
                      width: 28,
                      height: 28,
                      fit: BoxFit.cover,
                      color: controller.currentIndex.value == 0
                          ? Color(0xFF00796B)
                          : Colors.grey,
                    ),
                    label: "home".tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      "assets/images/report.png",
                      width: 28,
                      height: 28,
                      fit: BoxFit.cover,
                      color: controller.currentIndex.value == 1
                          ? Color(0xFF00796B)
                          : Colors.grey,
                    ),
                    label: "report".tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: "setting".tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      "assets/images/reminder.png",
                      width: 28,
                      height: 28,
                      fit: BoxFit.cover,
                      color: controller.currentIndex.value == 3
                          ? Color(0xFF00796B)
                          : Colors.grey,
                    ),
                    label: "reminder".tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      "assets/images/more.png",
                      width: 28,
                      height: 28,
                      fit: BoxFit.cover,
                      color: controller.currentIndex.value == 4
                          ? Color(0xFF00796B)
                          : Colors.grey,
                    ),
                    label: "more".tr,
                  ),
                ],
              ),
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
