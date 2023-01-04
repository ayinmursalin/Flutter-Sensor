import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SensorChartView extends StatelessWidget {
  final String title;
  final List<FlSpot> xSpots;
  final List<FlSpot> ySpots;
  final List<FlSpot> zSpots;

  final double minY;
  final double maxY;

  const SensorChartView({
    Key? key,
    required this.title,
    required this.xSpots,
    required this.ySpots,
    required this.zSpots,
    this.minY = -20,
    this.maxY = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, right: 16),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 240,
            child: LineChart(
              LineChartData(
                clipData: FlClipData.all(),
                maxY: maxY,
                minY: minY,
                lineBarsData: [
                  LineChartBarData(
                    spots: xSpots,
                    color: Colors.red,
                    dotData: FlDotData(show: false),
                    barWidth: 1,
                    isCurved: true,
                  ),
                  LineChartBarData(
                    spots: ySpots,
                    color: Colors.green,
                    dotData: FlDotData(show: false),
                    barWidth: 1,
                    isCurved: true,
                  ),
                  LineChartBarData(
                    spots: zSpots,
                    color: Colors.blue,
                    dotData: FlDotData(show: false),
                    barWidth: 1,
                    isCurved: true,
                  ),
                ],
                lineTouchData: LineTouchData(enabled: false),
                gridData: FlGridData(
                  show: false,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                ),
                baselineX: 0,
                baselineY: 0,
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
