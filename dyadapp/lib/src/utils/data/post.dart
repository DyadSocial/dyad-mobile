import 'dart:convert';
import 'package:quiver/core.dart';
import 'package:flutter/material.dart';

class Post {
  late int id;
  String title;
  String content;
  DateTime timestamp;
  String author;
  Image? image;
  String? imageStr;

  Post(this.title, this.content, this.author, this.timestamp,
      {this.image, this.imageStr}) {
    this.id = hash4(
      this.title,
      this.content,
      this.author,
      this.timestamp.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'timestamp': timestamp.toString(),
      'author': author,
      'image': imageStr
    };
  }

  static Post fromJson(Map<String, dynamic> json) {
    return Post(json['title'], json['content'], json['author'],
        DateTime.tryParse(json['timestamp'])!,
        imageStr: json['image']);
  }

  static Image? getImage(String? base64String) {
    if (base64String == null) return null;
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }
}
