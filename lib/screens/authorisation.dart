import 'package:flutter/material.dart';
import 'package:popbill/widgets/authorisation/app_details.dart';
import 'package:popbill/widgets/authorisation/service_login.dart';

class AuthorisationScreen extends StatelessWidget {
  const AuthorisationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size.height * 0.0029;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            //crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppDetails(),
              //SizedBox(height: 50),
              SizedBox(height: 14.5 * deviceSize),
              Card(
                elevation: 10,
                margin: EdgeInsets.symmetric(horizontal: 11.5 * deviceSize),
                child: const ServiceLogin(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
