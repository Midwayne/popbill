import 'package:flutter/material.dart';
import 'package:popbill/models/group.dart';
import 'package:popbill/widgets/split/add_group_expense.dart';

//Implement - settings: Ability to change nicknames, group name, add or remove a member, Exit group option
class GroupPage extends StatefulWidget {
  const GroupPage({Key? key, required this.group}) : super(key: key);

  final Group group;

  @override
  State<GroupPage> createState() {
    return _GroupPageState();
  }
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.groupName),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet<void>(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return DraggableScrollableSheet(
                      initialChildSize: 1,
                      builder: ((ctx, scrollController) {
                        return const Center(
                          child: AddGroupExpense(),
                        );
                      }),
                    );
                  });
            },
            icon: const Icon(Icons.payment),
          )
        ],
      ),
      body: Column(), //Widget to show All transactions in a group,
    );
  }
}
