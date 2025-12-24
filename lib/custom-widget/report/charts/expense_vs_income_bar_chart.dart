import 'package:drivvo/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseVsIncomeBarChart extends StatelessWidget {
  final Map<String, Map<String, double>> data;
  final bool isUrdu;

  const ExpenseVsIncomeBarChart({
    super.key,
    required this.data,
    required this.isUrdu,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final sortedMonths = data.keys.toList();
    // Simple sort for months if possible, otherwise keep insertion order
    // for now keep as is.

    // !sortedMonths.sort((a, b) {
    //   // Implement chronological sorting based on your month format
    //   // This is a placeholder - adjust based on actual format
    //   return a.compareTo(b);
    // });

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
            "expense_vs_income".tr,
            style: Utils.getTextStyle(
              baseSize: 18,
              isBold: true,
              color: Colors.black87,
              isUrdu: isUrdu,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _legendItem("expense".tr, Colors.redAccent),
              const SizedBox(width: 16),
              _legendItem("income".tr, Colors.greenAccent),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxY(),
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < sortedMonths.length) {
                          return SideTitleWidget(
                            meta: meta,
                            space: 8,
                            child: Transform.rotate(
                              angle: -0.5,
                              child: Text(
                                sortedMonths[index],
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      getTitlesWidget: (value, meta) {
                        if (value == meta.max) return const SizedBox.shrink();

                        String title = "";
                        if (value >= 1000) {
                          title = "${(value / 1000).toStringAsFixed(1)}k";
                        } else {
                          title = value.toInt().toString();
                        }

                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withValues(alpha: 0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    left: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                barGroups: _buildBarGroups(sortedMonths),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  double _getMaxY() {
    double max = 0;
    for (var m in data.values) {
      if ((m['expense'] ?? 0) > max) max = m['expense']!;
      if ((m['income'] ?? 0) > max) max = m['income']!;
    }
    return max == 0 ? 100 : max * 1.2;
  }

  List<BarChartGroupData> _buildBarGroups(List<String> months) {
    return List.generate(months.length, (index) {
      final mData = data[months[index]]!;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: mData['expense'] ?? 0,
            color: Colors.redAccent,
            width: 10,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          BarChartRodData(
            toY: mData['income'] ?? 0,
            color: Colors.greenAccent,
            width: 10,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    });
  }
}
