import 'dart:math';
import 'dart:typed_data';
import 'dart:io';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/data.dart';
import 'package:dyadapp/src/pages/settings.dart';
import 'package:dyadapp/src/widgets/post_bar.dart';
import 'package:dyadapp/src/utils/data/protos/content.pb.dart';
import 'package:dyadapp/src/widgets/comment_list.dart';

class PostScreen extends StatefulWidget {
  final Future<Post?> Function(Post) onUpdateCallback;
  final User author;
  late Post post;
  late bool editable;

  PostScreen(
    this.onUpdateCallback,
    this.author,
    this.post,
    this.editable, {
    Key? key,
  }) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late User _author;
  late Post _post;
  late bool _isTextEditable;
  late bool _isEditingText;
  late bool _isReply;
  late TextEditingController _editingController;
  late bool _isWritingComment;
  late TextEditingController _commentEditingController;
  late int _replyId;

  Future<void> _onReplyCommentCallback(int parentId) async {
    setState(() {
      _isWritingComment = true;
      _isReply = true;
      _replyId = parentId;
    });
  }

  Future<void> _onWriteCommentCallback(String content_text, bool is_thread,
      {int? parentId}) async {
    final currentTime = Timestamp.fromDateTime(DateTime.now());
    if (is_thread) {
      int max_id = -1;
      for (var comment in _post.comments) {
        max_id = max(comment.id, max_id);
      }
      String author = await UserSession().get("username");
      CommentThread thread = CommentThread(
          id: max_id + 1,
          author: author,
          text: content_text,
          lastUpdated: currentTime,
          created: currentTime,
          parentId: _post.id);
      _post.comments.add(thread);
      widget.onUpdateCallback(_post);
    } else {
      // Deep copy parent, mutate, then replace
      CommentThread parent =
          _post.comments.firstWhere((thread) => thread.id == parentId);
      int max_id = -1;
      for (var comment in parent.replies) {
        max_id = max(comment.id, max_id);
      }
      String author = await UserSession().get("username");
      Comment reply = Comment(
          id: max_id + 1,
          author: author,
          text: content_text,
          lastUpdated: currentTime,
          created: currentTime,
          parentId: parent.id);
      parent.replies.add(reply);
      // Update Parent Thread in Thread List of Post
      for (int i = 0; i < _post.comments.length; i++) {
        if (_post.comments[i].id == parentId) {
          _post.comments[i] = parent;
        }
      }
      _isReply = false;
      widget.onUpdateCallback(_post);
    }
  }

  Future<void> checkIsEditable() async {
    _isTextEditable = await UserSession().get("username") == _author;
  }

  @override
  void initState() {
    super.initState();
    _author = widget.author;
    _post = widget.post;
    _isTextEditable = widget.editable;
    _isEditingText = false;
    _editingController = TextEditingController(text: _post.content.text);
    _isWritingComment = false;
    _commentEditingController = TextEditingController(text: "");
    _isReply = false;
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  Future<void> onUpdateCommentCallback(CommentThread commentThread) async {
    for (var i = 0; i < _post.comments.length; i++) {
      if (commentThread.id == _post.comments[i].id) {
        _post.comments[i] = commentThread;
      }
    }
    widget.onUpdateCallback(_post);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('Dyad')),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => {
                Navigator.of(context).push<void>(MaterialPageRoute<void>(
                    builder: (context) => const SettingsScreen()))
              },
            ),
          ],
        ),
        body: _buildPage());
  }

  Widget _editPostContentField() {
    if (_isTextEditable && _isEditingText) {
      return TextField(
        minLines: 1,
        maxLines: 10,
        onSubmitted: (value) async {
          _post.content.text = value;
          var new_post = await widget.onUpdateCallback(_post);
          setState(() {
            _isEditingText = false;
            if (new_post != null) {
              _post = new_post;
            }
          });
          print("Submitted");
        },
        autofocus: true,
        controller: _editingController,
      );
    }
    return InkWell(
      onTap: () {
        setState(() {
          _isEditingText = true;
        });
      },
      child: Text(_post.content.text, style: TextStyle(fontSize: 16)),
    );
  }

  Widget _buildPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          PostBar(
              _author.profilePicture,
              _author.username,
              _post.title,
              DateTime.fromMillisecondsSinceEpoch(
                  (_post.created.seconds * 1000).toInt())),
          Visibility(
            visible: _isTextEditable,
            child: Container(
                alignment: AlignmentDirectional.topEnd,
                child: IconButton(
                  icon: Icon(!_isEditingText ? Icons.mode_edit : Icons.done,
                      size: 20),
                  onPressed: () async {
                    _post.content.text = _editingController.value.text;
                    var updatedPost = await widget.onUpdateCallback(_post);
                    setState(() {
                      _isEditingText = !_isEditingText;
                      if (updatedPost != null) {
                        _post = updatedPost;
                      }
                    });
                  },
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: _editPostContentField(),
          ),
          Visibility(
            visible: _post.content.hasImage(),
            child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(),
                  ),
                ),
                child: Visibility(
                  visible: _post.content.hasImage(),
                  child: Image.file(File(_post.content.image)),
                )),
          ),
          Divider(color: Colors.white, thickness: 1),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SizedBox(
              width: double.infinity,
              child: !_isWritingComment
                  ? ElevatedButton(
                      child: Text(
                        "Add Comment",
                        style: TextStyle(color: Color(0xFFD8DEE9)),
                      ),
                      onPressed: () => {
                        setState(() {
                          _isWritingComment = !_isWritingComment;
                        })
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFF434C5E)),
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            child: Text(
                              "Cancel " + (_isReply ? "Reply" : "Comment"),
                              style: TextStyle(color: Color(0xFFD8DEE9)),
                            ),
                            onPressed: () => {
                              setState(() {
                                _isReply = false;
                                _commentEditingController.text = "";
                                _isWritingComment = !_isWritingComment;
                              })
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF434C5E)),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          flex: 1,
                          // Post Reply/Comment
                          child: ElevatedButton(
                            child: Text(
                              "Post " + (_isReply ? "Reply" : "Comment"),
                              style: TextStyle(color: Color(0xFFD8DEE9)),
                            ),
                            onPressed: () => {
                              setState(() {
                                if (!_isReply) {
                                  _onWriteCommentCallback(
                                      _commentEditingController.text, true);
                                } else {
                                  _onWriteCommentCallback(
                                      _commentEditingController.text, false,
                                      parentId: _replyId);
                                }
                                _isReply = false;
                                _commentEditingController.text = "";
                                _isWritingComment = !_isWritingComment;
                              })
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF434C5E)),
                            ),
                          ),
                        )
                      ],
                    ),
            ),
          ),
          Visibility(
            visible: _isWritingComment,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: _commentEditingController,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                      hintText: "Write your " +
                          (_isReply ? "Reply" : "Comment") +
                          " here.")),
            ),
          ),
          CommentList(
              onUpdateCommentCallback, _onReplyCommentCallback, _post.comments),
        ],
      ),
    );
  }
}
