import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:popbill/models/group.dart';

class AddGroupExpense extends StatefulWidget {
  const AddGroupExpense({Key? key, required this.group}) : super(key: key);

  final Group group;

  @override
  State<AddGroupExpense> createState() {
    return _AddGroupExpenseState();
  }
}

//Transaction
//Enter name, date, who paid total, add items and proportions of each user. Add expense

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
  String selectedUser = '';

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
          ),
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

  void _submit() {}

  /*
  void _addItem() async {
    String itemName = '';
    double itemPrice = 0.0;
    List<String> selectedConsumers = [];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Item Name'),
                  onChanged: (value) {
                    itemName = value;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Item Price'),
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .singleLineFormatter, // No line break
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}$')), // Only double values
                  ],
                  onChanged: (value) {
                    try {
                      itemPrice = double.parse(value);
                    } catch (e) {
                      // Handle invalid input
                    }
                  },
                ),
                const SizedBox(height: 10),
                const Text('Select consumers:'),
                Column(
                  children: widget.group.users.map((user) {
                    final userId = user['id'];
                    final userNickname = user['nickname'];

                    //Unable to select the consumers
                    return CheckboxListTile(
                      title: Text(userNickname!),
                      value: selectedConsumers.contains(userId),
                      onChanged: (value) {
                        setState(() {
                          if (value != null && value) {
                            selectedConsumers.add(userId!);
                          } else {
                            selectedConsumers.remove(userId);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Handle the data, e.g., add it to your state
                // You can store the item in a list or perform other actions
                print('Item Name: $itemName');
                print('Item Price: $itemPrice');
                print('Selected Consumers: $selectedConsumers');

                // Perform any additional logic or state updates here

                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }*/

  //The logic given below is wrong. Fix it
  // Also put the percentage textbox beside the checklist
  void _addItem() async {
    String itemName = '';
    double itemPrice = 0.0;
    List<Map<String, dynamic>> selectedConsumers = [];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: const Text('Add Item'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Item Name'),
                      onChanged: (value) {
                        itemName = value;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration:
                          const InputDecoration(labelText: 'Item Price'),
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter,
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}$')),
                      ],
                      onChanged: (value) {
                        try {
                          itemPrice = double.parse(value);
                        } catch (e) {
                          // Handle invalid input
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text('Select consumers:'),
                    Column(
                      children: widget.group.users.map((user) {
                        final userId = user['id'];
                        final userNickname = user['nickname'];

                        double defaultPercentage =
                            100.0 / widget.group.users.length;
                        double selectedPercentage = defaultPercentage;

                        return CheckboxListTile(
                          title: Text(userNickname!),
                          value: selectedConsumers
                              .any((consumer) => consumer['id'] == userId),
                          onChanged: (value) {
                            setState(() {
                              if (value != null && value) {
                                selectedConsumers.add({
                                  'id': userId,
                                  'percentage': defaultPercentage,
                                });
                              } else {
                                // Remove user from the list or set percentage to 0%
                                selectedConsumers.removeWhere(
                                    (consumer) => consumer['id'] == userId);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    const Text('Enter percentage:'),
                    Column(
                      children: selectedConsumers.map((consumer) {
                        final userId = consumer['id'];
                        final userNickname = widget.group.users.firstWhere(
                            (user) => user['id'] == userId)['nickname'];

                        return TextFormField(
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: InputDecoration(
                            labelText: 'Percentage for $userNickname',
                          ),
                          initialValue: consumer['percentage'].toString(),
                          onChanged: (value) {
                            try {
                              double enteredPercentage = double.parse(value);
                              if (enteredPercentage >= 0 &&
                                  enteredPercentage <= 100) {
                                setState(() {
                                  consumer['percentage'] = enteredPercentage;
                                });
                              }
                            } catch (e) {
                              // Handle invalid input
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    const Text('Unaccounted Percentage:'),
                    Text(
                      '${(100 - selectedConsumers.fold(0, (sum, consumer) => sum + consumer['percentage'])).toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    double totalPercentage = selectedConsumers.fold(
                        0, (sum, consumer) => sum + consumer['percentage']);
                    if (totalPercentage < 100) {
                      // Validation failed
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Total percentage must be 100%'),
                        ),
                      );
                    } else {
                      // Handle the data, e.g., add it to your state
                      // You can store the item in a list or perform other actions
                      print('Item Name: $itemName');
                      print('Item Price: $itemPrice');
                      print('Selected Consumers: $selectedConsumers');

                      // Perform any additional logic or state updates here

                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.group.users.isNotEmpty) {
      selectedUser = widget.group.users.first['id'] ?? '';
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
              TextFormField(
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
              const SizedBox(height: 5),
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
              const SizedBox(height: 2),
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
              const SizedBox(height: 5),
              Row(
                children: [
                  //Here instead of price, add a text widget which automatically calculates the total
                  //as the items are added. do not display this textbox if no items are added
                  //below it, we have a drop down box to select who paid for the items
                  Expanded(
                    child: (price != 0.0)
                        ? Text('Total spent: $price')
                        : const Text('Total spent: 0'),
                  ),

                  const SizedBox(width: 3),
/*
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButton<String>(
                      value: selectedUser,
                      hint: const Text('Select a member'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedUser = newValue!;
                        });
                      },
                      items: widget.group.users.map<DropdownMenuItem<String>>(
                          (Map<String, String> user) {
                        return DropdownMenuItem<String>(
                          value: user['id'],
                          child: Text(user['nickname']!),
                        );
                      }).toList(),
                    ),
                  ),*/
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Who paid the bill?',
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        value: selectedUser,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedUser = newValue!;
                          });
                        },
                        items: widget.group.users.map<DropdownMenuItem<String>>(
                          (Map<String, String> user) {
                            return DropdownMenuItem<String>(
                              value: user['id'],
                              child: Text(user['nickname']!),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),

                  /*Expanded(
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
                  ),*/
                ],
              ),
              const SizedBox(height: 5),
              Center(
                child: ElevatedButton(
                  style: const ButtonStyle(
                    elevation: MaterialStatePropertyAll(6),
                  ),
                  onPressed: _submit,
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Divider(
                height: 20,
                thickness: 5,
                //indent: 20,
                //endIndent: 0,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 5),
              Center(
                child: ElevatedButton(
                  style: const ButtonStyle(
                    elevation: MaterialStatePropertyAll(6),
                  ),
                  onPressed: _addItem,
                  child: const Text(
                    'Add item',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
