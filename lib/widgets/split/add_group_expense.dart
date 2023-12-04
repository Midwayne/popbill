import 'package:flutter/material.dart';

class AddGroupExpense extends StatefulWidget {
  const AddGroupExpense({super.key});
  @override
  State<AddGroupExpense> createState() {
    return _AddGroupExpenseState();
  }
}

//Transaction
//Enter name, date, who paid total, add items and proportions of each user. Add expense
class _AddGroupExpenseState extends State<AddGroupExpense> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [],
      ),
    );
  }
}
