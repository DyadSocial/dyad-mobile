import 'user.dart';
import 'package:quiver/core.dart';

class Message {
  late final int id;
  final User author;
  final User recipient;
  final String content;
  final DateTime timestamp;

  Message(this.author, this.recipient, this.content, this.timestamp) {
    hash4(
      this.author.id,
      this.recipient.id,
      this.content,
      this.timestamp.toString(),
    );
  }
}
