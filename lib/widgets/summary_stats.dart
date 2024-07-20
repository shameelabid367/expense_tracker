import 'package:expense_tracker/constant/theme/palette.dart';
import 'package:flutter/material.dart';

class SummaryStats extends StatelessWidget {
  final double totalExpenseToday;
  final double totalRevenueToday;
  final double totalExpenseThisMonth;
  final double totalRevenueThisMonth;
  final double totalSavingToday;

  const SummaryStats(
      {super.key,
      required this.totalExpenseToday,
      required this.totalRevenueToday,
      required this.totalExpenseThisMonth,
      required this.totalRevenueThisMonth,
      required this.totalSavingToday
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Palette.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Summary',
            style: TextStyle(color: Palette.whiteColor, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Expense: ₹$totalExpenseToday', style: TextStyle(color: Palette.negativeColor)),
              Text('Total Revenue: ₹$totalRevenueToday', style: TextStyle(color: Palette.positiveColor)),
            ],
          ),
          const Divider(),
          const Text(
            'This Month\'s Summary',
            style: TextStyle(color: Palette.whiteColor, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Expense: ₹$totalExpenseThisMonth', style: TextStyle(color: Palette.negativeColor)),
              Text('Total Revenue: ₹$totalRevenueThisMonth', style: TextStyle(color: Palette.positiveColor)),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Savings: ₹$totalSavingToday', style: TextStyle(color: totalSavingToday > 0 ? Palette.positiveColor : Palette.negativeColor),),
            ],
          ),
        ],
      ),
    );
  }
}
