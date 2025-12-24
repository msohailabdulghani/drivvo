import 'package:drivvo/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> data;
  final String title;
  final bool isUrdu;

  const CategoryPieChart({
    super.key,
    required this.data,
    required this.title,
    required this.isUrdu,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

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
            title,
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
    final total = data.values.fold(0.0, (sum, val) => sum + val);
    if (total == 0) return [];
    final List<Color> colors = _getPalette(data.length);
    int index = 0;

    return data.entries.map((entry) {
      final color = colors[index % colors.length];
      index++;
      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '${((entry.value / total) * 100).toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend() {
    final List<Color> colors = _getPalette(data.length);
    final total = data.values.fold(0.0, (sum, val) => sum + val);
    int index = 0;

    return Column(
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 10,
          children: data.entries.map((entry) {
            final color = colors[index % colors.length];
            index++;
            return _legendItem(entry.key, color, entry.value);
          }).toList(),
        ),
        if (total > 0) ...[
          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.black12),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title == "income".tr ? "total_income".tr : "total_cost".tr,
                style: Utils.getTextStyle(
                  baseSize: 14,
                  isBold: true,
                  color: Colors.black87,
                  isUrdu: isUrdu,
                ),
              ),
              Text(
                _formatValue(total),
                style: Utils.getTextStyle(
                  baseSize: 14,
                  isBold: true,
                  color: title == "income".tr ? Colors.green : Colors.redAccent,
                  isUrdu: isUrdu,
                ),
              ),
            ],
          ),
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
          "${label.tr}: ${_formatValue(value)}",
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

  String _formatValue(double value) {
    return "\$${value.toStringAsFixed(2)}";
  }

  List<Color> _getPalette(int count) {
    return [
      Utils.appColor,
      Colors.orange,
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.brown,
      Colors.teal,
      Colors.amber,
      Colors.indigo,
    ];
  }
}
