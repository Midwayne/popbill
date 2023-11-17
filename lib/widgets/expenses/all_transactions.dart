import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:popbill/models/user_expense.dart';
import 'package:popbill/services/auth_services.dart';

// Currently this shows only the current month's expenses.
// Add a filter in the appbar to choose any month's expenses.
//Use riverpod to store the total amount spent in a month

class AllTransactions extends StatefulWidget {
  const AllTransactions({super.key});

  @override
  State<AllTransactions> createState() {
    return _AllTransactionsState();
  }
}

class _AllTransactionsState extends State<AllTransactions> {
  late Future<List<UserExpense>> expenses;

  Future<List<UserExpense>> _getData() async {
    return await AuthService().getExpenses(
      filterYear: DateTime.now().year,
      filterMonth: DateTime.now().month,
    );
  }

  Future<void> _pullRefresh() async {
    List<UserExpense> freshExpenses = await AuthService().getExpenses(
      filterYear: DateTime.now().year,
      filterMonth: DateTime.now().month,
    );
    setState(() {
      expenses = Future.value(freshExpenses);
    });
  }

  @override
  void initState() {
    super.initState();
    expenses = _getData();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).devicePixelRatio;

    String selectedTime(TimeOfDay expenseTime) {
      return expenseTime.format(context).toString();
    }

    String selectedDate(DateTime expenseDate) {
      final selectedDateFormatter = DateFormat('dd-MM-y');
      return selectedDateFormatter.format(expenseDate).toString();
    }

    double monthlyExpenses = 0;

    return Center(
      child: FutureBuilder<List<UserExpense>>(
        future: expenses,
        builder: (ctx1, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No expenses found.');
          } else {
            return Scaffold(
              body: RefreshIndicator(
                onRefresh: _pullRefresh,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (ctx2, index) {
                    UserExpense expense = snapshot.data![index];
                    monthlyExpenses += expense.amount;
                    print(monthlyExpenses);
                    return Dismissible(
                      key: Key(expense.title),
                      background: Container(
                        color: Colors.red,
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onDismissed: (direction) {
                        AuthService().removeUserExpense(context, expense);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(deviceSize * 2),
                        child: ListTile(
                          //elevation: 3,
                          subtitle: Column(children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  expense.title,
                                  style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .fontSize,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  'Rs. ${expense.amount.toStringAsFixed(2)}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Date: ${selectedDate(expense.date)}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Time: ${selectedTime(expense.time)}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            )
                          ]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
