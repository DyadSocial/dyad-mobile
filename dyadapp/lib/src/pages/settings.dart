import 'package:dyadapp/src/app.dart';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/utils/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:dyadapp/src/pages/profile.dart';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:dyadapp/src/data.dart';
import 'package:dyadapp/src/utils/dyad_auth.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void _handleLogoutTapped(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
              child: ElevatedButton(
                child: Text("Change theme"),
                onPressed: () {
                  themeNotifier.isDark
                      ? themeNotifier.isDark = false
                      : themeNotifier.isDark = true;
                },
              ),
            ),
            Container(
              child: ElevatedButton(
                child: Text("View Profile"),
                onPressed: () async {
                  final currentUsername = await UserSession().get("username");
                  var user = groupInstance.allUsers
                      .firstWhere((user) => user.username == currentUsername);
                  Navigator.of(context).push<void>(MaterialPageRoute<void>(
                      builder: (context) => ProfileScreen(user)));
                },
              ),
            ),
            Container(
              child: ElevatedButton(
                child: Text("Logout"),
                onPressed: () {
                  DyadAuthScope.of(context).signOut();
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
