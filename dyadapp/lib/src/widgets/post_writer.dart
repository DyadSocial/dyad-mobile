import 'package:flutter/material.dart';

class PostWriter extends StatefulWidget {
  final Function() closeWriterCallback;

  PostWriter(
    closeWriterCallback, {
    Key? key,
  })  : this.closeWriterCallback = closeWriterCallback,
        super(key: key);

  @override
  _PostWriterState createState() => _PostWriterState();
}

class _PostWriterState extends State<PostWriter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFF9A9A9A),
            ),
          ),
        ),
        child: Container(
          color: Color(0xFFE8EDF1),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Body'),
                    minLines: 2,
                    maxLines: 10,
                  ),
                ),
                Container(
                  height: 36,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.expand_less),
                        onPressed: () => {widget.closeWriterCallback()},
                      ),
                      Icon(Icons.photo_camera),
                      Icon(Icons.collections),
                      Icon(Icons.send),
                    ],
                  ),
                ),
              ]),
        ),
      );
}
