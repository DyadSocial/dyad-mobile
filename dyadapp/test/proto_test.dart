import 'dart:ffi';
import 'dart:io';

import 'package:dyadapp/src/utils/data/protos/content.pb.dart';
import 'package:dyadapp/src/utils/data/protos/messages.pb.dart';
import 'package:dyadapp/src/utils/data/protos/posts.pb.dart';

import 'package:dyadapp/src/utils/data/protos/google/protobuf/timestamp.pb.dart';
import 'package:flutter/material.dart';

Content addContent(String input, [List<int>? image]) {
  Content content = Content();
  content.text = input;
  if (image != null) content.image = image;
  return content;
}

Message addMessage(int id, String author, Content content,
    Timestamp last_updated, Timestamp created) {
  Message message = Message();
  message.id = id;
  message.author = author;
  message.content = content;
  message.lastUpdated = last_updated;
  message.created = created;
  return message;
}

Post addPost(int id, String author, Content content, Timestamp last_updated,
    Timestamp created) {
  Post post = Post();
  post.id = id;
  post.author = author;
  post.content = content;
  post.lastUpdated = last_updated;
  post.created = created;
  return post;
}

void main() {}
