import 'group.dart';
import 'user.dart';
import 'post.dart';

final postCacheInstance = PostCache()
  ..addPost(
    post: Post(
      'Hello World',
      'This is some good content chat',
      groupInstance.allUsers.firstWhere((user) => user.username == 'vncp'),
      DateTime(2017, 9, 7, 17, 30),
    ),
  )
  ..addPost(
    post: Post(
      "Y'all want free samples?",
      'What up boyyos',
      groupInstance.allUsers.firstWhere((user) => user.username == 'infuhnit'),
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
