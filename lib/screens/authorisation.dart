import 'package:flutter/material.dart';
import 'package:popbill/widgets/authorisation/service_login.dart';

class AuthorisationScreen extends StatelessWidget {
  const AuthorisationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'PopBill',
                style: TextStyle(
                  fontSize: 80,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Manage expenses. Split bills',
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 50),
              const Card(
                elevation: 10,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: ServiceLogin(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
