import 'post.dart';

class User {
  late final int id;
  final String username;
  final String nickname;
  final String biography;
  final List<Post> posts = <Post>[];

  User(this.username, this.nickname, this.biography)
      : this.id = username.hashCode;
}
