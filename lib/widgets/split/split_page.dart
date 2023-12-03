import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:popbill/widgets/home/app_drawer.dart';
import 'package:popbill/widgets/split/add_group.dart';
import 'package:popbill/widgets/split/all_groups.dart';

class SplitPage extends StatefulWidget {
  const SplitPage({super.key});
  @override
  State<SplitPage> createState() => _SplitPageState();
}

class _SplitPageState extends State<SplitPage> {
  @override
  void initState() {
    super.initState();
    checkInternet();
  }

  void reloadPage() {
    setState(() {});
  }

  bool isConnectedToInternet = false;

  void checkInternet() async {
    // check connectivity_plus plugin. It might not work in certain cases though
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isConnectedToInternet = true;
        });
        //print('connected');
      }
    } on SocketException catch (_) {
      setState(() {
        isConnectedToInternet = false;
      });
      //print('not connected');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return !isConnectedToInternet
        ? Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Please check your internet connection',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize),
                  ),
                  ElevatedButton(
                      onPressed: checkInternet, child: const Text('Try again'))
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Groups'),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AddGroup(
                            currentUserId: currentUserId,
                            reloadPage: reloadPage,
                          );
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.group_add),
                )
              ],
            ),
            drawer: AppDrawer(),
            body: const AllGroups(),
          );
  }
}
