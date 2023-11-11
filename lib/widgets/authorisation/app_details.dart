import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppDetails extends StatelessWidget {
  const AppDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/images/logo.svg",
          height: 140,
          width: double.infinity,
        ),
        Column(
          children: [
            Text(
              'PopBill',
              style: TextStyle(
                fontSize: 70,
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Manage expenses. Split bills',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
