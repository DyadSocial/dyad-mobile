import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/widgets/post_tile.dart';
import 'package:dyadapp/src/data.dart';

import '../utils/data/group.dart';

class FeedList extends StatefulWidget {
  final Future<Post?> Function(Post) onUpdateCallback;
  final Future<void> Function() refreshCallback;
  final Function(int) postNavigatorCallback;
  final List<Post> posts;
  final ValueChanged<Post>? onTap;
  final Function(int, String) onDeleteCallback;
  final Function(int, String, String) onEditCallback;

  const FeedList(
      this.onUpdateCallback,
      this.refreshCallback,
      this.postNavigatorCallback,
      this.posts,
      this.onDeleteCallback,
      this.onEditCallback, {
        this.onTap,
        Key? key,
      }) : super(key: key);

  @override
  _FeedListState createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    // Sort chronologically
    widget.posts.sort((a, b) {
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
      onRefresh: widget.refreshCallback,
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 11),
        itemCount: widget.posts.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) return SizedBox(height: 15);
          if (index == widget.posts.length + 1) return SizedBox(height: 300);
          index = index - 1;
          return PostTile(
            postNavigatorCallback: widget.postNavigatorCallback,
            onDeleteCallback: widget.onDeleteCallback,
            onUpdateCallback: widget.onUpdateCallback,
            postId: widget.posts[index].id,
            profilePicture: groupInstance.allUsers
                    .firstWhereOrNull(
                        (user) => user.username == widget.posts[index].author)
                    ?.profilePicture ??
                null,
            image: widget.posts[index].content.hasImage()
                ? Image.file(File(widget.posts[index].content.image))
                : null,
            title: widget.posts[index].title,
            author: widget.posts[index].author,
            content: widget.posts[index].content.text,
            datetime: DateTime.fromMillisecondsSinceEpoch(
                (widget.posts[index].created.seconds * 1000).toInt()),
          );
        },
      ),
    );
  }
}
