import 'package:flutter/material.dart';
import 'package:popbill/services/auth_services.dart';

class AddGroup extends StatefulWidget {
  AddGroup({super.key, required this.currentUserId});
  String currentUserId;
  @override
  State<AddGroup> createState() {
    return _AddGroupState();
  }
}

class _AddGroupState extends State<AddGroup> {
  final _form = GlobalKey<FormState>();
  String groupName = '';
  TextEditingController userIdController = TextEditingController();
  String currentUserId = '';
  List<String> users = [];
  List<Map<String, String>> usernames = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUserId = widget.currentUserId;
    users.add(currentUserId);
    usernames.add(
      {
        'id': currentUserId,
        'nickname': '',
      },
    );
  }

  void verifyIfUserExistsAndAdd({required String userId}) async {
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter an ID'),
        ),
      );
      return;
    }
    if (users.contains(userId)) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User already added!'),
        ),
      );
      return;
    }
    bool userStatus = await AuthService().verifyIfUserExists(userId: userId);

    if (userStatus) {
      setState(() {
        users.add(userId);
        usernames.add(
          {
            'id': userId,
            'nickname': '',
          },
        );
      });
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error finding user. Try again.'),
        ),
      );
    }
  }

  void removeUserFromGroup(String userId) {
    setState(() {
      users.remove(userId);
      usernames.removeWhere((map) => map['id'] == userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a group'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: deviceSize * 10,
          vertical: deviceSize * 10, // Adjust the vertical padding as needed
        ),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                maxLength: 25,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Group name',
                  hintText: 'Gang of five',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a group name';
                  }
                  groupName = value;
                  return null;
                },
              ),
              SizedBox(height: deviceSize * 4),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: userIdController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(labelText: 'User ID'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      // Implement the logic to add user ID to the list
                      print(userIdController.text);
                      verifyIfUserExistsAndAdd(userId: userIdController.text);
                    },
                  ),
                ],
              ),
              SizedBox(height: deviceSize * 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      const Text('Users added: '),
                      for (int i = 0; i < users.length; i++)
                        if (users[i] == currentUserId)
                          ListTile(
                            title: TextField(
                              decoration:
                                  InputDecoration(hintText: 'Enter a nickname'),
                              maxLength: 10,
                              controller: TextEditingController(),
                            ),
                            subtitle: Text('You'),
                            trailing: ElevatedButton(
                              onPressed: () {
                                //Add nickname to map
                              },
                              child: const Text('Confirm'),
                            ),
                          )
                        else
                          ListTile(
                            title: TextField(
                              decoration:
                                  InputDecoration(hintText: 'Enter a nickname'),
                              maxLength: 10,
                              controller: TextEditingController(),
                            ),
                            subtitle: Text(users[i]),
                            trailing: ElevatedButton(
                              onPressed: () {
                                //Add nickname to map
                              },
                              child: const Text('Confirm'),
                            ),
                          )
                    ],
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
