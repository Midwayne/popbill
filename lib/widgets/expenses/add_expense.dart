import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popbill/models/user_expense.dart';
import 'package:intl/intl.dart';
import 'package:popbill/services/auth_services.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({Key? key, required this.reloadCallback}) : super(key: key);

  final VoidCallback reloadCallback;

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final _form = GlobalKey<FormState>();

  final selectedDateFormatter = DateFormat('dd-MM-y'); // 7/10/1996
  final selectedTimeFormatter = DateFormat.jm(); // 5:08 PM

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String title = '';
  double price = 0.0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.from(
            colorScheme: Theme.of(context).colorScheme,
          ), // Adjust as needed
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).devicePixelRatio;
    void submit() async {
      FocusManager.instance.primaryFocus?.unfocus();
      final isValid = _form.currentState!.validate();

      if (!isValid) {
        return;
      }

      _form.currentState!.save();
      _form.currentState!.reset();

      UserExpense expense = UserExpense(
        title: title,
        amount: price,
        date: selectedDate,
        time: selectedTime,
      );

      final Future<bool> returnCodeFuture =
          AuthService().addUserExpense(context, expense);

      bool returnCode = await returnCodeFuture;

      widget.reloadCallback();

      if (returnCode == true) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense added.'),
          ),
        );
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'An unexpected error occurred while adding expense.\nPlease try again'),
          ),
        );
      }
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: deviceSize * 10,
        //vertical: deviceSize * 20,
      ),
      child: Form(
        key: _form,
        child: Column(
          children: [
            Text(
              'Add an expense',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
              ),
            ),
            SizedBox(width: deviceSize * 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    maxLength: 25,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        labelText: 'Title*', hintText: 'Food'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a title';
                      }
                      title = value;
                      return null;
                    },
                  ),
                ),
                SizedBox(width: deviceSize * 10),
                SizedBox(
                  width: deviceSize * 35,
                  child: TextFormField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                        labelText: 'Amount*', hintText: '19.99'),
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .singleLineFormatter, // No line break
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}$')), // Only double values
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the price';
                      }
                      try {
                        price = double.parse(value);
                        return null; // Return null if parsing is successful
                      } catch (e) {
                        return 'Not a number';
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: deviceSize * 5),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Date: ${selectedDateFormatter.format(selectedDate)}',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            SizedBox(height: deviceSize * 2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Time: ${selectedTime.format(context)}',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () => _selectTime(context),
                ),
              ],
            ),
            SizedBox(height: deviceSize * 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                    elevation: MaterialStatePropertyAll(6),
                  ),
                  onPressed: submit,
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
