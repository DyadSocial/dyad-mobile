import 'package:quiver/core.dart';
import 'package:flutter/material.dart';

class Post {
  late final int id;
  String title;
  String content;
  DateTime timestamp;
  String author;
  Image image;

  Post(this.title, this.content, this.image, this.author, this.timestamp) {
    this.id = hash4(
      this.title,
      this.content,
      this.author,
      this.timestamp.toString(),
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'title': title,
        'content': content,
        'timestamp': timestamp,
        'author': author,
        'image': image
      };

  static Post fromMap(Map<String, dynamic> json) => Post(
        json['title'],
        json['content'],
        json['image'],
        json['author'],
        json['timestamp'],
      );
}
