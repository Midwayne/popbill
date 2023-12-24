import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:popbill/models/group_item.dart';

final dateFormatter = DateFormat.yMd(); // 7/10/1996
//final timeFormatter = DateFormat.jm(); // 5:08 PM

class GroupExpense {
  GroupExpense({
    required this.groupId,
    required this.title,
    required this.totalAmount,
    required this.paidBy, //User who paid the bill
    required this.date,
    required this.time,
    required this.items,
  });

  final String groupId;
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
