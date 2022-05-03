// Author: Vincent
// Creates a single post tile for feed using post bar and displaying content

import 'package:dyadapp/src/utils/data/group.dart';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/widgets/post_bar.dart';
import 'package:dyadapp/src/widgets/schedule.dart';
import 'package:dyadapp/src/routing.dart';
import 'package:dyadapp/src/pages/post.dart';
import 'package:dyadapp/src/utils/database_handler.dart';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:dyadapp/src/data.dart';
import 'package:provider/provider.dart';

import '../pages/profile.dart';
import '../utils/api_provider.dart';
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
    this.imageURL,
    this.eventDateTime,
    Key? key,
  }) : super(key: key);

  // Callback for entering post screen
  final Function(int) postNavigatorCallback;

  // Callback for deleting post
  final Function(int, String) onDeleteCallback;

  // Callback for update a post
  final Future<Post?> Function(Post) onUpdateCallback;
  final int postId;
  final String? profilePicture;
  final String title;
  final String author;
  final String content;
  final DateTime datetime;
  final String? imageURL;
  final DateTime? eventDateTime;

  @override
  Widget build(BuildContext context) {
    final groupInstance = Provider.of<Group>(context);
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: TextButton(
            onLongPress: () async {
              if (author == await UserSession().get("username")) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // Shows a popup dialog with options the users have
                      return SimpleDialog(
                        title: const Text('Post Options',
                            style: TextStyle(fontSize: 20)),
                        contentPadding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                Post? post = await DatabaseHandler()
                                    .getPost(postId.toString());
                                var username =
                                    await UserSession().get("username");
                                if (post != null) {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute<void>(
                                    builder: (context) => PostScreen(
                                        onUpdateCallback,
                                        groupInstance.getUser(author),
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
              } else {
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
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                        builder: (context) => ProfileScreen(
                                            groupInstance.getUser(author)!)));
                              },
                              child: const Text('View Author Profile',
                                  style: TextStyle(fontSize: 14))),
                          // Show report form if user presses report
                          ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      TextEditingController _reasonController =
                                          TextEditingController();
                                      return SimpleDialog(
                                          title: const Text('Report Form',
                                              style: TextStyle(fontSize: 20)),
                                          contentPadding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("User:",
                                                  style: TextStyle(
                                                      color: Color(0xffd3d3d3),
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            Text(this.author),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("Offending Title:",
                                                  style: TextStyle(
                                                      color: Color(0xffd3d3d3),
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            Text(this.title),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("Offending Content:",
                                                  style: TextStyle(
                                                      color: Color(0xffd3d3d3),
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            Text(this.content),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text("Image:",
                                                  style: TextStyle(
                                                      color: Color(0xffd3d3d3),
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            (this.imageURL != null)
                                                ? Image.network(this.imageURL!)
                                                : Text("No Image"),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextField(
                                                  controller: _reasonController,
                                                  decoration: InputDecoration(
                                                      labelText: 'Reason',
                                                      hintMaxLines: 20),
                                                  maxLines: 2,
                                                  minLines: 1),
                                            ),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  String offender = this.author;
                                                  String offendingTitle =
                                                      this.title;
                                                  String offendingContent =
                                                      this.content;
                                                  String image =
                                                      imageURL ?? "noimg";
                                                  APIProvider.reportContent(
                                                      offender,
                                                      offendingContent,
                                                      offendingTitle,
                                                      image,
                                                      _reasonController.text);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Submit Report"))
                                          ]);
                                    });
                              },
                              child: const Text('Report',
                                  style: TextStyle(fontSize: 14)))
                        ],
                      );
                    });
              }
            },
            onPressed: () async {
              Post? post = await DatabaseHandler().getPost(postId.toString());
              var username = await UserSession().get("username");
              if (post != null)
                Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (context) => PostScreen(
                      onUpdateCallback,
                      Provider.of<Group>(context).getUser(author),
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
                      child: imageURL != null
                          ? Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: Row(
                                    children: [
                                      eventDateTime != null ?
                                      Schedule(eventDateTime!) : Container(),
                                      Expanded(
                                        child: Text(
                                          content,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: themeNotifier.isDark
                                                ? Color(0xFFE5E9F0)
                                                : Color(0xFF6A808F),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Image.network(imageURL!, loadingBuilder:
                                    (BuildContext context, Widget child,
                                        ImageChunkEvent? event) {
                                  if (event == null) {
                                    return child;
                                  }
                                  return Center(
                                      child: LinearProgressIndicator(
                                          value: event.expectedTotalBytes !=
                                                  null
                                              ? event.cumulativeBytesLoaded /
                                                  event.expectedTotalBytes!
                                              : null));
                                }),
                              ],
                            )
                          : Row(
                              children: [
                                eventDateTime != null ?
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: Schedule(eventDateTime!),
                                ) : Container(),
                                Text(
                                  content,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: themeNotifier.isDark
                                        ? Color(0xFFE5E9F0)
                                        : Color(0xFF6A808F),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            )),
      );
    });
  }
}
