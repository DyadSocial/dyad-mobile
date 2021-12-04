import 'package:flutter/material.dart';
import 'package:dyadapp/src/utils/data/group.dart';
import 'package:dyadapp/src/utils/data/user.dart';
import 'package:dyadapp/src/utils/data/post.dart';

final postCacheInstance = PostCache()
  ..addPost(
    post: Post(
      'Hello World',
      'This is some good content chat',
      Image.asset(
        'assets/images/vincent.png',
        fit: BoxFit.fitWidth,
        alignment: Alignment.center,
      ),
      'vncp',
      DateTime(2017, 9, 7, 17, 30),
    ),
  )
  ..addPost(
    post: Post(
      "Y'all want free sampless?",
      'What up boyyos',
      Image.asset(
        'assets/images/jake.JPG',
        fit: BoxFit.fitWidth,
        alignment: FractionalOffset.topCenter,
      ),
      'infuhnit',
      DateTime(2021, 10, 2, 1, 24),
    ),
  )
  ..addPost(
    post: Post(
      "Music Drop",
      'Check out hot fresh single',
      Image.asset(
        'assets/images/sam.png',
        fit: BoxFit.fitWidth,
        alignment: FractionalOffset.topCenter,
      ),
      'wavy_gooby',
      DateTime(2021, 10, 2, 1, 24),
    ),
  );

class PostCache {
  final List<Post> allPosts = [];
  final List<String> allUsers = [];

  void addPost({
    required Post post,
  }) {
    allPosts.add(post);
  }
}
