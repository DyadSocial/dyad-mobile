import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("about screen build");
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Dyad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            tooltip: 'About Dyad',
          )
        ],
      ),
    );
  }
}
