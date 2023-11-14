import 'package:flutter/material.dart';

//Screen to show while firebase figures out whether it has a token or not
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
}
