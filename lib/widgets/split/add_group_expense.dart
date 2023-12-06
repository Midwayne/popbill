import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddGroupExpense extends StatefulWidget {
  const AddGroupExpense({super.key});
  @override
  State<AddGroupExpense> createState() {
    return _AddGroupExpenseState();
  }
}

//Transaction
//Enter name, date, who paid total, add items and proportions of each user. Add expense

//Problem - gap between title and amount
//Add a dropdownbutton? for adding choice of user
//custom user in case there is a user who does not belong to the group but wants to be added
class _AddGroupExpenseState extends State<AddGroupExpense> {
  final selectedDateFormatter = DateFormat('dd-MM-y'); // 7/10/1996
  final selectedTimeFormatter = DateFormat.jm(); // 5:08 PM

  final _form = GlobalKey<FormState>();

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
    return Scaffold(
      appBar: AppBar(title: const Text('Add an expense')),
      body: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              TextFormField(
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
              SizedBox(height: 5),
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
              SizedBox(height: 2),
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
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
