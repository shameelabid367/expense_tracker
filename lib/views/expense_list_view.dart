import 'package:expense_tracker/constant/theme/palette.dart';
import 'package:expense_tracker/views/add_expense_view.dart';
import 'package:expense_tracker/views/expense_summary_view.dart';
import 'package:expense_tracker/widgets/summary_stats.dart';
import 'package:expense_tracker/widgets/date_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../viewmodels/expense_viewmodel.dart';
import '../widgets/expense_tile.dart';

class ExpenseListView extends StatefulWidget {
  const ExpenseListView({super.key});

  @override
  State<ExpenseListView> createState() => _ExpenseListViewState();
}

class _ExpenseListViewState extends State<ExpenseListView> {
  @override
  Widget build(BuildContext context) {
    Animate.restartOnHotReload = true;
    final expenseViewModel = Provider.of<ExpenseViewModel>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Expenses'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExpenseSummaryView(),
                  ),
                );
              },
              icon: const Icon(
                Icons.calendar_month,
                size: 35,
                color: Palette.whiteColor,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
        body: Column(
          children: [
            DateFilterWidget(
              onDateRangeSelected: (startDate, endDate) {
                expenseViewModel.setCurrentPeriod(startDate, endDate);
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: expenseViewModel.getFilteredExpenses().length,
                itemBuilder: (context, index) {
                  return ExpenseTile(
                          expense:
                              expenseViewModel.getFilteredExpenses()[index])
                      .animate(delay: ((index * 300) + 400).ms)
                      .fade(duration: 300.ms)
                      .scaleXY(begin: 0.9, end: 1);
                },
              ),
            ),
            SummaryStats(
              totalExpenseToday: expenseViewModel.getTotalExpenseInRange(),
              totalRevenueToday: expenseViewModel.getTotalRevenueInRange(),
              totalExpenseThisMonth:
                  expenseViewModel.getTotalExpenseThisMonth(),
              totalRevenueThisMonth:
                  expenseViewModel.getTotalRevenueThisMonth(),
              totalSavingToday: expenseViewModel.getTotalSaved(),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 150),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddExpenseView()),
              );
            },
            tooltip: 'Add Expense',
            // child: Icon(Icons.add),
            child: const Icon(
              Icons.add,
              size: 35,
            ),
          ),
        ));
  }
}
