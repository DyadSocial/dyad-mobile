import 'package:flutter/material.dart';
import 'package:dyadapp/src/data.dart';
import 'package:dyadapp/src/pages/settings.dart';
import 'package:dyadapp/src/widgets/post_bar.dart';
import 'package:dyadapp/src/utils/data/post.dart';
import 'package:quiver/strings.dart';

class PostScreen extends StatelessWidget {
  final User author;
  final Post post;
  PostScreen(
    this.author,
    this.post, {
    Key? key,
  }) : super(key: key);

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

  Widget _buildPage() {
    return Column(
      children: [
        PostBar(
          author.profilePicture,
          author.username,
          post.title,
          post.timestamp,
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(post.content, style: TextStyle(fontSize: 16)),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(),
            ),
          ),
          child: Visibility(
            visible: post.imageStr != null,
            child: Post.getImage(post.imageStr) ?? Text(""),
          ),
        ),
      ],
    );
  }
}
