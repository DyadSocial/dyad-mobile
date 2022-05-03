// Author: Vincent
// Shows user profile picture, biography, nickname, and allows editing
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/data.dart';
import 'package:dyadapp/src/pages/settings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:quiver/core.dart';

import '../utils/api_provider.dart';
import '../utils/data/group.dart';
import '../utils/user_session.dart';

// Shows details of User's profile description, their profile image, nickname,
// and list of their posts that are currently in the current user's feed
// Vincent
class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen(
    this.user, {
    Key? key,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User user;
  String? username = null;
  bool editing = false;
  late TextEditingController _biographyEditingController;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    _biographyEditingController = TextEditingController(text: user.biography);
  }

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: (user.profilePicture != null)
                    ? Image.network(user.profilePicture!).image
                    : null,
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
                                final uuid = hash3("profile", snapshot.data,
                                    DateTime.now().millisecondsSinceEpoch);
                                var imgURL = "";
                                if (imageMem != null) {
                                  String? imgPath = await APIProvider.uploadImageFile(
                                      imageMem.path,
                                      snapshot.data!,
                                      uuid.toString());
                                  if (imgPath != null) {
                                    imgURL = "https://api.dyadsocial.com" + imgPath;
                                    print(imgURL);
                                  }
                                }
                                await APIProvider.updateUserProfile(
                                    imageURL: imgURL);
                                var user = await APIProvider.getUserProfile(
                                    snapshot.data!);
                                Provider.of<Group>(context, listen: false)
                                    .updateUser(
                                    username: snapshot.data!,
                                    imageURL: user['picture_URL'],
                                    biography:
                                    user['Profile_Description'],
                                    nickname: user['Display_name']);
                                // Update current widget
                                setState(() {
                                  this.user = Provider.of<Group>(context,
                                      listen: false)
                                      .getUser(snapshot.data!)!;
                                });

                              },
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              child: Text(editing ? "Update" : "Edit Profile"),
                              onPressed: () async {
                                if (editing) {
                                  // Update Biography Backend
                                  print(await APIProvider.updateUserProfile(
                                      description:
                                          _biographyEditingController.text));
                                  String? currentUsername =
                                      await UserSession().get("username");
                                  // Get backend's data
                                  var user = await APIProvider.getUserProfile(
                                      currentUsername!);
                                  // Update Biography Locally
                                  Provider.of<Group>(context, listen: false)
                                      .updateUser(
                                          username: currentUsername,
                                          imageURL: user['picture_URL'],
                                          biography:
                                              user['Profile_Description'],
                                          nickname: user['Display_name']);
                                  // Update current widget
                                  setState(() {
                                    this.user = Provider.of<Group>(context,
                                            listen: false)
                                        .getUser(currentUsername)!;
                                  });
                                }
                                setState(() {
                                  editing = !editing;
                                });
                              },
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
                  '${(user.nickname != "") ? user.nickname : user.username}',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Center(
              child: (editing)
                  ? TextField(
                      controller: _biographyEditingController,
                      textAlign: TextAlign.center,
                      minLines: 1,
                      maxLines: 2)
                  : InkWell(
                      child: Text(
                      user.biography ?? "",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )),
            ),
          ],
        ),
      ),
    );
  }
}
