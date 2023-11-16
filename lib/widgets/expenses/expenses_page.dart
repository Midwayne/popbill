import 'package:flutter/material.dart';
import 'package:popbill/widgets/expenses/add_expense.dart';
import 'package:popbill/widgets/expenses/all_transactions.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesPageState();
  }
}

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  Widget build(BuildContext context) {
    /*
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Add'),
              Tab(text: 'This month'),
              Tab(text: 'All transactions'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AddExpense(),
            ThisMonth(),
            AllTransactions(),
          ],
        ),
      ),
    );*/
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return DraggableScrollableSheet(
                  initialChildSize: 1,
                  builder: ((ctx, scrollController) {
                    return const Center(
                      child: AddExpense(),
                    );
                  }),
                );
              });
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      body: AllTransactions(),
    );
  }
}
