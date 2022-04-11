import 'package:dyadapp/src/utils/data/group.dart';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/widgets/post_bar.dart';
import 'package:dyadapp/src/routing.dart';
import 'package:dyadapp/src/pages/post.dart';
import 'package:dyadapp/src/utils/database_handler.dart';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:dyadapp/src/data.dart';
import 'package:provider/provider.dart';

import '../utils/theme_model.dart';

class PostTile extends StatelessWidget {
  const PostTile({
    required this.onUpdateCallback,
    required this.postNavigatorCallback,
    required this.onDeleteCallback,
    required this.postId,
    required this.profilePicture,
    required this.title,
    required this.author,
    required this.content,
    required this.datetime,
    this.image,
    Key? key,
  }) : super(key: key);

  final Function(int) postNavigatorCallback;
  final Function(int, String) onDeleteCallback;
  final Future<Post?> Function(Post) onUpdateCallback;
  final int postId;
  final ImageProvider<Object>? profilePicture;
  final String title;
  final String author;
  final String content;
  final DateTime datetime;
  final Image? image;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return TextButton(
          onLongPress: () async {
            if (author == await UserSession().get("username"))
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: const Text('Post Options',
                          style: TextStyle(fontSize: 20)),
                      contentPadding:
                          EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              Post? post = await DatabaseHandler().getPost(postId.toString());
                              var username = await UserSession().get("username");
                              if (post != null) {
                                Navigator.of(context).push(MaterialPageRoute<void>(
                                  builder: (context) => PostScreen(
                                      onUpdateCallback,
                                      groupInstance.allUsers
                                          .firstWhere((user) => user.username == author),
                                      post,
                                      username == author),
                                ));
                              }
                            },
                            child: const Text('Edit',
                                style: TextStyle(fontSize: 14))),
                        ElevatedButton(
                            onPressed: () {
                              onDeleteCallback(this.postId, this.author);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Delete',
                                style: TextStyle(fontSize: 14)))
                      ],
                    );
                  });
          },
          onPressed: () async {
            Post? post = await DatabaseHandler().getPost(postId.toString());
            var username = await UserSession().get("username");
            if (post != null)
              Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (context) => PostScreen(
                    onUpdateCallback,
                    groupInstance.allUsers
                        .firstWhere((user) => user.username == author),
                    post,
                    username == author),
              ));
          },
          child: Container(
            decoration: BoxDecoration(
                color: themeNotifier.isDark
                    ? Color(0xFF4C566A)
                    : Color(0xFFFFFFFF),
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 7),
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                      color: themeNotifier.isDark
                          ? Color(0xCA2E3440)
                          : Color(0xAA475D68))
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PostBar(
                  profilePicture,
                  author,
                  title,
                  datetime,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0)),
                    child: image ??
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 8),
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: 20, left: 20, right: 20),
                            child: Text(
                              content,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                color: themeNotifier.isDark
                                    ? Color(0xFFE5E9F0)
                                    : Color(0xFF6A808F),
                              ),
                            ),
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ));
    });
  }
}
