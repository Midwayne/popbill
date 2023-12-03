import 'package:flutter/material.dart';
import 'package:popbill/models/group.dart';
import 'package:popbill/services/auth_services.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

//To implement: The page doesn't reload automatically even after adding

class AddGroup extends StatefulWidget {
  const AddGroup({
    super.key,
    required this.currentUserId,
    required this.reloadPage,
  });
  final String currentUserId;
  final Function() reloadPage;
  @override
  State<AddGroup> createState() {
    return _AddGroupState();
  }
}

class _AddGroupState extends State<AddGroup> {
  final _form = GlobalKey<FormState>();

  String groupName = '';

  TextEditingController userIdController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();

  String currentUserId = '';

  List<String> userIDs = [];
  List<String> nicknames = [];
  List<Map<String, String>> users = [];

  @override
  void initState() {
    super.initState();
    currentUserId = widget.currentUserId;
  }

  @override
  void dispose() {
    super.dispose();
    userIdController.dispose();
    nicknameController.dispose();
  }

  void verifyIfUserExistsAndAdd(
      {required String userId, required String nickname}) async {
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter an ID'),
        ),
      );
      return;
    }
    if (nickname.isEmpty || nickname.trim().isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a nickname'),
        ),
      );
      return;
    }
    if (userIDs.contains(userId)) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User already added!'),
        ),
      );
      return;
    }
    if (nicknames.contains(nickname)) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nickname already exists!'),
        ),
      );
      return;
    }
    bool userStatus = await AuthService().verifyIfUserExists(userId: userId);

    if (userStatus) {
      setState(() {
        userIDs.add(userId);
        nicknames.add(nickname);
        users.add(
          {
            'id': userId,
            'nickname': nickname,
          },
        );

        print(users);
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

  //Remove isn't built yet
  void removeUserFromGroup(String userId, String nickname) {
    setState(() {
      userIDs.remove(userId);
      nicknames.remove(nickname);
      users.removeWhere((map) => map['id'] == userId);
    });
  }

  void createGroup() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    if (users.length < 2) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add at least two members'),
        ),
      );

      return;
    }

    _form.currentState!.save();

    //Auth service invoke
    Group finalUsers = Group(groupName: groupName, users: users);
    print(
        '${finalUsers.groupName}, ${finalUsers.users}, ${finalUsers.groupId}');
    AuthService().createGroup(context, finalUsers);

    widget.reloadPage;

    //Add this group in two places: in the groups collections such as users
    //And in the user account for easy reload
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
          vertical: deviceSize * 10,
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
              (users.isNotEmpty)
                  ? Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            const Text('Add a member'),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: userIdController,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        labelText: 'User ID'),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.qr_code_2),
                                  onPressed: () async {
                                    var res = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SimpleBarcodeScannerPage(),
                                        ));
                                    setState(() {
                                      if (res == '-1') {
                                        userIdController.text == '';
                                        return;
                                      }
                                      if (res is String) {
                                        userIdController.text = res;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    maxLength: 10,
                                    controller: nicknameController,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      labelText: 'Nickname',
                                      hintText: 'John',
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    verifyIfUserExistsAndAdd(
                                      userId: userIdController.text,
                                      nickname: nicknameController.text,
                                    );
                                    userIdController.text = '';
                                    nicknameController.text = '';
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            maxLength: 10,
                            controller: nicknameController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Your nickname',
                              hintText: 'John',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            verifyIfUserExistsAndAdd(
                              userId: currentUserId,
                              nickname: nicknameController.text,
                            );
                            userIdController.text = '';
                            nicknameController.text = '';
                          },
                        ),
                      ],
                    ),
              SizedBox(height: deviceSize * 10),
              Text('Users added: ${users.length}'),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: users.map((user) {
                    final userId = user['userId'];
                    final nickname = user['nickname'];

                    return GestureDetector(
                      onLongPress: () {
                        if (userId != 'currentUserId') {
                          //removeUserFromGroup
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          '$nickname',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: deviceSize * 10),
              ElevatedButton(
                style: const ButtonStyle(
                  elevation: MaterialStatePropertyAll(6),
                ),
                onPressed: createGroup,
                child: const Text(
                  'Create group',
                  style: TextStyle(
                    fontSize: 16,
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
