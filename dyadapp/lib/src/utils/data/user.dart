import 'package:flutter/material.dart';

class User {
  final String username;
  String? nickname;
  String? profilePicture;
  String? biography;
  List<int> posts = [];

  User(
    final this.username,
    this.nickname,
    this.biography,
    this.profilePicture,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'nickname': nickname,
        'profilePicture': profilePicture,
        'biography': biography,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        json['username'],
        json['nickname'],
        json['profilePicture'],
        json['biography'],
      );

  static User getDefault() => User(
    "unknown",
    null,
    null,
    null
  );
}
