import 'package:flutter/material.dart';
import 'package:popbill/models/group_expense.dart';
import 'package:popbill/models/group_item.dart';
import 'package:popbill/models/group.dart';

class GroupExpenseDetail extends StatefulWidget {
  GroupExpenseDetail({Key? key, required this.expense, required this.group})
      : super(key: key);

  final GroupExpense expense;
  final Group group;

  @override
  State<GroupExpenseDetail> createState() {
    return _GroupExpenseDetailState();
  }
}

class _GroupExpenseDetailState extends State<GroupExpenseDetail> {
  @override
  Widget build(BuildContext context) {
    GroupExpense expense = widget.expense;

    return Scaffold(
      appBar: AppBar(
        title: Text(expense.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text('Date: ${expense.formattedDate}'),
            SizedBox(height: 8.0),
            // Add time here
            Text('Total Amount: Rs. ${expense.totalAmount.toStringAsFixed(2)}'),
            SizedBox(height: 16.0),
            // Add the total amount of each user here
            Text('Items and Shares:'),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: expense.items.length,
                itemBuilder: (context, index) {
                  GroupItem item = expense.items[index];

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
                              Text('Quantity: ${item.itemQuantity.toString()}'),
                              Spacer(),
                              Text(
                                  'Price: ${item.itemPrice.toStringAsFixed(2)}'),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          const Text('Consumers:'),
                          Wrap(
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
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
