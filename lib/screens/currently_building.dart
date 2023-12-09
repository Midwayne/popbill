import 'package:flutter/material.dart';

class CurrentlyBuilding extends StatelessWidget {
  const CurrentlyBuilding({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Currently under construction'),
            Text('Please come back later'),
          ],
        ),
      ),
    );
  }
}
