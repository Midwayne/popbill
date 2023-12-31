import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:popbill/models/group.dart';
import 'package:popbill/models/group_item.dart';
import 'package:popbill/models/group_expense.dart';
import 'package:popbill/services/auth_services.dart';
import 'package:popbill/widgets/split/group_page.dart';

class AddGroupExpense extends StatefulWidget {
  const AddGroupExpense({Key? key, required this.group}) : super(key: key);

  final Group group;

  @override
  State<AddGroupExpense> createState() {
    return _AddGroupExpenseState();
  }
}

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
  List<GroupItem> items = [];

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

  void _submit() async {
    if (_form.currentState!.validate()) {
      GroupExpense expense = GroupExpense(
        groupId: widget.group.groupId,
        title: title,
        totalAmount: calculateTotalPrice(),
        paidBy: selectedUser,
        date: selectedDate,
        time: selectedTime,
        items: items,
      );

      try {
        AuthService().addGroupExpense(expense);

        Navigator.of(context).pop();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => GroupPage(group: widget.group),
          ),
        );

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense added successfully!'),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred while adding the expense.'),
          ),
        );
      }
    }
  }

  //Add logic for custom ratio/percentage selection later
  void _addItem() async {
    String itemName = '';
    double itemPrice = 0.0;
    int itemQuantity = 1;

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
                      decoration: const InputDecoration(
                        labelText: 'Item Name',
                        hintText: 'Beetroot',
                      ),
                      onChanged: (value) {
                        itemName = value;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Item Price',
                        hintText: '400.5',
                      ),
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
                    TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: '1',
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        hintText: '3',
                      ),
                      onChanged: (value) {
                        try {
                          int quantity = int.parse(value);
                          if (quantity >= 1) {
                            setState(() {
                              itemQuantity = quantity;
                            });
                          }
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

                        return CheckboxListTile(
                          title: Text(userNickname!),
                          value: selectedConsumers
                              .any((consumer) => consumer['id'] == userId),
                          onChanged: (value) {
                            setState(() {
                              if (value != null && value) {
                                selectedConsumers.add({
                                  'id': userId,
                                });
                              } else {
                                selectedConsumers.removeWhere(
                                    (consumer) => consumer['id'] == userId);
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
                    if (itemName.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter the item name'),
                        ),
                      );
                    } else if (itemPrice <= 0.0 ||
                        itemPrice.toString().trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid amount'),
                        ),
                      );
                    } else if (itemQuantity < 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Quantity must be above 1'),
                        ),
                      );
                    } else if (selectedConsumers.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select at least one user'),
                        ),
                      );
                    } else {
                      // Calculate the equal share for each consumer
                      double equalShare =
                          itemPrice * itemQuantity / selectedConsumers.length;

                      // Update the selectedConsumers with equal shares
                      selectedConsumers.forEach((consumer) {
                        consumer['share'] = equalShare;
                      });

                      setState(() {
                        items.add(GroupItem(
                          itemTitle: itemName,
                          itemPrice: itemPrice,
                          itemQuantity: itemQuantity,
                          consumerProportions: selectedConsumers,
                        ));

                        price = calculateTotalPrice();
                      });

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

  double calculateTotalPrice() {
    double total = 0.0;
    for (var item in items) {
      total += item.itemPrice * item.itemQuantity;
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    if (widget.group.users.isNotEmpty) {
      selectedUser = widget.group.users.first['id'] ?? '';
    }
  }

  Future<bool> _showExitConfirmationDialog() async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit Confirmation'),
          content: const Text('Are you sure you want to discard changes?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User doesn't want to exit
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User wants to exit
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    // If the user dismisses the dialog without making a choice, default to false
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmationDialog();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Add an expense')),
        body: SingleChildScrollView(
          child: Form(
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
                      Expanded(
                        child: (items.isNotEmpty)
                            ? Text('Total spent: ${calculateTotalPrice()}')
                            : const Text('Total spent: 0'),
                      ),
                      const SizedBox(width: 3),
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
                            items: widget.group.users
                                .map<DropdownMenuItem<String>>(
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
                        'Submit Bill',
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
                  if (items.isNotEmpty)
                    ListView(
                      key: UniqueKey(),
                      shrinkWrap: true,
                      children: List.generate(items.length, (index) {
                        final item = items[index];

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.itemTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Row(
                                  children: [
                                    Text(
                                        'Quantity: ${item.itemQuantity.toString()}'),
                                    Spacer(),
                                    Text(
                                        'Price: ${item.itemPrice.toStringAsFixed(2)}'),
                                  ],
                                ),
                                const SizedBox(height: 4.0),
                                const Text('Consumers:'),
                              ],
                            ),
                            subtitle: Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: item.consumerProportions
                                  .map(
                                    (consumer) => Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${widget.group.getUserNicknameById(consumer['id'])}:',
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          '${consumer['share'].toStringAsFixed(2)}',
                                        ),
                                        const SizedBox(width: 8.0),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  items.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  Center(
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(6),
                      ),
                      onPressed: _addItem,
                      child: const Text(
                        'Add item to bill',
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
        ),
      ),
    );
  }
}
