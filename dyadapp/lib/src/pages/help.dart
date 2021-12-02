import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: _buildRecovery(),
    );
  }
  
Widget _buildRecovery() {
 return Center(
      child: SizedBox(
        width: 300,
        child: ListView(
          children: <Widget>[
            Container(
              width: 500,
              height: 125,
              child: Center(
                child: Text(
                  "Account Recovery",
                  style: TextStyle(fontSize: 36.0),
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.all(5.0),
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  //navigate to change password page ?
                },
                child: Text("Forgot Password"),
                ),
              ),

            Container(
              margin: const EdgeInsets.all(5.0),
              height: 50,
              child: ElevatedButton(
                child: Text("Forgot Username"),
                onPressed: () {
                  //navigate to get username page ?
                },
              ),
            )
          ]
        ), 
      ),
    );
  }
} 