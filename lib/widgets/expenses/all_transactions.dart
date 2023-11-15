import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    expenses = getData();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).devicePixelRatio;
    void selectedTime(TimeOfDay expenseTime) {}
    TimeOfDay expenseTime;

    return Scaffold(
      body: Center(
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
              return ListView.builder(
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
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: EdgeInsets.all(deviceSize * 5),
                        child: Column(children: [
                          Row(
                            children: [
                              Text(
                                expense.title,
                                style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: deviceSize * 15,
                              ),
                              Text('Rs. ${expense.amount.toStringAsFixed(2)}'),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Date: ${expense.date.toLocal()}'),
                              Text('Time: ${expense.time}'),
                            ],
                          )
                        ]),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
