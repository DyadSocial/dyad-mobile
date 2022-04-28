import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/data.dart';
import 'package:dyadapp/src/pages/settings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/api_provider.dart';
import '../utils/user_session.dart';

class ProfileScreen extends StatelessWidget {
  final User user;
  String? username = null;

  ProfileScreen(
    this.user, {
    Key? key,
  }) : super(key: key);

  Future<String?> getUsername() async {
    username = await UserSession().get("username");
    return username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('Dyad')),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => {
                Navigator.of(context).push<void>(MaterialPageRoute<void>(
                    builder: (context) => const SettingsScreen()))
              },
            ),
          ],
        ),
        body: _buildPage());
  }

  Widget _buildPage() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              backgroundImage: user.profilePicture,
              radius: 120,
            ),
          ),
          SizedBox(height: 15),
          FutureBuilder<String?>(
              future: getUsername(),
              builder: (context, snapshot) {
                return Visibility(
                  visible: snapshot.data == user.username,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            child: Text("Change Picture"),
                            onPressed: () async {
                              print("Uploading");
                              ImagePicker _picker = ImagePicker();
                              final XFile? imageMem = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              print(imageMem);
                              if (imageMem != null) {
                                await APIProvider.uploadImageFile(
                                    imageMem.path, snapshot.data!, "profile");
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            child: Text("Edit Profile"),
                            onPressed: () {},
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Center(
              child: Text(
                '${user.username}',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              user.biography,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
