import 'package:expense_tracker/constant/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/expense_viewmodel.dart';
import '../models/expense.dart';
import 'package:uuid/uuid.dart';

class AddExpenseView extends StatefulWidget {
  final bool isUpdate;
  final Expense? expense;

  const AddExpenseView({super.key, this.isUpdate = false, this.expense});

  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  final TextEditingController amountController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final DateTime selectedDate = DateTime.now();

  final uuid = const Uuid();

  late String _type;

  void _setType() {
    if (widget.isUpdate) {
      _type = widget.expense!.isRevenue ? 'Revenue' : 'Expense';
    } else {
      _type = 'Expense';
    }
  }

  @override
  void initState() {
    super.initState();
    _setType();
    if (widget.isUpdate == true) {
      amountController.text = widget.expense!.amount.toString();
      descriptionController.text = widget.expense!.description;
      // _type =
    }
  }

  // Default selection
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.isUpdate ? 'Update Expense' : 'Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 30,),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30,),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            // Text('Type'),
            RadioListTile<String>(
              title: const Text(
                'Expense',
                style: TextStyle(
                  color: Palette.whiteColor,
                ),
              ),
              value: 'Expense',
              groupValue: _type,
              onChanged: (value) {
                setState(() {
                  _type = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Revenue',
              style: TextStyle(
                  color: Palette.whiteColor,
                ),),
              value: 'Revenue',
              groupValue: _type,
              onChanged: (value) {
                setState(() {
                  _type = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.parse(amountController.text);
                final description = descriptionController.text;
                final expense = Expense(
                    id: widget.isUpdate ? widget.expense!.id : uuid.v4(),
                    amount: amount,
                    date: context.read<ExpenseViewModel>().currentStartDate,
                    description: description,
                    isRevenue: _type == 'Revenue' ? true : false);
                if (widget.isUpdate) {
                  context.read<ExpenseViewModel>().updateExpense(expense);
                } else {
                  context.read<ExpenseViewModel>().addExpense(expense);
                }
                Navigator.pop(context);
              },
              child: Text(widget.isUpdate ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }
}
