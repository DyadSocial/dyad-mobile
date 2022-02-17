import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:dyadapp/src/utils/theme_model.dart';

class PostBar extends StatelessWidget {
  const PostBar(
    this.profilePicture,
    this.author,
    this.title,
    this.datetime, {
    Key? key,
  }) : super(key: key);

  final ImageProvider<Object>? profilePicture;
  final String title;
  final String author;
  final DateTime datetime;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CircleAvatar(
                foregroundImage: profilePicture,
                backgroundColor: Colors.white70,
                foregroundColor: Colors.black12,
                child: Text(author.substring(0, min(4, author.length))),
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
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF555555),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(author, style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              timeago.format(
                datetime,
                locale: 'en_short',
              ),
            ),
          ),
        ],
      );
    });
  }
}
