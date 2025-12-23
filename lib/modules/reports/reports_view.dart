import 'package:drivvo/custom-widget/report/custom_report_card.dart';
import 'package:drivvo/custom-widget/report/distance_report_card.dart';
import 'package:drivvo/custom-widget/report/report_date_range.dart';
import 'package:drivvo/custom-widget/report/report_tab_bar.dart';
import 'package:drivvo/modules/reports/reports_controller.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(
        () => Column(
          children: [
            // Header with overlapping tab bar
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Teal header background
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Utils.appColor,
                        Utils.appColor.withValues(alpha: 0.9),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              controller.selectedName.value.tr,
                              style: Utils.getTextStyle(
                                baseSize: 24,
                                isBold: true,
                                color: Colors.white,
                                isUrdu: controller.isUrdu,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.tune,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Overlapping tab bar in white container
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: -22,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ReportTabBar(
                      tabs: controller.list
                          .map((name) => Tab(text: name.tr))
                          .toList(),
                      isUrdu: controller.isUrdu,
                      tabController: controller.tabController,
                      onTap: (index) =>
                          controller.onSelect(controller.list[index]),
                    ),
                  ),
                ),
              ],
            ),
            // Spacing for the overlapping tab bar
            const SizedBox(height: 30),
            // Content (Swipeable tabs)
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  _buildReportTab(_buildGeneralCards()),
                  _buildRefuelingCardsTab(),
                  _buildExpenseCardsTab(),
                  _buildIncomeCardsTab(),
                  _buildServiceCardsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTab(Widget content) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReportDateRange(
            isUrdu: controller.isUrdu,
            formattedDateRange: controller.formattedDateRange,
            selectDateRange: controller.selectDateRange,
          ),
          const SizedBox(height: 16),
          content,
          const SizedBox(height: 24),
          _buildChartsSection(),
        ],
      ),
    );
  }

  Widget _buildRefuelingCardsTab() => _buildReportTab(_buildRefuelingCards());
  Widget _buildExpenseCardsTab() => _buildReportTab(_buildExpenseCards());
  Widget _buildIncomeCardsTab() => _buildReportTab(_buildIncomeCards());
  Widget _buildServiceCardsTab() => _buildReportTab(_buildServiceCards());

  Widget _buildGeneralCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomReportCard(
                isUrdu: controller.isUrdu,
                imageUrl: "assets/images/reports/balance.png",
                iconBgColor: const Color(0xFFE8F5F4),
                iconColor: Utils.appColor,
                title: "balance".tr,
                total: controller.formatCurrency(controller.totalBalance.value),
                totalColor: controller.totalBalance.value >= 0
                    ? Utils.appColor
                    : Colors.red,
                byDay: controller.formatCurrency(controller.balanceByDay.value),
                byKm: controller.formatCurrency(controller.balanceByKm.value),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomReportCard(
                isUrdu: controller.isUrdu,
                imageUrl: "assets/images/reports/cost.png",
                iconBgColor: const Color(0xFFFDE8E8),
                iconColor: Colors.red,
                title: "cost".tr,
                total: controller.formatCurrency(controller.totalCost.value),
                totalColor: Colors.red,
                byDay: controller.formatCurrency(controller.costByDay.value),
                byKm: controller.formatCurrency(controller.costByKm.value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CustomReportCard(
                isUrdu: controller.isUrdu,
                imageUrl: "assets/images/reports/income.png",
                iconBgColor: const Color(0xFFE8F5F4),
                iconColor: Colors.green,
                title: "income".tr,
                total: controller.formatCurrency(controller.totalIncome.value),
                totalColor: Colors.black87,
                byDay: controller.formatCurrency(controller.incomeByDay.value),
                byKm: controller.formatCurrency(controller.incomeByKm.value),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DistanceReportCard(
                isUrdu: controller.isUrdu,
                imageUrl: "assets/images/reports/distance.png",
                iconBgColor: const Color(0xFFE3F2FD),
                iconColor: Colors.blue,
                title: "distance".tr,
                total: controller.formatDistance(
                  controller.totalDistance.value,
                ),
                dailyAverage: controller.formatDistance(
                  controller.dailyAverageDistance.value,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRefuelingCards() {
    return Row(
      children: [
        Expanded(
          child: CustomReportCard(
            isUrdu: controller.isUrdu,
            imageUrl: "assets/images/reports/cost2.png",
            iconBgColor: const Color(0xFFE8F5F4),
            iconColor: Utils.appColor,
            title: "cost".tr,
            total: controller.formatCurrency(controller.refuelingCost.value),
            totalColor: Colors.black87,
            byDay: controller.formatCurrency(
              controller.refuelingCostByDay.value,
            ),
            byKm: controller.formatCurrency(controller.refuelingCostByKm.value),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DistanceReportCard(
            isUrdu: controller.isUrdu,
            imageUrl: "assets/images/reports/distance.png",
            iconBgColor: const Color(0xFFE3F2FD),
            iconColor: Colors.blue,
            title: "distance".tr,
            total: controller.formatDistance(
              controller.refuelingDistance.value,
            ),
            dailyAverage: controller.formatDistance(
              controller.refuelingDailyAverage.value,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseCards() {
    return Row(
      children: [
        Expanded(
          child: CustomReportCard(
            isUrdu: controller.isUrdu,
            imageUrl: "assets/images/reports/cost2.png",
            iconBgColor: const Color(0xFFE8F5F4),
            iconColor: Utils.appColor,
            title: "cost".tr,
            total: controller.formatCurrency(controller.expenseCost.value),
            totalColor: Colors.black87,
            byDay: controller.formatCurrency(controller.expenseCostByDay.value),
            byKm: controller.formatCurrency(controller.expenseCostByKm.value),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DistanceReportCard(
            isUrdu: controller.isUrdu,
            imageUrl: "assets/images/reports/distance.png",
            iconBgColor: const Color(0xFFE3F2FD),
            iconColor: Colors.blue,
            title: "distance".tr,
            total: controller.formatDistance(controller.expenseDistance.value),
            dailyAverage: controller.formatDistance(
              controller.expenseDailyAverage.value,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeCards() {
    return Row(
      children: [
        Expanded(
          child: CustomReportCard(
            isUrdu: controller.isUrdu,
            imageUrl: "assets/images/reports/cost2.png",
            iconBgColor: const Color(0xFFE8F5F4),
            iconColor: Utils.appColor,
            title: "income".tr,
            total: controller.formatCurrency(controller.incomeCost.value),
            totalColor: Colors.black87,
            byDay: controller.formatCurrency(controller.incomeCostByDay.value),
            byKm: controller.formatCurrency(controller.incomeCostByKm.value),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DistanceReportCard(
            isUrdu: controller.isUrdu,
            imageUrl: "assets/images/reports/distance.png",
            iconBgColor: const Color(0xFFE3F2FD),
            iconColor: Colors.blue,
            title: "distance".tr,
            total: controller.formatDistance(controller.incomeDistance.value),
            dailyAverage: controller.formatDistance(
              controller.incomeDailyAverage.value,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCards() {
    return Row(
      children: [
        Expanded(
          child: CustomReportCard(
            isUrdu: controller.isUrdu,
            imageUrl: "assets/images/reports/cost2.png",
            iconBgColor: const Color(0xFFE8F5F4),
            iconColor: Utils.appColor,
            title: "cost".tr,
            total: controller.formatCurrency(controller.serviceCost.value),
            totalColor: Colors.black87,
            byDay: controller.formatCurrency(controller.serviceCostByDay.value),
            byKm: controller.formatCurrency(controller.serviceCostByKm.value),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DistanceReportCard(
            isUrdu: controller.isUrdu,
            imageUrl: "assets/images/reports/distance.png",
            iconBgColor: const Color(0xFFE3F2FD),
            iconColor: Colors.blue,
            title: "distance".tr,
            total: controller.formatDistance(controller.serviceDistance.value),
            dailyAverage: controller.formatDistance(
              controller.serviceDailyAverage.value,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "charts".tr,
              style: Utils.getTextStyle(
                baseSize: 16,
                isBold: true,
                color: Utils.appColor,
                isUrdu: controller.isUrdu,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "view_all".tr,
                style: Utils.getTextStyle(
                  baseSize: 14,
                  isBold: false,
                  color: Colors.grey[600]!,
                  isUrdu: controller.isUrdu,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.selectedChartType.value,
                style: Utils.getTextStyle(
                  baseSize: 14,
                  isBold: false,
                  color: Colors.grey[600]!,
                  isUrdu: controller.isUrdu,
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }
}
