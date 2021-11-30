import 'package:flutter/material.dart';

class PostBar extends StatelessWidget {
  const PostBar({
    required this.profilePicture,
    required this.author,
    required this.title,
    Key? key,
  }) : super(key: key);

  final ImageProvider<Object> profilePicture;
  final String title;
  final String author;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CircleAvatar(
              backgroundImage: profilePicture,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(author),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(title),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
