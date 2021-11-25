import 'package:flutter/material.dart';
import 'package:dyadapp/src/pages/about.dart';
import '../routing.dart';

// Login Info Class
class Credentials {
  final String phoneNumber;
  final String password;

  Credentials(this.phoneNumber, this.password);
}

// Login Widget
class LoginScreen extends StatefulWidget {
  final ValueChanged<Credentials> onSignIn;

  const LoginScreen({
    required this.onSignIn,
    Key? key,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// Login State for Login
class _LoginScreenState extends State<LoginScreen> {
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dyad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: _handleAboutTapped,
            tooltip: 'About Dyad',
          ),
        ],
      ),
      body: _buildLogin(),
    );
  }

  void _handleAboutTapped() {
    Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (context) => const AboutScreen()));
  }

  Widget _buildLogin() {
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
                  'Login',
                  style: TextStyle(fontSize: 48.0),
                ),
              ),
            ),
            Container(
              height: 100,
              child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
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
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
                validator: (val) {
                  if (val != null && val.isNotEmpty) {
                    return null;
                  } else {
                    return "Password cannot be empty";
                  }
                },
                keyboardType: TextInputType.text,
                controller: _passwordController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
              child: Container(
                height: 40,
                child: ElevatedButton(
                  child: Text("Sign In"),
                  onPressed: () async {
                    widget.onSignIn(Credentials(
                      _phoneNumberController.value.text,
                      _passwordController.value.text,
                    ));
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 0),
              child: TextButton(
                child: Text('Trouble signing in?'),
                onPressed: () {},
              ),
            ),
            TextButton(
              child: Text('Create an account'),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}