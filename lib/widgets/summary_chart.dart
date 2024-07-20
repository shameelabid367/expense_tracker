// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class SummaryChart extends StatelessWidget {
//   final Map<String, double> data;

//   SummaryChart({required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return BarChart(
//       BarChartData(
//         alignment: BarChartAlignment.spaceAround,
//         maxY: data.values.isNotEmpty ? data.values.reduce((a, b) => a > b ? a : b) : 1,
//         barTouchData: BarTouchData(enabled: true),
//         titlesData: FlTitlesData(
//           show: true,
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (double value, TitleMeta meta) {
//                 final index = value.toInt();
//                 if (index < 0 || index >= data.keys.length) return Container();
//                 return SideTitleWidget(
//                   axisSide: meta.axisSide,
//                   child: Text(data.keys.elementAt(index)),
//                 );
//               },
//             ),
//           ),
//           leftTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (double value, TitleMeta meta) {
//                 return SideTitleWidget(
//                   axisSide: meta.axisSide,
//                   child: Text(value.toString()),
//                 );
//               },
//             ),
//           ),
//         ),
//         borderData: FlBorderData(show: false),
//         barGroups: data.entries.map((entry) {
//           return BarChartGroupData(
//             x: data.keys.toList().indexOf(entry.key),
//             barRods: [
//               BarChartRodData(
//                 toY: entry.value,
//                 color: Theme.of(context).primaryColor,
//               ),
//             ],
//           );
//         }).toList(),
//       ),
//     );
//   }
// }