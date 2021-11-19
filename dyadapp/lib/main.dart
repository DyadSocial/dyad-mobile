import 'package:flutter/material.dart';
import 'pages/login.dart';

void main() => runApp(DyadApp());

class DyadApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Dyad',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.orange,
        ),
      ),
      home: Login(),
    );
  }
}
