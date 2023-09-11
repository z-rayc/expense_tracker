// This file displays the list of expenses.
// Each expense is a card, and can be swiped away to delete it.
// Swiping away an expense also displays a snackbar that allows you to undo the deletion.

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    // builder() tells us that the list should only create the list items when they are about to become visible
    return ListView.builder(
      itemCount: expenses
          .length, // itemBuilder will be called itemCount amount of times, creating that amount of items
      itemBuilder: (ctx, index) => Dismissible(
          background: Container(
            color: Theme.of(context).colorScheme.error,
            // The color could be changed for example with ^ error.withOpacity(0.75);
            margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal,
              // Here margin needs ! because it could be undeclared. But we know we declared it
            ),
          ),
          // Dismissible widgets still store data if swiped away
          key: ValueKey(expenses[index]),
          onDismissed: (_) {
            onRemoveExpense(expenses[index]);
          },
          child: ExpenseItem(expense: expenses[index])),
    );
  }
}
