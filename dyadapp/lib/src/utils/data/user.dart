import 'package:dyadapp/src/utils/data/post.dart';
import 'package:flutter/material.dart';

class User {
  late final int id;
  final String username;
  final String nickname;
  final ImageProvider<Object> profilePicture;
  final String biography;
  final List<Post> posts = <Post>[];

  User(this.username, this.nickname, this.biography, this.profilePicture)
      : this.id = username.hashCode;
}
