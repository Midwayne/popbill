import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:popbill/services/auth_services.dart';
import 'package:share_plus/share_plus.dart';

class AppDrawer extends StatelessWidget {
  final currentUserId = AuthService().getCurrentUserId();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        //padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/logo.svg",
                    //height: 100,
                    height: MediaQuery.sizeOf(context).height * 0.1,
                    width: double.infinity,
                  ),
                  Text(
                    'PopBill',
                    style: TextStyle(
                      //fontSize: 50,
                      fontSize: MediaQuery.sizeOf(context).height * 0.05,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //USER ID. REMOVE AFTER MAKING MY ACCOUNT PAGE
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(
                    currentUserId,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Share.share(currentUserId);
                },
                icon: const Icon(Icons.share),
              )
            ],
          ),

          ListTile(
            title: const Text(
              'My account',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {},
          ),
          ListTile(
            title: const Text(
              'Log out',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              AuthService().signOut();
            },
          ),
          ListTile(
            title: const Text('Delete my account'),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: const Text('Delete my account permanently'),
                    content: const Text(
                        'Are you sure you want to delete your account?\n\n'
                        'This will delete all your data'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        style: const ButtonStyle(
                          elevation: MaterialStatePropertyAll(6),
                        ),
                        onPressed: () {
                          AuthService().deleteAccount(context);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
