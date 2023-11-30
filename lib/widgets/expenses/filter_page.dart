import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:popbill/widgets/expenses/all_transactions.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  Future<void> showFilterDialog() async {
    final pickedDate = await showMonthPicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1970),
      lastDate: DateTime(2050),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View past transactions'),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: showFilterDialog,
                  icon: Icon(Icons.filter_list),
                ),
                Text(
                  'Filter: ${DateFormat('MMMM, y').format(selectedDate)}',
                ),
              ],
            ),
            Expanded(
              child: AllTransactions(
                year: selectedDate.year,
                month: selectedDate.month,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
