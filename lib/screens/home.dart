import 'package:flutter/material.dart';
import 'package:popbill/screens/splash.dart';
import 'package:popbill/widgets/expenses/expenses_page.dart';
import 'package:popbill/widgets/split/split_page.dart';

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
    SplitPage(),
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
        toolbarHeight: 0,
      ),
      //drawer:
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
