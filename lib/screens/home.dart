import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:popbill/screens/splash.dart';
import 'package:popbill/services/auth_services.dart';
import 'package:popbill/widgets/expenses/expenses_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _selectedIndex = 1;
  static const List<Widget> _widgetOptions = [
    SplashScreen(),
    ExpensesPage(),
    SplashScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _pageTitle(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return 'Your account';
      case 1:
        return 'Your expenses';
      case 2:
        return 'Split your bill';
      default:
        return 'PopBill';
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle(_selectedIndex)),
      ),
      drawer: Drawer(
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
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        unselectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.align_horizontal_left),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Split',
          ),
        ],
      ),
    );
  }
}
