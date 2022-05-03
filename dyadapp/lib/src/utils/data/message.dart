// Author: Vincent
// Simple class representing expected JSON response
// Allows for fromJson and toJson methods to handle network request.

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
      this.author,
      this.recipient,
      this.content,
      this.timestamp.toString(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'author': author,
        'recipient': recipient,
        'content': content,
        'timestamp': timestamp
      };

  static Message fromJson(Map<String, dynamic> json) => Message(
        json['author'],
        json['recipient'],
        json['content'],
        json['timestamp'],
      );
}
