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
                          onDismissed: (direction) {
                            AuthService().removeUserExpense(context, expense);
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

/*
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
                    //totalPeriodExpense += expense.amount;
                    //print(totalPeriodExpense);
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
    );*/
  }
}
