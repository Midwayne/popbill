import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:popbill/services/auth_services.dart';

class ServiceLogin extends StatelessWidget {
  const ServiceLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            "Use your existing Google, Facebook or Apple account",
            style: TextStyle(color: Colors.black54),
          ),
        ),
        const Row(
          children: [
            Expanded(
              child: Divider(),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                AuthService().signInWithGoogle();
              },
              icon: SvgPicture.asset(
                "assets/icons/google.svg",
                height: 64,
                width: 64,
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/icons/facebook.svg",
                height: 64,
                width: 64,
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/icons/apple.svg",
                height: 64,
                width: 64,
              ),
            ),
          ],
        ),
        const SizedBox(height: 35),
      ],
    );
  }
}
