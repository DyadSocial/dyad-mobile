import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/data.dart';
import 'package:dyadapp/src/utils/data/protos/posts.pb.dart';

import 'comment_tile.dart';

// Builds a list of comment tiles via the _CommentListState class
class CommentList extends StatefulWidget {
  final Future<void> Function(CommentThread) onUpdateCallback;
  final List<CommentThread> comments;

  const CommentList(this.onUpdateCallback, this.comments, {Key? key})
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

  List<Widget> getCommentWidgetList() {
    List<CommentTile> tile = [];
    for (var comment in _comments) {
      tile.add(CommentTile(widget.onUpdateCallback, comment));
    }
    return tile;
  }

  // Actually builds the widget as described in the class description
  @override
  Widget build(BuildContext context) {
    // Sort comments chronologically
    print("Comments List: ${_comments}");
    print("Empty? ${_comments.isEmpty}");
    print("Size? ${_comments.length}");
    if (_comments.isEmpty) {
      return Padding(
          padding: EdgeInsets.all(20),
          child: Text("No Comments", style: TextStyle(fontSize: 18)));
    }
    return Column(
      children: getCommentWidgetList(),
    );
  }
}
