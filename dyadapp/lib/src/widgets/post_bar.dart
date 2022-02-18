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
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: CircleAvatar(
                  radius: 50,
                  foregroundImage: profilePicture,
                  backgroundColor: Colors.white70,
                  foregroundColor: Colors.black12,
                  child: Text(author.substring(0, min(4, author.length))),
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Container(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: themeNotifier.isDark
                            ? Color(0xFFECEFF4)
                            : Color(0xFF555555),
                      ),
                    ),
                    Text(author,
                        style: TextStyle(
                            fontSize: 16,
                            color: themeNotifier.isDark
                                ? Color(0xFFD8DEE9)
                                : Color(0xFF6A808F))),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                timeago.format(
                  datetime,
                  locale: 'en_short',
                ),
                style: const TextStyle(color: Color(0xFF6A808F), fontSize: 14),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      );
    });
  }
}
