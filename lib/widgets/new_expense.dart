// This file is the form where you can input the data for a new expense.
// It has text fields for the title and amount.
// It has a dropdown for category and a date picker for the date.

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  // When using  text editing controllers, always dispose of it after
  // Or else it will live on in memory even when the modal is closed, causing memory leaks
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  /// Opens the date picker
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    // Show dialog based on platform
    if (Platform.isIOS) {
      // showCupertinoDialog is a Cupertino widget (iOS style)
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    }
  }

  /// Submits the expense data.
  /// Checks if input is valid and adds the expense to the list of expenses if valid.
  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showDialog();
    } else {
      widget.onAddExpense(Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    final titleInput = TextField(
      controller: _titleController,
      maxLength: 50,
      decoration: const InputDecoration(
        label: Text('Title'),
      ),
    );

    final amountInput = TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        prefixText: '\$ ',
        label: Text('Amount'),
      ),
    );

    final categoryInput = DropdownButton(
      value: _selectedCategory,
      items: Category.values
          .map(
            (category) => DropdownMenuItem(
              value: category,
              child: Text(
                category.name.toUpperCase(),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          if (value != null) {
            _selectedCategory = value;
          }
        });
      },
    );

    final datePicker = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _selectedDate == null
              ? 'No date selected'
              : formatter.format(_selectedDate!),
        ),
        IconButton(
          onPressed: _presentDatePicker,
          icon: const Icon(
            Icons.calendar_month,
          ),
        )
      ],
    );

    final cancelButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('Cancel'),
    );

    final confirmButton = ElevatedButton(
      onPressed: () {
        _submitExpenseData();
      },
      child: const Text('Save Expense'),
    );

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: titleInput),
                      const SizedBox(width: 16),
                      Expanded(child: amountInput),
                    ],
                  )
                else
                  titleInput,
                if (width >= 600)
                  Row(
                    children: [
                      Expanded(child: categoryInput),
                      const SizedBox(width: 16),
                      Expanded(child: datePicker),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(child: amountInput),
                      const SizedBox(width: 16),
                      Expanded(child: datePicker),
                    ],
                  ),
                const SizedBox(height: 16),
                if (width >= 600)
                  Row(
                    children: [
                      cancelButton,
                      confirmButton,
                    ],
                  )
                else
                  Row(
                    children: [
                      categoryInput,
                      const Spacer(),
                      cancelButton,
                      confirmButton,
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
