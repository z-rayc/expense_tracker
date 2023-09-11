// This file represents the data model for an expense.
// It says what an expense is and how it should be represented.
// It contains the data for the categories and the icons for them.
// It also contains the data for the expense buckets, which are used in the chart.
// It says how the date should be formatted, and gets the expense a random id.

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();
const uuid = Uuid();

enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id; // 'flutter pub add uuid' to add uuid to the project
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  /// Returns the date formatted as mm/dd/yyyy
  String get formattedDate {
    return formatter.format(date); // 'flutter pub add intl'
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  /// Returns the total amount of expenses in this bucket
  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}
