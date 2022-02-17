import 'package:flutter/material.dart';
import 'package:dyadapp/src/widgets/post_bar.dart';
import 'package:dyadapp/src/routing.dart';
import 'package:dyadapp/src/pages/post.dart';
import 'package:dyadapp/src/utils/database_handler.dart';
import 'package:dyadapp/src/data.dart';

class PostTile extends StatelessWidget {
  const PostTile({
    required this.postNavigatorCallback,
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
  final int postId;
  final ImageProvider<Object> profilePicture;
  final String title;
  final String author;
  final String content;
  final DateTime datetime;
  final Image? image;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        Post? post = await DatabaseHandler().getPost(postId.toString());
        print(post);
        if (post != null)
          Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (context) => PostScreen(
                  groupInstance.allUsers
                      .firstWhere((user) => user.username == author),
                  post)));
      },
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
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: image ??
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, bottom: 8),
                      child: Text(content,
                          style: TextStyle(
                              fontSize: 15, color: Color(0xFF2E3440))),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
