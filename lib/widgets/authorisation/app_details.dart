/*import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppDetails extends StatelessWidget {
  const AppDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size.height * 0.0029;
    return Row(
      children: [
        SvgPicture.asset(
          "assets/images/logo.svg",
          height: 55 * deviceSize,
          width: double.infinity,
        ),
        Column(
          children: [
            Text(
              'PopBill',
              style: TextStyle(
                //fontSize: 70,
                fontSize: 27 * deviceSize,
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            //const SizedBox(height: 10),
            SizedBox(height: 2.5 * deviceSize),
            Text(
              'Manage expenses. Split bills',
              style: TextStyle(
                //fontSize: 20,
                fontSize: 7.8 * deviceSize,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
*/

// This widget is not rendering properly on some devices

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppDetails extends StatelessWidget {
  const AppDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size.height * 0.0029;

    return Row(
      children: [
        Flexible(
          child: SvgPicture.asset(
            "assets/images/logo.svg",
            height: 55 * deviceSize,
            width: double.infinity,
          ),
        ),
        SizedBox(width: 10 * deviceSize), // Add some spacing
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PopBill',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
                  //fontSize: 22 * deviceSize,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.5 * deviceSize),
              Text(
                'Manage expenses. Split bills',
                style: TextStyle(
                  fontSize: 7.8 * deviceSize,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
