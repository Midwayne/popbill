import 'package:flutter/material.dart';

//Screen to show while firebase figures out whether it has a token or not
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PopBill'),
      ),
      body: const Center(
        child: Text('Loading...'),
      ),
    );
  }
}
