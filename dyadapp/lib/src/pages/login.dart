import 'package:dyadapp/src/utils/user_session.dart';
import 'package:dyadapp/src/utils/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/pages/about.dart';
import 'package:dyadapp/src/pages/signup.dart';
import 'package:dyadapp/src/pages/help.dart';
import 'package:dyadapp/src/pages/map.dart';

import '../routing.dart';
import '../utils/auth_token.dart';
import '../utils/dyad_auth.dart';
import 'newprofile.dart';

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
  final Future<bool> Function(Credentials) onSignIn;

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
  late var _loginStatus;

  //On successful login, reroute to feed page
  void rerouteLoggedIn() async {
    await Future.delayed(Duration.zero, () async {
      if (await AuthToken.getStatus() == UserStatus.loggedIn) {
        final routeState = RouteStateScope.of(context);
        final authState = DyadAuthScope.of(context);
        authState.isSignedIn = true;
        routeState.go('/feed');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Check if user is logged in
    _loginStatus = "NO_ERROR";
    rerouteLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dyad'),
        actions: [
          //About button so users can find out more about the application
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
        MaterialPageRoute<void>(builder: (context) => AboutScreen()));
  }
  //Alert Dialog for errors when logging in
  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

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
            Visibility(
              visible: (_loginStatus == "ERROR"),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xffBF616A),
                      borderRadius: BorderRadius.circular(5)),
                  height: 40,
                  child: Center(
                      child: Text("Error: Invalid Login Credentials",
                          style: TextStyle(fontSize: 16))),
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
                    var signInStatus = await widget.onSignIn(Credentials(
                      _userNameController.value.text,
                      _passwordController.value.text,
                    ));
                    setState(() {
                      if (!signInStatus) {
                        _loginStatus = "ERROR";
                      }
                    });

                    //displayDialog(
                    //  context, "Error", "Incorrect Username or Password");
                  },
                ),
              ),
            ),
            //Button for forgot password resetting.
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
            //Button to create a new account
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
