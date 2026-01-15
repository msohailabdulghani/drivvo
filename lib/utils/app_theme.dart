import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTheme {
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      canvasColor: Colors.white,
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.black),
        displayMedium: TextStyle(color: Colors.black),
        displaySmall: TextStyle(color: Colors.black),
        headlineLarge: TextStyle(color: Colors.black),
        headlineMedium: TextStyle(color: Colors.black),
        headlineSmall: TextStyle(color: Colors.black),
        titleLarge: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black),
        titleSmall: TextStyle(color: Colors.black),
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
        bodySmall: TextStyle(color: Colors.black),
        labelLarge: TextStyle(color: Colors.black),
        labelMedium: TextStyle(color: Colors.black),
        labelSmall: TextStyle(color: Colors.black),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Utils.appColor,
        primary: Utils.appColor,
        secondary: const Color(0xFF047772),
        surface: Colors.white,
        onSurface: Colors.black,
        brightness: Brightness.light,
      ),
      //dialogBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Utils.appColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: Color(0xFF047772),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF047772),
        shape: CircleBorder(),
        foregroundColor: Colors.white,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        checkmarkColor: Colors.white,
        selectedColor: const Color(0xFF047772),
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Color(0xFF047772)),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Colors.black,
        textColor: Colors.black,
        selectedTileColor: Color(0xFF45AE91),
        selectedColor: Color(0xFF45AE91),
        tileColor: Colors.transparent,
      ),
      // dropdownMenuTheme: const DropdownMenuThemeData(
      //   menuStyle: MenuStyle(
      //     backgroundColor: WidgetStatePropertyAll(Colors.white),
      //   ),
      //   inputDecorationTheme: InputDecorationTheme(
      //     enabledBorder: OutlineInputBorder(
      //       borderSide: BorderSide(color: Colors.white),
      //       borderRadius: BorderRadius.all(Radius.circular(12.0)),
      //     ),
      //     filled: true,
      //     fillColor: Colors.white,
      //     isDense: true,
      //     contentPadding: EdgeInsets.symmetric(horizontal: 10),
      //   ),
      // ),
      // bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      //   backgroundColor: Colors.white,
      //   selectedItemColor: Color(0XffFB5C7C),
      //   showSelectedLabels: true,
      //   unselectedLabelStyle: TextStyle(fontSize: 12, color: Colors.black),
      //   showUnselectedLabels: false,

      //   selectedLabelStyle: TextStyle(
      //     fontWeight: FontWeight.bold,
      //     fontSize: 12,
      //   ),
      //   unselectedItemColor: Colors.black45,
      //   type: BottomNavigationBarType.fixed,
      //   elevation: 0,
      // ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        //fillColor: Colors.grey[100],
        // fillColor: const Color(0xFFF7F7F7),
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: const EdgeInsets.all(16),
        hintStyle: const TextStyle(color: Color(0xFF8B8B8F)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Utils.appColor, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        errorStyle: Utils.getTextStyle(
          baseSize: 12,
          isBold: false,
          color: Colors.red,
          isUrdu: Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE
              ? true
              : false,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
          // borderRadius: BorderRadius.circular(16.0),
          // borderSide: BorderSide(
          //   color: Color.fromARGB(255, 244, 244, 246),
          //   width: 2,
          // ),
        ),
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        iconSize: 18,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return Utils.appColor;
          } else if (states.contains(WidgetState.disabled)) {
            return Colors.transparent;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all<Color>(Colors.white),
        side: const BorderSide(color: Colors.grey),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF39374C),
      scaffoldBackgroundColor: const Color(0xFF2C2B3B),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Utils.appColor,
        primary: const Color(0xFF39374C),
        secondary: const Color(0xFF45AE91),
        surface: const Color(0xFF2C2B3B),
        onSurface: Colors.white,
        brightness: Brightness.dark,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF39374C),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF39374C)),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.white),
        displayMedium: TextStyle(color: Colors.white),
        displaySmall: TextStyle(color: Colors.white),
        headlineLarge: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white),
        labelLarge: TextStyle(color: Colors.white),
        labelMedium: TextStyle(color: Colors.white),
        labelSmall: TextStyle(color: Colors.white),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF39374C),
        shape: CircleBorder(),
        foregroundColor: Colors.white,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Colors.white,
        textColor: Colors.white,
        selectedTileColor: Color(0xFF45AE91),
        selectedColor: Color(0xFF45AE91),
        tileColor: Color(0xFF2C2B3B),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF39374C),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF39374C),
        selectedItemColor: Color(0xFF45AE91),
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Color(0xFF45AE91),
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 10,
          color: Color.fromARGB(255, 219, 219, 224),
        ),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF39374C),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: Get.locale?.languageCode == "ar"
            ? const EdgeInsets.only(top: 14, bottom: 14, right: 12)
            : const EdgeInsets.only(top: 14, bottom: 14, left: 12),
        hintStyle: const TextStyle(color: Color(0xFF8B8B8F)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF2C2B3B);
          } else if (states.contains(WidgetState.disabled)) {
            return Colors.grey;
          }
          return const Color(0xFF2C2B3B);
        }),
        checkColor: WidgetStateProperty.all<Color>(Colors.white),
        side: const BorderSide(color: Color(0xFF2C2B3B)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF39374C),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        checkmarkColor: Colors.white,
        selectedColor: const Color(0xFF39374C).withValues(alpha: 0.7),
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Color(0xFF39374C)),
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
      ),
    );
  }
}
