import 'package:flutter/material.dart';
import './post_tile.dart';
import '../data.dart';

class FeedList extends StatelessWidget {
  final List<Post> posts;
  final ValueChanged<Post>? onTap;

  const FeedList({
    required this.posts,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) => PostTile(
          profilePicture: posts[index].author.profilePicture,
          image: posts[index].image,
          title: posts[index].title,
          author: posts[index].author.username,
          content: posts[index].content,
        ),
      );
}
