import 'package:drivvo/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FuelPriceLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final bool isUrdu;

  const FuelPriceLineChart({
    super.key,
    required this.spots,
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
            "fuel_price_chart".tr,
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
            child: spots.isEmpty
                ? Center(
                    child: Text(
                      "no_entries_yet".tr,
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      minX: _getMinX(),
                      maxX: _getMaxX(),
                      minY: 0,
                      maxY: _getMaxY(),
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
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 35,
                            interval: _getBottomInterval(),
                            getTitlesWidget: (value, meta) {
                              final date = DateTime.fromMillisecondsSinceEpoch(
                                value.toInt(),
                              );
                              return SideTitleWidget(
                                meta: meta,
                                space: 8,
                                child: Transform.rotate(
                                  angle: -0.5,
                                  child: Text(
                                    DateFormat('MMM d').format(date),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 45,
                            getTitlesWidget: (value, meta) {
                              if (value == meta.max)
                                return const SizedBox.shrink();
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(
                                  value.toStringAsFixed(2),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
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
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: spots.length > 1,
                          color: Colors.orangeAccent,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.orangeAccent.withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  double? _getMinX() {
    if (spots.isEmpty) return null;
    if (spots.length == 1) {
      return spots[0].x - Duration(days: 1).inMilliseconds;
    }
    return null;
  }

  double? _getMaxX() {
    if (spots.isEmpty) return null;
    if (spots.length == 1) {
      return spots[0].x + Duration(days: 1).inMilliseconds;
    }
    return null;
  }

  double _getMaxY() {
    if (spots.isEmpty) return 10;
    double max = 0;
    for (var spot in spots) {
      if (spot.y > max) max = spot.y;
    }
    return max == 0 ? 10 : max * 1.2;
  }

  double _getBottomInterval() {
    if (spots.isEmpty) return 1;
    final minX = spots.first.x;
    final maxX = spots.last.x;
    final diff = maxX - minX;

    if (diff == 0) return const Duration(days: 1).inMilliseconds.toDouble();
    return diff / 4;
  }
}
