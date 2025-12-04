import 'package:drivvo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PremimumButton extends StatelessWidget {
  final String logoPath;
  final String title;
  final String subtTitle;
  final Function onTap;
  final bool isPremimumMember;

  const PremimumButton({
    super.key,
    required this.logoPath,
    required this.title,
    required this.subtTitle,
    required this.onTap,
    required this.isPremimumMember,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isPremimumMember ? null : onTap(),
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: isPremimumMember
              ? Colors.green.withValues(alpha: 0.8)
              : Colors.white,

          ///border: Border.all(color: Color(0XffFB5C7C), width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(logoPath, height: 40),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          Get.locale?.languageCode ==
                              Constants.DEFAULT_LANGUAGE_CODE
                          ? 16
                          : 18,
                      fontFamily:
                          Get.locale?.languageCode ==
                              Constants.DEFAULT_LANGUAGE_CODE
                          ? "D-FONT-R"
                          : "U-FONT-R",
                    ),
                  ),
                  Text(
                    subtTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize:
                          Get.locale?.languageCode ==
                              Constants.DEFAULT_LANGUAGE_CODE
                          ? 14
                          : 16,
                      fontFamily:
                          Get.locale?.languageCode ==
                              Constants.DEFAULT_LANGUAGE_CODE
                          ? "D-FONT-R"
                          : "U-FONT-R",
                    ),
                  ),
                ],
              ),
            ),
            isPremimumMember
                ? SizedBox()
                : Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: Color(0XffFB5C7C),
                    size: 18,
                  ),
          ],
        ),
      ),
    );
  }
}
