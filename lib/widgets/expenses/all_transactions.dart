import 'package:flutter/widgets.dart';

class AllTransactions extends StatefulWidget {
  const AllTransactions({super.key});

  @override
  State<AllTransactions> createState() {
    return _AllTransactionsState();
  }
}

class _AllTransactionsState extends State<AllTransactions> {
  @override
  Widget build(BuildContext context) {
    return Text('Spent all time');
  }
}
