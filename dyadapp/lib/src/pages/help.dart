import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  _RecoveryScreenState createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<HelpScreen> {
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
  return Scaffold(
        appBar: AppBar(
          title: const Text('Dyad'),
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
                  'Account Recovery',
                  style: TextStyle(fontSize: 36.0),
                ),
              ),
            ),
            Container(
              height: 100,
              child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.call),
                  labelText: 'Phone Number',
                ),
                validator: (val) {
                  if (val != null && val.isNotEmpty) {
                    return null;
                  } else if (val != null && val.length != 10) {
                    return "Invalid phone number";
                  }
                },
                keyboardType: TextInputType.phone,
                controller: _phoneNumberController,
              ),
            ),
            Container(
              height: 80,
              child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.mail_outline),
                  labelText: 'Email',
                ),
                validator: (val) {
                  if (val != null && val.isNotEmpty) {
                    return null;
                  } else {
                    return "Email cannot be empty";
                  }
                },
                keyboardType: TextInputType.text,
                controller: _emailController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
              child: Container(
                height: 40,
                child: ElevatedButton(
                  child: Text("Submit"),
                  onPressed: () async {
                    //TODO: Sam networking for confirmation
                  },
                ),
              ),
            )
          ]
        ), 
      ),
    );
  }
} 