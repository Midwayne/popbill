import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popbill/models/user_expense.dart';
import 'package:intl/intl.dart';
import 'package:popbill/services/auth_services.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

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
      lastDate: DateTime(2101),
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
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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

      AuthService().addUserExpense(context, expense);
    }

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(MediaQuery.of(context).devicePixelRatio * 10),
        child: Form(
          key: _form,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
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
                  SizedBox(width: MediaQuery.of(context).devicePixelRatio * 10),
                  SizedBox(
                    width: MediaQuery.of(context).devicePixelRatio * 35,
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
                          print(price);
                          return null; // Return null if parsing is successful
                        } catch (e) {
                          return 'Not a number';
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).devicePixelRatio * 5),
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
              SizedBox(height: MediaQuery.of(context).devicePixelRatio * 2),
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
              SizedBox(height: MediaQuery.of(context).devicePixelRatio * 5),
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
      ),
    );
  }
}
