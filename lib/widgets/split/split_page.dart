import 'package:flutter/material.dart';
import 'package:popbill/widgets/home/app_drawer.dart';

class SplitPage extends StatefulWidget {
  const SplitPage({super.key});
  @override
  State<SplitPage> createState() => _SplitPageState();
}

class _SplitPageState extends State<SplitPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.group_add),
          )
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
