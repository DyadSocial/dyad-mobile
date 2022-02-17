import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dyadapp/src/widgets/post_tile.dart';
import 'package:dyadapp/src/data.dart';

class FeedList extends StatelessWidget {
  final Function(int) postNavigatorCallback;
  final List<Post> posts;
  final ValueChanged<Post>? onTap;

  const FeedList(
    this.postNavigatorCallback,
    this.posts, {
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort chronologically
    posts.sort((a, b) {
      if (a.lastUpdated.seconds < b.lastUpdated.seconds) {
        return 1;
      } else if (a.lastUpdated.seconds == b.lastUpdated.seconds) {
        return 0;
      } else {
        return -1;
      }
    });
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostTile(
          postNavigatorCallback: postNavigatorCallback,
          postId: posts[index].id,
          profilePicture: groupInstance.allUsers
              .firstWhere((user) => user.username == posts[index].author)
              .profilePicture,
          image: posts[index].content.hasImage()
              ? Image.file(File(posts[index].content.image))
              : null,
          title: posts[index].title,
          author: posts[index].author,
          content: posts[index].content.text,
          datetime: DateTime.fromMillisecondsSinceEpoch(
              (posts[index].created.seconds * 1000).toInt()),
        );
      },
    );
  }
}
