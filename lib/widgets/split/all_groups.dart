import 'package:flutter/material.dart';
import 'package:popbill/models/group.dart';
import 'package:popbill/services/auth_services.dart';
import 'package:popbill/widgets/split/group_page.dart';

class AllGroups extends StatefulWidget {
  const AllGroups({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AllGroupsState();
  }
}

class _AllGroupsState extends State<AllGroups> {
  List<Group> userGroups = [];

  Future<List<Group>> _getGroups() async {
    try {
      userGroups = await AuthService().getGroups();
      return userGroups;
    } catch (e) {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _getGroups();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getGroups(),
      builder: (ctx1, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No groups found.'),
          );
        } else {
          return SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: userGroups.length,
              itemBuilder: (BuildContext ctx2, int index) {
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return GroupPage(group: userGroups[index]);
                      },
                    ));
                  },
                  title: Text(userGroups[index].groupName),
                  subtitle: Row(
                    children: userGroups[index]
                        .users
                        .map(
                          (user) => Text(
                            '${user['nickname']}',
                          ),
                        )
                        .toList(),
                  ),
                  // You can add more details or actions here
                );
              },
            ),
          );
        }
      },
    );
  }
}
