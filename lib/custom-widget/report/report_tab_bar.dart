import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';

class ReportTabBar extends StatelessWidget {
  final List<Widget> tabs;
  final bool isUrdu;
  final TabController tabController;
  final Function(int index) onTap;

  const ReportTabBar({
    super.key,
    required this.tabs,
    required this.isUrdu,
    required this.tabController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      dividerColor: Colors.transparent,
      indicator: BoxDecoration(
        color: Utils.appColor,
        borderRadius: BorderRadius.circular(16),
      ),
      indicatorPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: Colors.white,
      padding: EdgeInsets.all(0),
      unselectedLabelColor: Colors.grey[600],
      labelStyle: Utils.getTextStyle(
        baseSize: 14,
        isBold: true,
        color: Colors.white,
        isUrdu: isUrdu,
      ),
      unselectedLabelStyle: Utils.getTextStyle(
        baseSize: 14,
        isBold: false,
        color: Colors.grey[600]!,
        isUrdu: isUrdu,
      ),
      onTap: (index) => onTap(index),
      tabs: tabs,
    );
  }
}
