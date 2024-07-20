import 'package:expense_tracker/constant/theme/palette.dart';
import 'package:expense_tracker/utils/list_extensions.dart';
import 'package:expense_tracker/viewmodels/expense_viewmodel.dart';
import 'package:expense_tracker/widgets/graph_label.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummaryView extends StatefulWidget {
  const ExpenseSummaryView({super.key});

  @override
  ExpenseSummaryViewState createState() => ExpenseSummaryViewState();
}

class ExpenseSummaryViewState extends State<ExpenseSummaryView> {
  bool isWeekly = true;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpenseViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Summary'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10,),
          ToggleButtons(
            isSelected: [isWeekly, !isWeekly],
            borderRadius: BorderRadius.circular(10),
            highlightColor: Palette.gradient2,
            fillColor: Palette.gradient1,
            onPressed: (int index) {
              setState(() {
                isWeekly = index == 0;
              });
            },
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Weekly',
                style: TextStyle(color: Palette.whiteColor)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Monthly',
                  style: TextStyle(color: Palette.whiteColor),
                ),
              ),
            ],
          ),
          const GraphLabel(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LineChart(
                _buildLineChartData(viewModel, isWeekly),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: viewModel.getTotalSaved() > 0 ? Palette.positiveColor : Palette.negativeColor,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Text(
                'Total Saved: \u20B9${viewModel.getTotalSaved() }',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Palette.whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildLineChartData(ExpenseViewModel viewModel, bool isWeekly) {
  final List<FlSpot> expenseSpots = List.generate(7, (index) {
    final value = viewModel
        .getSummaryData(isWeekly, false)
        .getOrDefault(index, 0.0);
    return FlSpot(index.toDouble(), value);
  });

  final List<FlSpot> revenueSpots = List.generate(7, (index) {
    final value = viewModel
        .getSummaryData(isWeekly, true)
        .getOrDefault(index, 0.0);
    return FlSpot(index.toDouble(), value);
  });

  return LineChartData(
    gridData: const FlGridData(show: false),
    titlesData: FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            final int day = value.toInt();
            return SideTitleWidget(
              axisSide: meta.axisSide,
              child: Text(isWeekly
                  ? 'Day ${day + 1}'
                  : 'Month ${day + 1}'),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            return SideTitleWidget(
              axisSide: meta.axisSide,
              child: Text(value.toString()),
            );
          },
        ),
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: Border.all(
        color: Palette.borderColor,
      ),
    ),
    lineBarsData: [
      LineChartBarData(
        spots: expenseSpots,
        isCurved: true,
        color: Colors.red,
        barWidth: 2,
        belowBarData: BarAreaData(show: false),
      ),
      LineChartBarData(
        spots: revenueSpots,
        isCurved: true,
        color: Colors.green,
        barWidth: 2,
        belowBarData: BarAreaData(show: false),
      ),
    ],
  );
}
}
