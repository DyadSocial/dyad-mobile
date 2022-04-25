import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dyadapp/src/data.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:dyadapp/src/utils/theme_model.dart';
import 'package:dyadapp/src/utils/data/protos/posts.pb.dart';

// Widget that shows a single comment thread
class CommentTile extends StatefulWidget {
  final Future<void> Function(CommentThread) onUpdateCallback;
  final Future<void> Function(int) replyCommentCallback;
  final CommentThread commentThread;
  final String currentUser;

  const CommentTile(this.onUpdateCallback, this.commentThread, this.currentUser,
      this.replyCommentCallback,
      {Key? key})
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
  late String currentUser;
  late bool _showReplies;
  late bool _collapsed;

  @override
  void initState() {
    Timestamp x;
    super.initState();
    this._showReplies = false;
    this.commentThread = widget.commentThread;
    this.currentUser = widget.currentUser;
    this._collapsed = false;
  }

  @override
  Widget build(BuildContext context) {
    // We need to returna  consumer of theme notifier in order to change the
    // colors depending on whether we are in light or dark mode
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(children: [
            SizedBox(
              height: 50,
              child: TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Text(
                        commentThread.author,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFC1C6CE),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                          timeago.format(
                              DateTime.fromMillisecondsSinceEpoch(
                                (commentThread.lastUpdated.seconds * 1000)
                                    .toInt(),
                              ),
                              locale: 'en_short'),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFA8ACB3))),
                    ]),
                    // Show snippet of text if thread is collapsed
                    Visibility(
                      visible: _collapsed,
                      child: SizedBox(
                        width: 80,
                        child: Text(commentThread.text, style: TextStyle(
                          color: Color(0xFFC1C6CE)
                        ), textAlign: TextAlign.start, overflow: TextOverflow.ellipsis),
                      ),

                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Comment Thread Expansion BUtton
                        TextButton(
                          child: Row(
                            children: [
                              Icon(Icons.comment,
                                  color: Color(0xFFC1C6CE), size: 18),
                              SizedBox(width: 5),
                              Text(commentThread.replies.length.toString(),
                                  style: TextStyle(color: Color(0xFFC1C6CE)))
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              this._showReplies = !this._showReplies;
                            });
                          },
                        ),
                        // Reply Button
                        TextButton(
                          child: Row(
                            children: [
                              Icon(Icons.reply,
                                  color: Color(0xFFC1C6CE), size: 18),
                              SizedBox(width: 5),
                              Text("Reply",
                                  style: TextStyle(
                                      color: Color(0xFFC1C6CE), fontSize: 12))
                            ],
                          ),
                          onPressed: () {
                            widget.replyCommentCallback(commentThread.id);
                          },
                        ),
                        PopupMenuButton(
                          icon: Icon(Icons.more_vert,
                              color: Color(0xFFC1C6CE), size: 20),
                          onSelected: (value) {
                            if (value == 1) {
                              // TODO: Call deleteCommentCallback
                            } else if (value == 0) {
                              // TODO: Call updateCommentCallback
                            } else if (value == 2) {
                              // TODO: Call reportCommentCallback
                            }
                          },
                          itemBuilder: (context) => currentUser ==
                                  commentThread.author
                              ? [
                                  PopupMenuItem(child: Text("Edit"), value: 0),
                                  PopupMenuItem(
                                      child: Text("Delete"), value: 1),
                                  PopupMenuItem(child: Text("Report"), value: 2)
                                ]
                              : [
                                  PopupMenuItem(child: Text("Report"), value: 2)
                                ],
                        ),
                      ],
                    )
                  ],
                ),
                onPressed: () => {
                  this.setState(() {
                    this._collapsed = !this._collapsed;
                  })
                },
              ),
            ),
            Visibility(
              visible: !_collapsed,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      commentThread.text,
                      textAlign: TextAlign.left,
                    )),
              ),
            )
          ]),
        ),
        Divider(thickness: 1, height: 1),
        Visibility(
            visible:
                !_collapsed && _showReplies && commentThread.replies.length > 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 10, 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: commentThread.replies
                      .map((comment) => Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Text(
                                        comment.author,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFC1C6CE),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                          timeago.format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                (comment.lastUpdated.seconds *
                                                        1000)
                                                    .toInt(),
                                              ),
                                              locale: 'en_short'),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFFA8ACB3))),
                                    ]),
                                    PopupMenuButton(
                                      icon: Icon(Icons.more_vert,
                                          color: Color(0xFFC1C6CE), size: 20),
                                      onSelected: (value) {
                                        if (value == 1) {
                                          // TODO: Call deleteCommentCallback
                                        } else if (value == 0) {
                                          // TODO: Call updateCommentCallback
                                        } else if (value == 2) {
                                          // TODO: Call reportCommentCallback
                                        }
                                      },
                                      itemBuilder: (context) =>
                                          currentUser == commentThread.author
                                              ? [
                                                  PopupMenuItem(
                                                      child: Text("Edit"),
                                                      value: 0),
                                                  PopupMenuItem(
                                                      child: Text("Delete"),
                                                      value: 1),
                                                  PopupMenuItem(
                                                      child: Text("Report"),
                                                      value: 2)
                                                ]
                                              : [
                                                  PopupMenuItem(
                                                      child: Text("Report"),
                                                      value: 2)
                                                ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    comment.text,
                                    textAlign: TextAlign.start,
                                  )),
                              SizedBox(height: 20),
                              Divider(thickness: 1, height: 1)
                            ],
                          ))
                      .toList()),
            )),
      ],
    );
  }
}
