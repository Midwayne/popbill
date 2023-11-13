import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:popbill/services/auth_services.dart';
import 'package:popbill/widgets/authorisation/email_login.dart';

class ServiceLogin extends StatelessWidget {
  const ServiceLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 65.0),
          child: Text(
            "Use your Email or an existing Google or Apple account to login",
            style: TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
        const Row(
          children: [
            Expanded(
              child: Divider(),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const EmailLogin(),
                  ),
                );
              },
              icon: SvgPicture.asset(
                "assets/icons/email.svg",
                height: 64,
                width: 64,
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                AuthService().signInWithGoogle(context);
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
                "assets/icons/apple.svg",
                height: 64,
                width: 64,
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
