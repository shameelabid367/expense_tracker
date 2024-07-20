import 'package:expense_tracker/constant/theme/palette.dart';
import 'package:expense_tracker/viewmodels/expense_viewmodel.dart';
import 'package:expense_tracker/views/add_expense_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;

  const ExpenseTile({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Palette.borderColor),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${expense.isRevenue ? '+' : '-'}\u20B9${expense.amount}',
                  style: TextStyle(
                    color: expense.isRevenue
                        ? Palette.positiveColor
                        : Palette.negativeColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  expense.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${expense.date.toLocal()}'.split(' ')[0],
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddExpenseView(
                                        isUpdate: true,
                                        expense: expense,
                                      )));
                        },
                        splashColor: Palette.gradient1,
                        child: Image.asset('assets/icons/edit.png', height: 20),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          context
                              .read<ExpenseViewModel>()
                              .deleteExpense(expense.id);
                        },
                        splashColor: Palette.gradient1,
                        child:
                            Image.asset('assets/icons/delete.png', height: 25),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
