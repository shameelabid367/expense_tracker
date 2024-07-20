import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';

enum SummaryType { weekly, monthly }

class ExpenseViewModel extends ChangeNotifier {
  Box<Expense> _expenseBox = Hive.box<Expense>('expenses');
  SummaryType _summaryType = SummaryType.weekly;

  List<Expense> get expenses => _expenseBox.values.toList();

  void setBox(Box<Expense> box) {
    Hive.openBox('expenses');
    _expenseBox = box;
  }

  void addExpense(Expense expense) {
    _expenseBox.put(expense.id, expense);
    notifyListeners();
  }

  void updateExpense(Expense updatedExpense) {
    int index = expenses.indexWhere((expense) => expense.id == updatedExpense.id);
  if (index != -1) {
    expenses[index] = updatedExpense;
    _expenseBox.put(updatedExpense.id, updatedExpense);
    // notifyListeners();
  }
    notifyListeners();
  }

  void editExpense(Expense expense) {
    _expenseBox.put(expense.id, expense);
    notifyListeners();
  }

  void deleteExpense(String id) {
    _expenseBox.delete(id);

      notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void setSummaryType(SummaryType type) {
    _summaryType = type;
    notifyListeners();
  }

  List<double> getSummaryData(bool isWeekly, bool isRevenue)  {
  final now = DateTime.now();
  final daysInPeriod = isWeekly ? 7 : now.month;

  List<double> summaryData = List.filled(daysInPeriod, 0.0);

  // Calculate data based on isWeekly or isMonthly
  for (var expense in expenses) {
    if (expense.isRevenue == isRevenue) {
      DateTime expenseDate = expense.date;
      int index = isWeekly
          ? (now.difference(expenseDate).inDays ~/ 7)
          : expenseDate.month - 1;

      if (index >= 0 && index < summaryData.length) {
        summaryData[index] += expense.amount;
      }
    }
  }

  return summaryData;
} 



  double getTotalSaved() {
    double totalRevenue = expenses
        .where((expense) => expense.isRevenue)
        .fold(0.0, (sum, expense) => sum + expense.amount);
    double totalExpense = expenses
        .where((expense) => !expense.isRevenue)
        .fold(0.0, (sum, expense) => sum + expense.amount);
    return totalRevenue - totalExpense;
  }

  SummaryType get summaryType => _summaryType;

  double getTotalAmountByType(String type, DateTime startDate, DateTime endDate) {
    bool isRevenue;
    if (type == 'Revenue') {
      isRevenue = true;
    } else {
      isRevenue = false;
    }

  DateTime startDateWithoutTime = DateTime(startDate.year, startDate.month, startDate.day);
  DateTime endtDateWithoutTime = DateTime(endDate.year, endDate.month, endDate.day);
  return expenses
      .where((expense) => expense.isRevenue == isRevenue && 
                          expense.date.isAfter(startDateWithoutTime) && 
                          expense.date.isBefore(endtDateWithoutTime))
      .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  DateTime getCurrentDateWithoutTime(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}
  double getTotalExpenseInRange() {

  return getTotalAmountByType('Expense', currentStartDate, currentEndDate.add(const Duration(days: 1)));
}

double getTotalRevenueInRange() {
  return getTotalAmountByType('Revenue', currentStartDate, currentEndDate.add(const Duration(days: 1)));
}



  double getTotalExpenseThisMonth() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month);
    final nextMonthStart = DateTime(now.year, now.month + 1);
    return getTotalAmountByType('Expense', monthStart, nextMonthStart);
  }

  double getTotalRevenueThisMonth() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month);
    final nextMonthStart = DateTime(now.year, now.month + 1);
    return getTotalAmountByType('Revenue', monthStart, nextMonthStart);
  }

  bool isDaily = true;
  bool isWeekly = false;
  bool isMonthly = false;

  DateTime currentStartDate = DateTime.now();
  DateTime currentEndDate = DateTime.now();

  List<Expense> getFilteredExpenses() {
  return expenses.where((expense) {
    DateTime expenseDate = DateTime(expense.date.year, expense.date.month, expense.date.day);
    DateTime startDate = DateTime(currentStartDate.year, currentStartDate.month, currentStartDate.day);
    DateTime endDate = DateTime(currentEndDate.year, currentEndDate.month, currentEndDate.day).add(const Duration(days: 1));
    return expenseDate.isAfter(startDate.subtract(const Duration(days: 1))) && 
           expenseDate.isBefore(endDate);
  }).toList();
}


  void setDailyView() {
    isDaily = true;
    isWeekly = false;
    isMonthly = false;
    setCurrentPeriod(DateTime.now(), DateTime.now());
    notifyListeners();
  }

  void setWeeklyView() {
    isDaily = false;
    isWeekly = true;
    isMonthly = false;
    setCurrentPeriod(
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      DateTime.now().add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday)),
    );
    notifyListeners();
  }

  void setMonthlyView() {
    isDaily = false;
    isWeekly = false;
    isMonthly = true;
    setCurrentPeriod(
      DateTime(DateTime.now().year, DateTime.now().month, 1),
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
    );
    notifyListeners();
  }

  void previousPeriod() {
    if (isDaily) {
      setCurrentPeriod(
        currentStartDate.subtract(const Duration(days: 1)),
        currentEndDate.subtract(const Duration(days: 1)),
      );
    } else if (isWeekly) {
      setCurrentPeriod(
        currentStartDate.subtract(const Duration(days: 7)),
        currentEndDate.subtract(const Duration(days: 7)),
      );
    } else if (isMonthly) {
      setCurrentPeriod(
        DateTime(currentStartDate.year, currentStartDate.month - 1, 1),
        DateTime(currentEndDate.year, currentEndDate.month, 0),
      );
    }
    notifyListeners();
  }

  void nextPeriod() {
    if (isDaily) {
      setCurrentPeriod(
        currentStartDate.add(const Duration(days: 1)),
        currentEndDate.add(const Duration(days: 1)),
      );
    } else if (isWeekly) {
      setCurrentPeriod(
        currentStartDate.add(const Duration(days: 7)),
        currentEndDate.add(const Duration(days: 7)),
      );
    } else if (isMonthly) {
      setCurrentPeriod(
        DateTime(currentStartDate.year, currentStartDate.month + 1, 1),
        DateTime(currentEndDate.year, currentEndDate.month + 2, 0),
      );
    }
    notifyListeners();
  }

  void setCurrentPeriod(DateTime start, DateTime end) {
    currentStartDate = start;
    currentEndDate = end;
  }

  String get currentPeriodLabel {
    if (isDaily) {
      return '${currentStartDate.day}/${currentStartDate.month}/${currentStartDate.year}';
    } else if (isWeekly) {
      return '${currentStartDate.day}/${currentStartDate.month} - ${currentEndDate.day}/${currentEndDate.month}';
    } else if (isMonthly) {
      return '${currentStartDate.month}/${currentStartDate.year}';
    }
    return '';
  }

  
}
