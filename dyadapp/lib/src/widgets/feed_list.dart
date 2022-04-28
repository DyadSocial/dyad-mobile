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
  // Keep the controller for list view so we can fetch more post when a user
  // scrolls past a certain extent
  late ScrollController _controller;

  void loadNextPage() async {
    print(_controller.position.extentAfter);
  }

  @override
  void initState() {
    super.initState();
    _controller = new ScrollController();
    _controller.addListener(loadNextPage);
  }

  @override
  void dispose() {
    _controller.removeListener(loadNextPage);
    super.dispose();
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
    return Container(
      child: RefreshIndicator(
        onRefresh: () async {
          widget.refreshCallback();
        },
        child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, idx) {
              if (idx > widget.posts.length-1) {
                return SizedBox(height: 250);
              }
              Post post = widget.posts[idx];
              return PostTile(
                postNavigatorCallback: widget.postNavigatorCallback,
                onDeleteCallback: widget.onDeleteCallback,
                onUpdateCallback: widget.onUpdateCallback,
                postId: post.id,
                profilePicture: groupInstance.allUsers
                        .firstWhereOrNull(
                            (user) => user.username == post.author)
                        ?.profilePicture ??
                    null,
                imageURL: post.content.hasImage() ? post.content.image : null,
                title: post.title,
                author: post.author,
                content: post.content.text,
                datetime: DateTime.fromMillisecondsSinceEpoch(
                    (post.created.seconds * 1000).toInt()),
              );
            }),
      ),
    );
  }
}
