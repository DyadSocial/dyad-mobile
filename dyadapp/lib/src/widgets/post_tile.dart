import 'package:flutter/material.dart';
import './post_bar.dart';

class PostTile extends StatelessWidget {
  const PostTile({
    required this.profilePicture,
    required this.title,
    required this.author,
    required this.content,
    this.image,
    Key? key,
  }) : super(key: key);

  final ImageProvider<Object> profilePicture;
  final String title;
  final String author;
  final String content;
  final Image? image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PostBar(
            title: title,
            author: author,
            profilePicture: profilePicture,
          ),
          Center(child: image ?? Text(content)),
        ],
      ),
    );
  }
}
