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
  Map<String, double> calculateTotalShares() {
    Map<String, double> totalShares = {};

    for (GroupItem item in widget.expense.items) {
      for (Map<String, dynamic> consumer in item.consumerProportions) {
        String? userId = consumer['id'];
        double? share = consumer['share'];

        if (userId != null && share != null) {
          String nickname = widget.group.getUserNicknameById(userId);

          if (totalShares.containsKey(nickname)) {
            totalShares[nickname] = totalShares[nickname]! + share;
          } else {
            totalShares[nickname] = share;
          }
        }
      }
    }

    return totalShares;
  }

  @override
  Widget build(BuildContext context) {
    GroupExpense expense = widget.expense;
    Map<String, double> totalShares = calculateTotalShares();

    return Scaffold(
      appBar: AppBar(
        title: Text(expense.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Date: ${expense.formattedDate}'),
                const Spacer(),
                Text('Time: ${widget.expense.time.format(context)}'),
              ],
            ),
            SizedBox(height: 16.0),

            Text('Total Amount: Rs. ${expense.totalAmount.toStringAsFixed(2)}'),

            Text(
                'Paid by: ${widget.group.getUserNicknameById(expense.paidBy)}'),

            /*Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: totalShares.entries.map((entry) {
                return Text('${entry.key}: ${entry.value.toStringAsFixed(2)}');
              }).toList(),
            ),*/
            const Divider(
              color: Colors.black,
              thickness: 1.0,
              height: 20.0,
            ),

            Center(
              child: Column(
                children: [
                  const Text('Total Shares'),
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('User')),
                      DataColumn(label: Text('Amount')),
                    ],
                    rows: totalShares.entries.map((entry) {
                      return DataRow(cells: [
                        DataCell(Text(entry.key)),
                        DataCell(Text(entry.value.toStringAsFixed(2))),
                      ]);
                    }).toList(),
                  ),
                ],
              ),
            ),

            //const SizedBox(height: 16.0),
            const Divider(
              color: Colors.black,
              thickness: 1.0,
              height: 20.0,
            ),

            const Center(child: Text('Items and Shares')),
            const SizedBox(height: 8.0),
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
                              const Spacer(),
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
