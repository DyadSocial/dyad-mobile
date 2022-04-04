import 'dart:typed_data';
import 'dart:io';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/data.dart';
import 'package:dyadapp/src/pages/settings.dart';
import 'package:dyadapp/src/widgets/post_bar.dart';
import 'package:dyadapp/src/utils/data/protos/content.pb.dart';

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
  late TextEditingController _editingController;

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
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
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
    return Column(
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
          padding: const EdgeInsets.all(10),
          child: _editPostContentField(),
        ),
        Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(),
              ),
            ),
            child: Visibility(
              visible: _post.content.hasImage(),
              child: Image.file(File(_post.content.image)),
            )),
      ],
    );
  }
}
