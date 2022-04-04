import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/widgets/post_tile.dart';
import 'package:dyadapp/src/data.dart';

import '../utils/data/group.dart';

class FeedList extends StatelessWidget {
  final Future<void> Function() refreshCallback;
  final Function(int) postNavigatorCallback;
  final List<Post> posts;
  final ValueChanged<Post>? onTap;
  final Function(int, String) onDeleteCallback;
  final Function(int, String, String) onEditCallback;

  const FeedList(
    this.refreshCallback,
    this.postNavigatorCallback,
    this.posts,
    this.onDeleteCallback,
    this.onEditCallback, {
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
    return RefreshIndicator(
      strokeWidth: 1,
      onRefresh: refreshCallback,
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 11),
        itemCount: posts.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) return SizedBox(height: 15);
          if (index == posts.length + 1) return SizedBox(height: 300);
          index = index - 1;
          return PostTile(
            postNavigatorCallback: postNavigatorCallback,
            onDeleteCallback: onDeleteCallback,
            onEditCallback: onEditCallback,
            postId: posts[index].id,
            profilePicture: groupInstance.allUsers
                    .firstWhereOrNull(
                        (user) => user.username == posts[index].author)
                    ?.profilePicture ??
                null,
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
      ),
    );
  }
}
