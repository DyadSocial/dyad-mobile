import 'dart:io';
import 'package:test/test.dart';

import 'package:dyadapp/src/utils/data/protos/content.pb.dart';
import 'package:dyadapp/src/utils/data/protos/messages.pb.dart';
import 'package:dyadapp/src/utils/data/protos/posts.pb.dart';

import 'package:dyadapp/src/utils/data/protos/google/protobuf/timestamp.pb.dart';
import 'package:flutter/material.dart';

Content addContent(String input, [List<int>? image]) {
  Content content = Content();
  content.text = input;
  if (image != null) content.image = image as String;
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

Chat addChat(
    List<String> recipients, List<Message> messages, Timestamp last_updated) {
  Chat chat = Chat(
      recipients: recipients, messages: messages, lastUpdated: last_updated);
  return chat;
}

Feed addFeed(
    List<String> recipients, List<Post> posts, Timestamp last_updated) {
  Feed feed =
      Feed(recipients: recipients, posts: posts, lastUpdated: last_updated);
  return feed;
}

void main() {
  final int testID = 1;
  final String testAuthor = "testAuthor";
  final String testText =
      "This is a test post. We are writing to see if it will save into a file of bytes and load back into a byte stream.";
  final List<int> testImage = [0, 1, 2, 3, 4];

  late Timestamp testTimestamp;
  late Content testContent;
  late Message testMessage;
  late Post testPost;
  late Chat testChat;
  late Feed testFeed;

  setUp(() async {
    testTimestamp = await Timestamp.fromDateTime(DateTime.now());
    testContent = await addContent(testText, testImage);
    testMessage = await addMessage(
        testID, testAuthor, testContent, testTimestamp, testTimestamp);
    testPost = await addPost(
        testID, testAuthor, testContent, testTimestamp, testTimestamp);
    testChat = await addChat(
        ["Vincent", "Tido"], [testMessage, testMessage], testTimestamp);
    testFeed =
        await addFeed(["Vincent", "Tido"], [testPost, testPost], testTimestamp);
  });

  group('Content protobuf', () {
    test('.text', () {
      expect(testContent.text, equals(testText));
    });
    test('.image', () {
      expect(testContent.image, equals(testImage));
    });
    test('.writeToBuffer()/.readFromBuffer()', () async {
      File file = File('content.pb');
      await file.writeAsBytes(testContent.writeToBuffer());
      expect(new Content.fromBuffer(File('content.pb').readAsBytesSync()),
          testContent);
      file.delete();
    });
  });
  group('Message protobuf', () {
    test('.id', () {
      expect(testMessage.id, equals(testID));
    });
    test('.author', () {
      expect(testMessage.author, equals(testAuthor));
    });
    test('.content protobuf', () {
      expect(testMessage.content, equals(testContent));
    });
    test('.lastUpdated', () {
      expect(testMessage.lastUpdated, equals(testTimestamp));
    });
    test('.created', () {
      expect(testMessage.created, equals(testTimestamp));
    });
    test('.writeToBuffer()/.readFromBuffer()', () async {
      File file = File('message.pb');
      await file.writeAsBytes(testMessage.writeToBuffer());
      expect(new Message.fromBuffer(File('message.pb').readAsBytesSync()),
          testMessage);
      file.delete();
    });
  });
  group('Post protobuf', () {
    test('.id', () {
      expect(testPost.id, equals(testID));
    });
    test('.author', () {
      expect(testPost.author, equals(testAuthor));
    });
    test('.content', () {
      expect(testPost.content, equals(testContent));
    });
    test('.lastUpdated', () {
      expect(testPost.lastUpdated, equals(testTimestamp));
    });
    test('.created', () {
      expect(testPost.created, equals(testTimestamp));
    });
    test('.writeToBuffer()/.readFromBuffer()', () async {
      File file = File('post.pb');
      await file.writeAsBytes(testPost.writeToBuffer());
      expect(new Post.fromBuffer(File('post.pb').readAsBytesSync()), testPost);
      file.delete();
    });
  });
  group('Chat protobuf', () {
    test('.messages', () {
      expect(testChat.messages, [testMessage, testMessage]);
    });
  });
  group('Feed protobuf', () {
    test('.posts', () {
      expect(testFeed.posts, [testPost, testPost]);
    });
  });
}
