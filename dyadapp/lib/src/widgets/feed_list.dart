import 'package:flutter/material.dart';
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
        itemBuilder: (context, index) => ListTile(
          title: Text(
            posts[index].title,
          ),
          subtitle: Text(
            posts[index].author.username,
          ),
          onTap: onTap != null ? () => onTap!(posts[index]) : null,
        ),
      );
}
