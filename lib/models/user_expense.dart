import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final dateFormatter = DateFormat.yMd(); // 7/10/1996
//final timeFormatter = DateFormat.jm(); // 5:08 PM

class UserExpense {
  UserExpense({
    String? id,
    required this.title,
    required this.amount,
    required this.date,
    required this.time,
  }) : id = id ?? const Uuid().v4();

  final String id;
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
