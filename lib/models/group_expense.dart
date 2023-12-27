import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:popbill/models/group_item.dart';
import 'package:uuid/uuid.dart';

final dateFormatter = DateFormat.yMd(); // 7/10/1996
//final timeFormatter = DateFormat.jm(); // 5:08 PM

class GroupExpense {
  GroupExpense({
    required this.groupId,
    String? expenseId,
    required this.title,
    required this.totalAmount,
    required this.paidBy, //User who paid the bill
    required this.date,
    required this.time,
    required this.items,
  }) : expenseId = expenseId ?? const Uuid().v4();

  final String groupId;
  final String expenseId;
  final String title;
  final double totalAmount;
  final String paidBy;
  final DateTime date;
  final TimeOfDay time;
  final List<GroupItem> items;

  String get formattedDate {
    return dateFormatter.format(date);
  }

/*
  String get formattedTime {
    return dateFormatter.format(time!);
  }
  */
}
