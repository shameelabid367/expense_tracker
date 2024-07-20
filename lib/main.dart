import 'package:expense_tracker/constant/theme/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/expense.dart';
import 'viewmodels/expense_viewmodel.dart';
import 'views/expense_list_view.dart';
import 'views/add_expense_view.dart';
import 'views/expense_summary_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and open the box
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  await Hive.openBox<Expense>('expenses');

  // Initialize notifications

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ExpenseViewModel(),
        ),
      ],
      child: MediaQuery.withNoTextScaling(
        child: MaterialApp(
          title: 'Personal Expense Tracker',
          debugShowCheckedModeBanner: false,
          theme: MyTheme.myTheme,
          home: const ExpenseListView(),
          routes: {
            '/addExpense': (context) => const AddExpenseView(),
            '/expenseSummary': (context) => const ExpenseSummaryView(),
          },
        ),
      ),
    );
  }
}
