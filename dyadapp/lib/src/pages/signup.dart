//NEED TO IMPLEMENT -> Navigate to feed after signed up + password confirmation
import 'package:dyadapp/src/data.dart';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/pages/about.dart';
import 'package:dyadapp/src/utils/api_provider.dart';
import 'package:http/http.dart' as http;

// Sign Up Info Class
class Credentials {
  final String phoneNumber;
  final String password;
  final String name;
  final String email;

  Credentials(this.phoneNumber, this.password, this.name, this.email);
}

// Sign Up Widget
class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

// Sign Up State for Login
class _SignupScreenState extends State<SignupScreen> {
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
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
                  labelText: 'Phone Number',
                ),
                keyboardType: TextInputType.phone,
                controller: _phoneNumberController,
              ),
            ),
            Container(
              height: 80,
              child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.account_circle_rounded),
                  labelText: 'Name',
                ),
                keyboardType: TextInputType.text,
                controller: _nameController,
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
                  onPressed: () {
                    var credentials = Credentials(
                      _phoneNumberController.value.text,
                      _passwordController.value.text,
                      _nameController.value.text,
                      _emailController.value.text,
                    );
                    APIProvider.postUserSignup(
                      <String, String>{
                        "username": credentials.phoneNumber,
                        "password": credentials.password,
                        "nickname": credentials.name,
                        "profilepicture":
                            'https://scontent-sjc3-1.xx.fbcdn.net/v/t1.6435-9/102380597_1514900362022644_5290959128538387371_n.jpg?_nc_cat=105&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=XX21z4bwB1cAX87haow&_nc_ht=scontent-sjc3-1.xx&oh=2f05cc1801cb3c32196dc289e7e5ce80&oe=61D0E951',
                      },
                    );
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
