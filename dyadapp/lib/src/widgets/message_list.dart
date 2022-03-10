import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/pages/message_page.dart';

class MessageList extends StatefulWidget {
  String name;
  String text;
  Future<ImageProvider<Object>?> profilePicture;
  String time;
  bool isMessageRead;
  MessageList(
      {required this.name,
      required this.text,
      required this.profilePicture,
      required this.time,
      required this.isMessageRead});
  @override
  _MessageListState createState() => _MessageListState();
}


class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessagePage(
                profilePicture: widget.profilePicture,
                nickname: widget.name,
              ),
            ));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  FutureBuilder <ImageProvider?>(
                    future: widget.profilePicture,
                    builder: (BuildContext context, AsyncSnapshot<ImageProvider?> image) {
                        return CircleAvatar(
                            backgroundImage: image.data,
                            foregroundColor: Colors.black12,
                            backgroundColor: Colors.white70,
                            maxRadius: 30,
                            child: Text(widget.name.substring(0, min(4, widget.name.length)))
                          );
                      }
                    ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.name,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.text,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: widget.isMessageRead
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.time,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: widget.isMessageRead
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
