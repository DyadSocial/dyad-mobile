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
      groupInstance.allUsers.firstWhere((user) => user.username == 'vncp'),
      DateTime(2017, 9, 7, 17, 30),
    ),
  )
  ..addPost(
    post: Post(
      "Y'all want free samples?",
      'What up boyyos',
      Image.asset(
        'assets/images/jake.JPG',
        fit: BoxFit.fitWidth,
        alignment: FractionalOffset.topCenter,
      ),
      groupInstance.allUsers.firstWhere((user) => user.username == 'infuhnit'),
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
      groupInstance.allUsers
          .firstWhere((user) => user.username == 'wavy_gooby'),
      DateTime(2021, 10, 2, 1, 24),
    ),
  );

class PostCache {
  final List<Post> allPosts = [];
  final List<User> allUsers = [];

  void addPost({
    required Post post,
  }) {
    var userCandidate = allUsers.firstWhere(
      (user) => user.username == post.author.username,
      orElse: () {
        final author = User(
          post.author.username,
          post.author.nickname,
          post.author.biography,
          post.author.profilePicture,
        );
        allUsers.add(author);
        return author;
      },
    );

    userCandidate.posts.add(post);
    allPosts.add(post);
  }

  // void syncGroupPosts {}
}
