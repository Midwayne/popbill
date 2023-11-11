import 'package:flutter/material.dart';
import 'package:popbill/widgets/authorisation/app_details.dart';
import 'package:popbill/widgets/authorisation/service_login.dart';

class AuthorisationScreen extends StatelessWidget {
  const AuthorisationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(
        child: SingleChildScrollView(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppDetails(),
              SizedBox(height: 50),
              Card(
                elevation: 10,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: ServiceLogin(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
