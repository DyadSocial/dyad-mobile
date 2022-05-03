// Page to set up the user's profile shown when user first creates their accounts
// or does not have any profile information
// author: Vincent

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

class NewProfileScreen extends StatefulWidget {
  NewProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  _NewProfileScreenState createState() => _NewProfileScreenState();
}

class _NewProfileScreenState extends State<NewProfileScreen> {
  late TextEditingController _nicknameEditingController;
  late TextEditingController _biographyEditingController;
  XFile? _imageMem = null;
  ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nicknameEditingController = TextEditingController();
    _biographyEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Center(child: const Text('New Profile')),
        ),
        body: _buildPage());
  }

  Widget _buildPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text("Welcome to Dyad! Let's set up your profile. 🗒️",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
          SizedBox(height: 20),
          SizedBox(
              width: double.infinity,
              child: Text(
                "Profile Picture",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.left,
              )),
          SizedBox(height: 10),
          InkWell(
              customBorder: CircleBorder(),
              child: CircleAvatar(
                  backgroundImage: (_imageMem != null)
                      ? Image.file(File((_imageMem?.path)!)).image
                      : null,
                  foregroundColor: Colors.black12,
                  backgroundColor: Colors.white70,
                  maxRadius: 60,
                  child: Text("Tap", style: TextStyle(fontSize: 40))),
              onTap: () async {
                XFile? image =
                    await _imagePicker.pickImage(source: ImageSource.gallery);
                setState(() {
                  _imageMem = image;
                });
              }),
          SizedBox(height: 20),
          SizedBox(
              width: double.infinity,
              child: Text(
                "Nickname",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.left,
              )),
          TextField(
              decoration: InputDecoration(
                  hintText: "Only seen when people see your profile!"),
              controller: _nicknameEditingController),
          SizedBox(height: 20),
          SizedBox(
              width: double.infinity,
              child: Text(
                "Biography",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.left,
              )),
          TextField(
              decoration: InputDecoration(
                  hintText: "A short and sweet description of you."),
              controller: _biographyEditingController,
              minLines: 1,
              maxLines: 3),
          SizedBox(height: 20),
          ElevatedButton(
              child: Text("Get Started!"),
              onPressed: () async {
                APIProvider.createUserProfile(_biographyEditingController.text,
                    _nicknameEditingController.text);
                if (_imageMem != null) {
                  String? username = await UserSession().get("username");
                  if (username != null) {
                    int uuid = hash3("profile", username,
                        DateTime.now().millisecondsSinceEpoch);
                    String? imgPath = await APIProvider.uploadImageFile(
                        (_imageMem?.path)!, username, uuid.toString());
                    if (imgPath != null) {
                      String imgURL = "https://api.dyadsocial.com" + imgPath;
                      await APIProvider.updateUserProfile(imageURL: imgURL);
                      Navigator.of(context).pop();
                    }
                  }
                }
                Navigator.of(context).pop();
              })
        ]),
      ),
    );
  }
}
