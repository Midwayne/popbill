import 'package:flutter/material.dart';
import 'package:popbill/models/group.dart';
import 'package:popbill/models/group_expense.dart';
import 'package:popbill/widgets/split/add_group_expense.dart';
import 'package:popbill/services/auth_services.dart';
import 'package:popbill/widgets/split/group_expense_detail.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key, required this.group}) : super(key: key);

  final Group group;

  @override
  State<GroupPage> createState() {
    return _GroupPageState();
  }
}

class _GroupPageState extends State<GroupPage> {
  late List<GroupExpense> expenses = [];

  @override
  void initState() {
    super.initState();
    _fetchGroupExpenses();
  }

  Future<void> _fetchGroupExpenses() async {
    try {
      List<GroupExpense> fetchedExpenses =
          await AuthService().getGroupExpenses(widget.group.groupId);

      setState(() {
        expenses = fetchedExpenses;
      });
    } catch (error) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.groupName),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddGroupExpense(group: widget.group),
                ),
              );
            },
            icon: const Icon(Icons.payment),
          ),
          IconButton(
            onPressed: () {
              // Implement - settings: Ability to change nicknames, group name, add or remove a member, Exit group option
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: _buildExpenseList(),
    );
  }

  Widget _buildExpenseList() {
    if (expenses.isEmpty) {
      return const Center(child: Text('No transactions available.'));
    }

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupExpenseDetail(
                    expense: expenses[index], group: widget.group),
              ),
            );
          },
          child: ListTile(
            title: Text(expenses[index].title),
            subtitle: Row(
              children: [
                Text(
                  'Date: ${expenses[index].formattedDate}',
                ),
                const Spacer(),
                Text(
                  'Rs. ${expenses[index].totalAmount.toStringAsFixed(2)}',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
