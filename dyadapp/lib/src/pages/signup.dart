//NEED TO IMPLEMENT -> Navigate to feed after signed up + password confirmation
import 'package:dyadapp/src/data.dart';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/pages/about.dart';
import 'package:dyadapp/src/utils/api_provider.dart';
import 'package:http/http.dart' as http;

// Sign Up Info Class
class Credentials {
  final String userName;
  final String password;
  final String email;

  Credentials(this.userName, this.password, this.email);
}

// Sign Up Widget
class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

// Sign Up State for Login
class _SignupScreenState extends State<SignupScreen> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();

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
      body: _buildSignup(),
    );
  }

  void _handleAboutTapped() {
    Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (context) => const AboutScreen()));
  }

 void displayDialog(BuildContext context, String title, String text) => 
	showDialog(
	  context: context,
	  builder: (context) =>
	    AlertDialog(
	      title: Text(title),
	      content: Text(text)
	    ),
	); 

  Widget _buildSignup() {
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
                  'Sign Up',
                  style: TextStyle(fontSize: 48.0),
                ),
              ),
            ),
            Container(
              height: 80,
              child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.call),
                  labelText: 'Username',
                ),
                keyboardType: TextInputType.text,
                controller: _userNameController,
              ),
            ),
            Container(
              height: 80,
              child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.mail_outline),
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.text,
                controller: _emailController,
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
                keyboardType: TextInputType.text,
                controller: _passwordController,
                validator: (val) {
                  if (val != null && val.isNotEmpty) {
                    return null;
                  } else {
                    return "Password cannot be empty";
                  }
                },
              ),
            ),
            Container(
              height: 80,
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Confirm Password',
                ),
                keyboardType: TextInputType.text,
                controller: _confirmPasswordController,
                validator: (val) {
                  if (val != _passwordController.text) {
                    return "Passwords must match";
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
              child: Container(
                height: 40,
                child: ElevatedButton(
                  child: Text("Sign Up"),
                  onPressed: () async {
                    var details = new Map<String, String>();
                    details['username'] = _userNameController.text;
                    details['password'] = _passwordController.text;

                    if (_userNameController.text.length < 3 || _userNameController.text.length > 20)
                    {
                      displayDialog(context,"Invalid Username", "The username should be 3-20 characters");
                    }
                    else if (_passwordController.text.length < 6 || _passwordController.text.length > 20)
                    {
                      displayDialog(context,"Invalid Password", "The password should be 6-20 characters");
                    }
                    else
                    {
                      var response = await APIProvider.postUserSignup(details);
                      if (response != '')
                      {
                       displayDialog(context,"Success", "Your account has been successfully created");
                      }
                      else
                      {
                        displayDialog(context,"Error", "Username is already taken");
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
