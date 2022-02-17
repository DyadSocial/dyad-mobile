import 'package:dyadapp/src/utils/user_session.dart';
import 'package:dyadapp/src/utils/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/pages/about.dart';
import 'package:dyadapp/src/pages/signup.dart';
import 'package:dyadapp/src/pages/help.dart';

import '../routing.dart';

// Login Info Class
class Credentials {
  late String userName;
  late String password;

  Credentials(username, password) {
    this.userName = username;
    this.password = password;
  }
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
  final _userNameController = TextEditingController();
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
                  labelText: 'Username',
                ),
                validator: (val) {
                  if (val != null && val.isNotEmpty) {
                    return null;
                  } else if (val != null && val.length != 10) {
                    return "Invalid Username";
                  }
                },
                keyboardType: TextInputType.text,
                controller: _userNameController,
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
                    var details = new Map<String, String>();
                    details['username'] = _userNameController.text;
                    details['password'] = _passwordController.text;

                    var JWT = await APIProvider.logIn(details);

                    if (JWT != '')
                    {
                      await UserSession().set('access', JWT);
                      widget.onSignIn(Credentials(details['username'], details['password']));
                    }
                    else
                    {
                      AlertDialog(
                        title: Text("Error"),
                        content: Text("No account was found matching that username and password")
                      );
                    }     
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 0),
              child: TextButton(
                child: Text('Trouble signing in?'),
                onPressed: () {
                  Navigator.of(context).push<void>(MaterialPageRoute<void>(
                      builder: (context) => const HelpScreen()));
                },
              ),
            ),
            TextButton(
              child: Text('Create an account'),
              onPressed: () => {
                Navigator.of(context).push<void>(MaterialPageRoute<void>(
                    builder: (context) => const SignupScreen()))
              },
            )
          ],
        ),
      ),
    );
  }
}
