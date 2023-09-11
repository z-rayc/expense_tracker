import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

/// Displays the total amount of expenses in a given time period.
class ExpensesTimePeriod {
  ExpensesTimePeriod({
    required this.expenses,
    required this.startDate,
    required this.endDate,
  });

  final List<Expense> expenses;
  final DateTime startDate;
  final DateTime endDate;

  /// Checks if the expense is within the time period (start and end inclusive)
  bool _isWithinTimePeriod(DateTime date) {
    return (date == startDate ||
        date == endDate ||
        date.isAfter(startDate) && date.isBefore(endDate));
  }

  /// Returns the total amount of expenses in this time period
  List<Expense> get expensesInTimePeriod {
    return expenses
        .where((expense) => _isWithinTimePeriod(expense.date))
        .toList();
  }

  /// Gets the total amount of expenses in this time period
  double get totalExpenses {
    double sum = 0;

    for (final expense in expensesInTimePeriod) {
      sum += expense.amount;
    }

    return sum;
  }
}

/// Displays the total amount of expenses in the last month.
/// Starting from the first date of the month, to the current date.
class ExpensesLastMonth extends StatelessWidget {
  ExpensesLastMonth(this.expenses, {super.key}) {
    /// Set the expensesTimePeriod to the last month
    expensesTimePeriod = ExpensesTimePeriod(
      expenses: expenses,
      startDate: startDate,
      endDate: DateTime.now(),
    );
  }

  final List<Expense> expenses;

  /// Set a placeholder expensesTimePeriod
  ExpensesTimePeriod expensesTimePeriod = ExpensesTimePeriod(
    expenses: [],
    startDate: DateTime.now(),
    endDate: DateTime.now(),
  );

  /// Gets the first day of the current month
  DateTime get startDate {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Expenses so far this month:',
          ),
          Text('\$${expensesTimePeriod.totalExpenses.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}
