import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:popbill/widgets/user_profile/user_profile_page.dart';

class AppDrawer extends StatelessWidget {
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
          ListTile(
            title: const Text(
              'My account',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const UserProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
