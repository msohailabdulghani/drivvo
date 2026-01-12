import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';

enum TimelineEntryType { refueling, expense, service, income, route, welcome }

class TimelineEntry {
  final TimelineEntryType type;
  final String title;
  final int odometer;
  final DateTime date;
  final String amount;
  final bool isIncome;
  final IconData icon;
  final Color iconBgColor;
  final String? driveName;

  //!For Routes
  final String? origin;
  final String? routeOdometer;
  final DateTime? routeStartDate;
  final DateTime? routeEndDate;

  //!For edit delete
  final dynamic originalData;

  TimelineEntry({
    required this.type,
    required this.title,
    required this.odometer,
    required this.date,
    required this.amount,
    required this.isIncome,
    required this.icon,
    required this.iconBgColor,
    this.driveName,
    this.origin,
    this.routeOdometer,
    this.routeStartDate,
    this.routeEndDate,
    this.originalData,
  });

  String get routeStartFormattedDate {
    return date.day.toString().padLeft(2, '0');
  }

  String get formattedDate {
    return Utils.formatAccountDate(date);
  }

  // String get routeStartFormattedDate {
  //   return Utils.formatAccountDate(routeStartDate ?? DateTime.now());
  // }

  String get routeEndFormattedDate {
    return Utils.formatAccountDate(routeEndDate ?? DateTime.now());
  }

  // Get month-year key for grouping (e.g., "DECEMBER 2025")
  String get monthYearKey {
    const months = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
