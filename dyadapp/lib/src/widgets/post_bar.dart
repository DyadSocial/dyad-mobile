import 'package:flutter/material.dart';

class PostBar extends StatelessWidget {
  const PostBar({
    required this.profilePicture,
    required this.author,
    required this.title,
    required this.datetime,
    Key? key,
  }) : super(key: key);

  final ImageProvider<Object> profilePicture;
  final String title;
  final String author;
  final DateTime datetime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CircleAvatar(
                backgroundImage: profilePicture,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(author, style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
          Expanded(flex: 1, child: Text(datetime.toString()))
        ],
      ),
    );
  }
}
