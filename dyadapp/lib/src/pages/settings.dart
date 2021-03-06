// Author: Vincent & Jake
// Jake added Change Theme button
// Vincent added asynchronous view profile (gets user data) and logout buttons

import 'dart:ffi';

import 'package:dyadapp/src/app.dart';
import 'package:dyadapp/src/utils/data/group.dart';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/utils/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:dyadapp/src/pages/profile.dart';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:dyadapp/src/data.dart';
import 'package:dyadapp/src/utils/dyad_auth.dart';

import '../utils/api_provider.dart';

//The settings will allow the user to change themes or look at their profile.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void _handleLogoutTapped(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    //Consumer is wrapped to update the theme on button press
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Consumer<Group>(
        builder: (context, group, child) => Scaffold(
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
              //Brings user to their profile page
              Container(
                child: ElevatedButton(
                  child: Text("View Profile"),
                  onPressed: () async {
                    final currentUsername = await UserSession().get("username");
                    var user = Provider.of<Group>(context, listen: false)
                        .getUser(currentUsername);
                    if (user == null) {
                      Provider.of<Group>(context, listen: false)
                          .addUser(username: currentUsername);
                      user = Provider.of<Group>(context, listen: false)
                          .getUser(currentUsername);
                    }
                    var profileData =
                        await APIProvider.getUserProfile(currentUsername);
                    Provider.of<Group>(context, listen: false).updateUser(
                        username: currentUsername,
                        imageURL: profileData['picture_URL'],
                        biography: profileData['Profile_Description'],
                        nickname: profileData['Display_name'],
                        isModerator: profileData['is_moderator']);

                    Navigator.of(context).push<void>(MaterialPageRoute<void>(
                        builder: (context) => ProfileScreen(user!)));
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
        ),
      );
    });
  }
}
