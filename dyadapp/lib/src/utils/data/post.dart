import 'user.dart';
import 'package:quiver/core.dart';

class Post {
  late final int id;
  final String title;
  final String content;
  final DateTime timestamp;
  final User author;

  Post(this.title, this.content, this.author, this.timestamp) {
    this.id = hash4(
      this.title,
      this.content,
      this.author,
      this.timestamp.toString(),
    );
  }
}
