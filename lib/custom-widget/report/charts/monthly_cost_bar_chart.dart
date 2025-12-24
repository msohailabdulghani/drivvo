import 'package:drivvo/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MonthlyCostBarChart extends StatelessWidget {
  final Map<String, double> monthlyData;
  final bool isUrdu;
  final String title;

  const MonthlyCostBarChart({
    super.key,
    required this.monthlyData,
    required this.isUrdu,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (monthlyData.isEmpty) return const SizedBox.shrink();

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
            title.tr,
            style: Utils.getTextStyle(
              baseSize: 18,
              isBold: true,
              color: Colors.black87,
              isUrdu: isUrdu,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
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
                      getTitlesWidget: _getBottomTitles,
                      reservedSize: 35,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: _getLeftTitles,
                      reservedSize: 45,
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
                barGroups: _buildBarGroups(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getMaxY() {
    double max = 0;
    for (var value in monthlyData.values) {
      if (value > max) max = value;
    }
    return max * 1.2;
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    final months = monthlyData.keys.toList();
    if (value.toInt() >= 0 && value.toInt() < months.length) {
      return SideTitleWidget(
        meta: meta,
        space: 8,
        child: Transform.rotate(
          angle: -0.5,
          child: Text(
            months[value.toInt()],
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _getLeftTitles(double value, TitleMeta meta) {
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
        style: const TextStyle(color: Colors.grey, fontSize: 10),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final values = monthlyData.values.toList();
    return List.generate(values.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: values[index],
            color: Utils.appColor,
            width: 16,
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
