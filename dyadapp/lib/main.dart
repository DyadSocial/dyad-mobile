import 'package:flutter/material.dart';

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

// Login Info Class
class LoginInfo {
  String _username = '';
  String _password = '';

  LoginInfo();

  void setUsername(username) {
    this._username = username;
  }

  void setPassword(password) {
    this._password = password;
  }

  @override
  String toString() {
    return "username: ${this._username}, password: ${this._password}";
  }
}

// Login Widget
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

// Login State for Login
class _LoginState extends State<Login> {
  LoginInfo loginInfo = LoginInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dyad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: _pushLoginHelp,
            tooltip: 'Login Help',
          ),
        ],
      ),
      body: _buildLogin(),
    );
  }

  void _pushLoginHelp() {}

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
              ),
            ),
            Container(
              height: 80,
              child: TextFormField(
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
              child: Container(
                height: 40,
                child: ElevatedButton(
                  child: Text("Submit"),
                  onPressed: () {},
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
