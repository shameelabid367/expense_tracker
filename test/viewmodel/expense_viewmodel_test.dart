import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:expense_tracker/viewmodels/expense_viewmodel.dart';
import 'package:expense_tracker/models/expense.dart';

// Mock class for Hive Box
class MockHiveBox extends Mock implements Box<Expense> {}

void main() {
  group('ExpenseViewModel Tests', () {
    late MockHiveBox mockBox;
    late ExpenseViewModel viewModel;

    setUp(() async {
      await Hive.initFlutter();
      Hive.registerAdapter(ExpenseAdapter());
      mockBox = MockHiveBox();
      when(mockBox.values).thenReturn(<Expense>[]);
      viewModel = ExpenseViewModel()..setBox(mockBox);
    });

    test('Initial state', () {
      expect(viewModel.expenses, isEmpty);
      expect(viewModel.summaryType, SummaryType.weekly);
    });

    test('Add Expense', () {
      final expense = Expense(id: '1', amount: 100, date: DateTime.now(), isRevenue: false, description: 'For testing');
      viewModel.addExpense(expense);

      verify(mockBox.put(expense.id, expense)).called(1);
      expect(viewModel.expenses.length, 1);
    });

    test('Update Expense', () {
      final expense = Expense(id: '1', amount: 100, date: DateTime.now(), isRevenue: false, description: 'For testing');
      final updatedExpense = Expense(id: '1', amount: 200, date: DateTime.now(), isRevenue: false, description: 'For testing');

      viewModel.addExpense(expense);
      viewModel.updateExpense(updatedExpense);

      verify(mockBox.put(expense.id, expense)).called(1);
      verify(mockBox.put(updatedExpense.id, updatedExpense)).called(1);
      expect(viewModel.expenses.first.amount, 200);
    });

    test('Delete Expense', () {
      final expense = Expense(id: '1', amount: 100, date: DateTime.now(), isRevenue: false, description: 'For testing');
      viewModel.addExpense(expense);
      viewModel.deleteExpense(expense.id);

      verify(mockBox.delete(expense.id)).called(1);
      expect(viewModel.expenses, isEmpty);
    });

    test('Get Total Saved', () {
      final revenue = Expense(id: '1', amount: 200, date: DateTime.now(), isRevenue: true, description: 'For testing');
      final expense = Expense(id: '2', amount: 100, date: DateTime.now(), isRevenue: false, description: 'For testing');

      viewModel.addExpense(revenue);
      viewModel.addExpense(expense);

      expect(viewModel.getTotalSaved(), 100);
    });

    test('Set and Get Summary Type', () {
      viewModel.setSummaryType(SummaryType.monthly);
      expect(viewModel.summaryType, SummaryType.monthly);
    });

    test('Get Total Expense In Range', () {
      final now = DateTime.now();
      final expense = Expense(id: '1', amount: 100, date: now, isRevenue: false, description: 'For testing');

      viewModel.addExpense(expense);

      expect(viewModel.getTotalExpenseInRange(), 100);
    });

    test('Get Total Revenue In Range', () {
      final now = DateTime.now();
      final revenue = Expense(id: '1', amount: 200, date: now, isRevenue: true, description: 'For testing');

      viewModel.addExpense(revenue);

      expect(viewModel.getTotalRevenueInRange(), 200);
    });

    test('Set Current Period', () {
      final start = DateTime(2022, 1, 1);
      final end = DateTime(2022, 1, 31);

      viewModel.setCurrentPeriod(start, end);

      expect(viewModel.currentStartDate, start);
      expect(viewModel.currentEndDate, end);
    });

    test('Previous and Next Period', () {
      final start = DateTime.now();
      final end = DateTime.now().add(const Duration(days: 1));

      viewModel.setCurrentPeriod(start, end);

      viewModel.previousPeriod();
      expect(viewModel.currentStartDate, start.subtract(const Duration(days: 1)));
      expect(viewModel.currentEndDate, end.subtract(const Duration(days: 1)));

      viewModel.nextPeriod();
      expect(viewModel.currentStartDate, start);
      expect(viewModel.currentEndDate, end);
    });

    test('Get Filtered Expenses', () {
      final now = DateTime.now();
      final expense1 = Expense(id: '1', amount: 100, date: now.subtract(const Duration(days: 1)), isRevenue: false, description: 'For testing');
      final expense2 = Expense(id: '2', amount: 200, date: now, isRevenue: false, description: 'For testing');

      viewModel.addExpense(expense1);
      viewModel.addExpense(expense2);

      viewModel.setCurrentPeriod(now.subtract(const Duration(days: 1)), now);

      expect(viewModel.getFilteredExpenses().length, 2);
    });

    test('Get Summary Data', () {
      final now = DateTime.now();
      final expense1 = Expense(id: '1', amount: 100, date: now.subtract(const Duration(days: 1)), isRevenue: false, description: 'For testing');
      final expense2 = Expense(id: '2', amount: 200, date: now, isRevenue: false, description: 'For testing');

      viewModel.addExpense(expense1);
      viewModel.addExpense(expense2);

      final summaryData = viewModel.getSummaryData(true, false);
      expect(summaryData.length, 7);
      expect(summaryData[0], 0);
      expect(summaryData[6], 200);
    });
  });
}