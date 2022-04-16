import 'package:flutter/material.dart';
import 'package:dyadapp/src/data.dart';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:dyadapp/src/utils/theme_model.dart';
import 'package:dyadapp/src/utils/data/protos/posts.pb.dart';

// Widget that shows a single comment thread
class CommentTile extends StatefulWidget {
  final Future<void> Function(CommentThread) onUpdateCallback;
  final CommentThread commentThread;

  const CommentTile(this.onUpdateCallback, this.commentThread, {Key? key})
      : super(key: key);

  @override
  _CommentTileState createState() => _CommentTileState();
}

// State of PostTile which has states for expanding comments in thread or hiding them
// and only shwoing the main comment.
// Also allows for callback to allow for the comment to be edited or deleted if
// held down by the current user
class _CommentTileState extends State<CommentTile> {
  late CommentThread commentThread;

  @override
  void initState() {
    super.initState();
    this.commentThread = widget.commentThread;
  }

  @override
  Widget build(BuildContext context) {
    // We need to returna  consumer of theme notifier in order to change the
    // colors depending on whether we are in light or dark mode
    return TextButton(
      child: Row(
        children: [Text("Pic"), Text(commentThread.author), Text(commentThread.text), Text("Time Ago")],
      ),
      onPressed: () => {},
    );
  }
}
