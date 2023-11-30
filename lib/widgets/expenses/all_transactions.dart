import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:popbill/models/user_expense.dart';
import 'package:popbill/services/auth_services.dart';

// Currently this shows only the current month's expenses.
// Add a filter in the appbar to choose any month's expenses.
//Use riverpod to store the total amount spent in a month

class AllTransactions extends StatefulWidget {
  const AllTransactions({Key? key, required int year, required int month})
      : filterYear = year,
        filterMonth = month,
        super(key: key);

  final int filterYear;
  final int filterMonth;

  @override
  State<AllTransactions> createState() {
    return _AllTransactionsState();
  }
}

class _AllTransactionsState extends State<AllTransactions> {
  late Future<List<UserExpense>> expenses;
  double totalPeriodExpense = 0;

  Future<List<UserExpense>> _getData() async {
    try {
      List<UserExpense> expenses = await AuthService().getExpenses(
        filterYear: widget.filterYear,
        filterMonth: widget.filterMonth,
      );

      totalPeriodExpense =
          expenses.fold(0, (double previousValue, UserExpense expense) {
        return previousValue + expense.amount;
      });

      return expenses;
    } catch (e) {
      return [];
    }
  }

  Future<void> _pullRefresh() async {
    List<UserExpense> freshExpenses = await _getData();

    setState(() {
      expenses = Future.value(freshExpenses);
    });
  }

  @override
  void initState() {
    super.initState();
    expenses = _getData();
  }

  //The bottom query checks for the type instead of the value
  //Fix it
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Check if the page was popped and reload if needed
    final didPop = ModalRoute.of(context)?.didPop;
    if (didPop != true) {
      _pullRefresh();
    }
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

    return Column(
      children: [
        Card(
          elevation: 5,
          margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Expenses',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Text(
                  'Rs. ${totalPeriodExpense.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        FutureBuilder<List<UserExpense>>(
          future: _getData(),
          builder: (ctx1, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No expenses found.');
            } else {
              return Expanded(
                child: Scaffold(
                  body: RefreshIndicator(
                    onRefresh: _pullRefresh,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (ctx2, index) {
                        UserExpense expense = snapshot.data![index];
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
                          onDismissed: (direction) async {
                            Future<int> status = AuthService()
                                .removeUserExpense(context, expense);

                            int statusValue = await status;

                            if (statusValue == 1) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Expense deleted.'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      AuthService()
                                          .addUserExpense(context, expense);
                                      _pullRefresh();
                                    },
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'An unexpected error occurred while deleting expense.\nPlease try again'),
                                ),
                              );
                            }
                            _pullRefresh();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(deviceSize * 2),
                            child: ListTile(
                              subtitle: Column(children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
