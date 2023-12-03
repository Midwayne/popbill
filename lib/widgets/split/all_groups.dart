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
  List<Group> filteredGroups = [];
  TextEditingController searchController = TextEditingController();

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

  void _filterGroups(String query) {
    setState(() {
      filteredGroups = userGroups
          .where((group) =>
              group.groupName.toLowerCase().contains(query.toLowerCase()) ||
              group.users.any((user) => user['nickname']!
                  .toLowerCase()
                  .contains(query.toLowerCase())))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey[200],
            ),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search for groups',
                icon: Icon(Icons.search),
                border: InputBorder.none,
              ),
              onChanged: _filterGroups,
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: _getGroups(),
            builder: (ctx1, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                //return const CircularProgressIndicator();
                return const Text('Fetching your groups...');
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No groups found.'),
                );
              } else {
                List<Group> groupsToDisplay =
                    filteredGroups.isNotEmpty ? filteredGroups : userGroups;

                return ListView.builder(
                  itemCount: groupsToDisplay.length,
                  itemBuilder: (BuildContext ctx2, int index) {
                    return Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey),
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return GroupPage(group: groupsToDisplay[index]);
                            },
                          ));
                        },
                        title: Text(
                          groupsToDisplay[index].groupName,
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .fontSize,
                          ),
                        ),
                        subtitle: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: groupsToDisplay[index]
                                .users
                                .map(
                                  (user) => Container(
                                    margin: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      '${user['nickname']}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .fontSize,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
