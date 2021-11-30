import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {
  const PostTile({
    required this.image,
    required this.title,
    required this.author,
    required this.viewCount,
    Key? key,
  }) : super(key: key);

  final Image image;
  final String title;
  final String author;
  final int viewCount;

  @override
  Widget build(BuildContext context) {
    print({title});
    print({author});

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            author,
            maxLines: 1,
            overflow: TextOverflow.fade,
          ),
          image
        ],
      ),
    );
  }
}
