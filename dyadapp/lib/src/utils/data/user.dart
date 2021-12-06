import 'package:flutter/material.dart';

class User {
  final String username;
  final String nickname;
  final ImageProvider<Object> profilePicture;
  final String biography;
  List<int> posts = [];

  User(this.username, this.nickname, this.biography, this.profilePicture);

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
}
