import 'package:flutter/material.dart';
import 'package:dyadapp/src/widgets/post_tile.dart';
import 'package:dyadapp/src/data.dart';

class FeedList extends StatelessWidget {
  final List<Post> posts;
  final ValueChanged<Post>? onTap;

  const FeedList({
    required this.posts,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    posts.sort((a, b) => -a.timestamp.compareTo(b.timestamp));
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) => PostTile(
          profilePicture:
              groupInstance.getUser(posts[index].author).profilePicture,
          image: Post.getImage(posts[index].imageStr),
          title: posts[index].title,
          author: posts[index].author,
          content: posts[index].content,
          datetime: posts[index].timestamp),
    );
  }
}
