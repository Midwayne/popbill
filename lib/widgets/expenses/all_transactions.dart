import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:popbill/models/user_expense.dart';
import 'package:popbill/services/auth_services.dart';

class AllTransactions extends StatefulWidget {
  const AllTransactions({super.key});

  @override
  State<AllTransactions> createState() {
    return _AllTransactionsState();
  }
}

class _AllTransactionsState extends State<AllTransactions> {
  late Future<List<UserExpense>> expenses;

  Future<List<UserExpense>> getData() async {
    return await AuthService().getExpenses();
  }

  Future<void> _pullRefresh() async {
    List<UserExpense> freshExpenses = await AuthService().getExpenses();
    setState(() {
      expenses = Future.value(freshExpenses);
    });
  }

  @override
  void initState() {
    super.initState();
    expenses = getData();
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

    return Center(
      child: FutureBuilder<List<UserExpense>>(
        future: expenses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No expenses found.');
          } else {
            return RefreshIndicator(
              onRefresh: _pullRefresh,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  UserExpense expense = snapshot.data![index];
                  /*return ListTile(
                      title: Text(expense.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rs. ${expense.amount.toStringAsFixed(2)}'),
                          Text(
                              'Date: ${expense.date.toLocal()}'), // Convert to local time
                          Text('Time: ${expense.time}'),
                        ],
                      ),
                    );*/
                  return Padding(
                    padding: EdgeInsets.all(deviceSize * 2),
                    child: ListTile(
                      //elevation: 3,
                      subtitle: Column(children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
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
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
