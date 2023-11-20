import 'package:firebase_auth/firebase_auth.dart';
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
  //ADD CURRENT USERID TO LIST BEFORE SUBMITTING THE GROUP
  List<String> users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUserId = widget.currentUserId;
    users.add(currentUserId);
  }

  void verifyIfUserExists({required String userId}) async {
    bool userStatus = await AuthService().verifyIfUserExists(userId: userId);
    if (userStatus) {
      setState(() {
        users.add(userId);
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
              SizedBox(height: deviceSize * 10),
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
                      verifyIfUserExists(userId: userIdController.text);
                    },
                  ),
                ],
              ),
              SizedBox(height: deviceSize * 10),
            ],
          ),
        ),
      ),
    );
  }
}
