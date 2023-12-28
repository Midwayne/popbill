import 'package:flutter/material.dart';
import 'package:popbill/models/group_expense.dart';

class GroupExpenseDetail extends StatefulWidget {
  GroupExpenseDetail({Key? key, required this.expense}) : super(key: key);

  GroupExpense expense;

  @override
  State<GroupExpenseDetail> createState() {
    return _GroupExpenseDetailState();
  }
}

class _GroupExpenseDetailState extends State<GroupExpenseDetail> {
  @override
  Widget build(BuildContext context) {
    GroupExpense expense = widget.expense;

    return Scaffold(
      appBar: AppBar(
        title: Text(expense.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text('Date: ${expense.formattedDate}'),
            SizedBox(height: 8.0),
            Text('Total Amount: Rs. ${expense.totalAmount.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
