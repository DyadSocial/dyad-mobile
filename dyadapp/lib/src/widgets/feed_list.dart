// Author: Vincent
// Returns a list of posts
// Posts currently scroll forever in order to prevent blocking due to
// network image not able to give a widget a set size
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/widgets/post_tile.dart';
import 'package:dyadapp/src/data.dart';
import 'package:dyadapp/src/utils/suggestive_list.dart';
import 'package:provider/provider.dart';
import '../utils/data/group.dart';

class FeedList extends StatefulWidget {
  final Future<Post?> Function(Post) onUpdateCallback;
  final Future<void> Function() refreshCallback;
  final Function(int) postNavigatorCallback;
  final List<Post> posts;
  final ValueChanged<Post>? onTap;
  final Function(int, String) onDeleteCallback;

  const FeedList(
    this.onUpdateCallback,
    this.refreshCallback,
    this.postNavigatorCallback,
    this.posts,
    this.onDeleteCallback, {
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

  // Custom page loading [WIP]
  // For now we implement the list to be full sized
  // This function needs to work with networking to account for the
  // sized of the post_tiles *after* they've loaded their images
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
    // Sort posts chronologically
    widget.posts.sort((a, b) {
      if (a.created.seconds < b.created.seconds) {
        return 1;
      } else if (a.created.seconds == b.created.seconds) {
        return 0;
      } else {
        return -1;
      }
    });
    // Consumes group so that it can update and read the current users
    return Consumer<Group>(
      builder: (context, group, child) => Container(
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
                // Suggests lists for inbox
                // TODO: Needs to be merged into Group implementation
                SuggestiveList.addUser(widget.posts[idx].author);
                return PostTile(
                  postNavigatorCallback: widget.postNavigatorCallback,
                  onDeleteCallback: widget.onDeleteCallback,
                  onUpdateCallback: widget.onUpdateCallback,
                  postId: post.id,
                  profilePicture: group.getUser(post.author)?.profilePicture ?? null,
                  imageURL: post.content.hasImage() ? post.content.image : null,
                  title: post.title,
                  author: post.author,
                  content: post.content.text,
                  datetime: DateTime.fromMillisecondsSinceEpoch(
                      (post.created.seconds * 1000).toInt()),
                  eventDateTime: post.hasEventTime() ? DateTime.fromMillisecondsSinceEpoch(
                      (post.eventTime.seconds * 1000).toInt()) : null,
                );
              }),
        ),
      ),
    );
  }
}
