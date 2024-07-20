import 'package:expense_tracker/constant/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/expense_viewmodel.dart';

class DateFilterWidget extends StatelessWidget {
  final Function(DateTime startDate, DateTime endDate) onDateRangeSelected;

  const DateFilterWidget({super.key, required this.onDateRangeSelected});

  @override
  Widget build(BuildContext context) {
    final expenseViewModel = Provider.of<ExpenseViewModel>(context);

    return Column(
      children: [
        ToggleButtons(
          isSelected: [
            expenseViewModel.isDaily,
            expenseViewModel.isWeekly,
            expenseViewModel.isMonthly
          ],
          borderRadius: BorderRadius.circular(10),
          highlightColor: Palette.gradient2,
          fillColor: Palette.gradient1,
          onPressed: (int index) {
            if (index == 0) {
              expenseViewModel.setDailyView();
            } else if (index == 1) {
              expenseViewModel.setWeeklyView();
            } else {
              expenseViewModel.setMonthlyView();
            }
          },
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Daily',
                style: TextStyle(color: Palette.whiteColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Weekly',
                style: TextStyle(color: Palette.whiteColor),
              ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                expenseViewModel.previousPeriod();
                onDateRangeSelected(
                  expenseViewModel.currentStartDate,
                  expenseViewModel.currentEndDate,
                );
              },
            ),
            Text(
              expenseViewModel.currentPeriodLabel,
              style: const TextStyle(fontSize: 16),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                expenseViewModel.nextPeriod();
                onDateRangeSelected(
                  expenseViewModel.currentStartDate,
                  expenseViewModel.currentEndDate,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
