import 'package:flutter/material.dart';

class User {
  final String username;
  final String nickname;
  final ImageProvider<Object> profilePicture;
  final String biography;

  User(this.username, this.nickname, this.biography, this.profilePicture);

  Map<String, dynamic> toMap() => <String, dynamic>{
        'username': username,
        'nickname': nickname,
        'profilePicture': profilePicture,
        'biography': biography,
      };

  static User fromMap(Map<String, dynamic> json) => User(
        json['username'],
        json['nickname'],
        json['profilePicture'],
        json['biography'],
      );
}
