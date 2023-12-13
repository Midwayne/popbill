import 'package:flutter/material.dart';
import 'package:popbill/screens/currently_building.dart';
import 'package:popbill/widgets/expenses/expenses_page.dart';
import 'package:popbill/widgets/split/split_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

//How do I change default page when the app is restarted using curved_navigation_bar
//Even if the _selectedIndex is set to 1, the expense screen renders while the bottom tab is at 0
class _HomeScreenState extends State<HomeScreen> {
  var _selectedIndex = 0;
  static const List<Widget> _widgetOptions = [
    CurrentlyBuilding(),
    ExpensesPage(),
    SplitPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /*
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
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      //drawer:
      body: _widgetOptions.elementAt(_selectedIndex),
      /*
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
      */
      bottomNavigationBar: CurvedNavigationBar(
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.white,
        animationCurve: Curves.fastEaseInToSlowEaseOut,
        //animationCurve: Curves.fastOutSlowIn,
        onTap: _onItemTapped,
        height: 65,
        items: <Widget>[
          Icon(
            Icons.align_horizontal_left,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          Icon(
            Icons.attach_money,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          Icon(
            Icons.person_add,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ],
      ),
    );
  }
}
