//Authors: Vincent
// Shows the bar in post tiles and post page with author username, author picture
// timeago, and title.
// Keeps styling consistent

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:dyadapp/src/utils/theme_model.dart';

import '../pages/profile.dart';
import '../utils/api_provider.dart';
import '../utils/data/group.dart';

class PostBar extends StatelessWidget {
  const PostBar(
    this.profilePicture,
    this.author,
    this.title,
    this.datetime,
    this.isModerator, {
    Key? key,
  }) : super(key: key);

  final String? profilePicture;
  final String title;
  final String author;
  final DateTime datetime;
  final bool isModerator;

  @override
  Widget build(BuildContext context) {
    print("$author:$isModerator");
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: GestureDetector(
                  onTap: () {},
                  child: InkWell(
                    customBorder: CircleBorder(),
                    onTap: () async {
                      var data = await APIProvider.getUserProfile(author);
                      Provider.of<Group>(context, listen: false).updateUser(
                          username: author,
                          imageURL: data['picture_URL'],
                          biography: data['Profile_Description'],
                          nickname: data["Display_name"],
                          isModerator: data["is_moderator"]);
                      var user = Provider.of<Group>(context, listen: false)
                          .getUser(author);
                      if (user != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => ProfileScreen(user))));
                      }
                    },
                    child: CircleAvatar(
                      radius: 45,
                      foregroundImage: (profilePicture != null)
                          ? Image.network(profilePicture!).image
                          : null,
                      backgroundColor: Colors.white70,
                      foregroundColor: Colors.black12,
                      child: Text(author.substring(0, min(4, author.length))),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        // Moderator tag
                        isModerator
                            ? Container(
                                margin: EdgeInsets.only(right: 4),
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Color(0xFFA3BE8C),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text("MOD",
                                    style: TextStyle(
                                        color: Color(0xFFECEFF4),
                                        fontWeight: FontWeight.w500)))
                            : Container(),
                        Text(author,
                            style: TextStyle(
                                fontSize: 16,
                                color: themeNotifier.isDark
                                    ? Color(0xFFD8DEE9)
                                    : Color(0xFF6A808F))),
                      ],
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: themeNotifier.isDark
                            ? Color(0xFFECEFF4)
                            : Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                timeago.format(
                  datetime,
                  locale: 'en_short',
                ),
                style: const TextStyle(color: Color(0xFF6A808F), fontSize: 14),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      );
    });
  }
}
