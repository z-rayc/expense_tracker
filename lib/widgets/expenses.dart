// This file is the screen that displays the expenses.
// It has a chart that displays each category.
// It has a list of expenses that displays every expense.
// It can also open an overlay to add a new expense.

import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_time_period.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter Course',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Cinema',
        amount: 15.00,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  /// Opens the add expenses overlay
  void _openAddExpensesOverlay() {
    // When you are in a class that extends state, a global context is available
    showModalBottomSheet(
      useSafeArea:
          true, // Takes camera, etc. into consideration if it affects the UI
      context: context,
      isScrollControlled: true,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  /// Adds an expense to the list of expenses
  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  /// Removes an expense from the list of expenses
  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context)
        .clearSnackBars(); // Prevent queue on multiple dismisses
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 20),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );

    setState(() {
      _registeredExpenses.remove(expense);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    /// The initial widget, if there are no expenses registered yet
    Widget expensesList = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('No expenses found.'),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _openAddExpensesOverlay,
          child: const Text('Get started!'),
        ),
      ],
    );

    if (_registeredExpenses.isNotEmpty) {
      expensesList = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpensesOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: width < 600
          ? Column(children: [
              Chart(expenses: _registeredExpenses),
              // When nesting Lists, it's often a good idea to use Expanded
              ExpensesLastMonth(_registeredExpenses),
              Expanded(child: expensesList),
            ])
          : Row(children: [
              Expanded(child: Chart(expenses: _registeredExpenses)),
              Expanded(child: expensesList),
            ]),
    );
  }
}
