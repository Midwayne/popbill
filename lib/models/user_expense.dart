import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final dateFormatter = DateFormat.yMd(); // 7/10/1996
//final timeFormatter = DateFormat.jm(); // 5:08 PM

class UserExpense {
  UserExpense({
    required this.title,
    required this.amount,
    required this.date,
    required this.time,
  });

  final String title;
  final double amount;
  final DateTime date;
  final TimeOfDay time;

  String get formattedDate {
    return dateFormatter.format(date);
  }

/*
  String get formattedTime {
    return dateFormatter.format(time!);
  }
  */
}
