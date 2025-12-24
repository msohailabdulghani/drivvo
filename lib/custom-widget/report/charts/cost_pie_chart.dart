import 'package:drivvo/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CostPieChart extends StatelessWidget {
  final double refueling;
  final double expense;
  final double service;
  final double income;
  final bool isUrdu;

  const CostPieChart({
    super.key,
    required this.refueling,
    required this.expense,
    required this.service,
    required this.income,
    required this.isUrdu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "cost_comparison_chart".tr,
            style: Utils.getTextStyle(
              baseSize: 18,
              isBold: true,
              color: Colors.black87,
              isUrdu: isUrdu,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: _buildSections(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildLegend(),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final total = refueling + expense + service + income;
    if (total == 0) {
      return [
        PieChartSectionData(
          color: Colors.grey[300],
          value: 1,
          title: '',
          radius: 50,
        ),
      ];
    }

    return [
      if (refueling > 0)
        PieChartSectionData(
          color: const Color(0xFFFB9601),
          value: refueling,
          title: '${((refueling / total) * 100).toStringAsFixed(1)}%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      if (expense > 0)
        PieChartSectionData(
          color: Colors.red,
          value: expense,
          title: '${((expense / total) * 100).toStringAsFixed(1)}%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      if (service > 0)
        PieChartSectionData(
          color: Colors.brown,
          value: service,
          title: '${((service / total) * 100).toStringAsFixed(1)}%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      if (income > 0)
        PieChartSectionData(
          color: Colors.green,
          value: income,
          title: '${((income / total) * 100).toStringAsFixed(1)}%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
    ];
  }

  Widget _buildLegend() {
    final costsTotal = refueling + expense + service;
    final total = costsTotal + income;
    return Column(
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 10,
          children: [
            _legendItem("refueling".tr, const Color(0xFFFB9601), refueling),
            _legendItem("expense".tr, Colors.red, expense),
            _legendItem("service".tr, Colors.brown, service),
            _legendItem("income".tr, Colors.green, income),
          ],
        ),
        if (total > 0) ...[
          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.black12),
          const SizedBox(height: 12),
          if (costsTotal > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "total_cost".tr,
                  style: Utils.getTextStyle(
                    baseSize: 14,
                    isBold: true,
                    color: Colors.black87,
                    isUrdu: isUrdu,
                  ),
                ),
                Text(
                  _formatCost(costsTotal),
                  style: Utils.getTextStyle(
                    baseSize: 14,
                    isBold: true,
                    color: Colors.redAccent,
                    isUrdu: isUrdu,
                  ),
                ),
              ],
            ),
          if (income > 0) ...[
            if (costsTotal > 0) const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "total_income".tr,
                  style: Utils.getTextStyle(
                    baseSize: 14,
                    isBold: true,
                    color: Colors.black87,
                    isUrdu: isUrdu,
                  ),
                ),
                Text(
                  _formatCost(income),
                  style: Utils.getTextStyle(
                    baseSize: 14,
                    isBold: true,
                    color: Colors.green,
                    isUrdu: isUrdu,
                  ),
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }

  Widget _legendItem(String label, Color color, double value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          "$label: ${_formatCost(value)}",
          style: Utils.getTextStyle(
            baseSize: 12,
            isBold: true,
            color: Colors.black54,
            isUrdu: isUrdu,
          ),
        ),
      ],
    );
  }

  String _formatCost(double value) {
    return "\$${value.toStringAsFixed(2)}";
  }
}
