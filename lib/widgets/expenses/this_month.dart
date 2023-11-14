import 'package:flutter/widgets.dart';

class ThisMonth extends StatefulWidget {
  const ThisMonth({super.key});

  @override
  State<ThisMonth> createState() {
    return _ThisMonthState();
  }
}

class _ThisMonthState extends State<ThisMonth> {
  @override
  Widget build(BuildContext context) {
    return Text('Spent this month');
  }
}
