import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/data.dart';
import 'package:dyadapp/src/utils/data/protos/posts.pb.dart';

import '../utils/user_session.dart';
import 'comment_tile.dart';

// Builds a list of comment tiles via the _CommentListState class
class CommentList extends StatefulWidget {
  final Future<void> Function(CommentThread) onUpdateCallback;
  final Future<void> Function(int) replyCommentCallback;
  final List<CommentThread> comments;

  const CommentList(
      this.onUpdateCallback, this.replyCommentCallback, this.comments,
      {Key? key})
      : super(key: key);

  @override
  _CommentListState createState() => _CommentListState();
}

// State class for the comment list
// Builds a widget with a list of comments threads.
// Each comment thread can open up to show terminal comments which are
// enumerated on the common comment thread
class _CommentListState extends State<CommentList> {
  late List<CommentThread> _comments;

  @override
  void initState() {
    super.initState();
    _comments = widget.comments;
  }

  Future<List<Widget>> getCommentWidgetList() async {
    List<CommentTile> tile = [];
    var _currentUser = await UserSession().get("username");
    for (var comment in _comments) {
      tile.add(CommentTile(widget.onUpdateCallback, comment, _currentUser,
          widget.replyCommentCallback));
    }
    return tile;
  }

  // Actually builds the widget as described in the class description
  @override
  Widget build(BuildContext context) {
    // If no comments, print no comments to the user
    if (_comments.isEmpty) {
      return Padding(
          padding: EdgeInsets.all(20),
          child: Text("No Comments 💤", style: TextStyle(fontSize: 16)));
    }
    // Sort comments chronologically
    // else render all widgets in a column
    return FutureBuilder<List<Widget>>(
        future: getCommentWidgetList(),
        builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
          if (snapshot.hasData) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: snapshot.data!);
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
