import 'dart:math';
import 'package:dyadapp/src/data.dart';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/pages/message_page.dart';
import 'package:dyadapp/src/utils/data/protos/messages.pb.dart';

class MessageListEntry extends StatefulWidget {
  String name;
  String text;
  ImageProvider<Object>? profilePicture;
  String time;
  bool isMessageRead;
  List<Message> messages;

  MessageListEntry(
      {required this.name,
      required this.text,
      required this.profilePicture,
      required this.time,
      required this.isMessageRead,
      required this.messages});
  @override
  _MessageListEntryState createState() => _MessageListEntryState();
}

class _MessageListEntryState extends State<MessageListEntry> {
  @override
  Widget build(BuildContext context) {
    print("Message list received: " + widget.name);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessagePage(
                profilePicture: widget.profilePicture,
                nickname: widget.name,
                //In the future, grab the messages between current user and then widget.name
                //This is for demo purposes
                messages: widget.messages,
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
                  CircleAvatar(
                      backgroundImage: widget.profilePicture,
                      foregroundColor: Colors.black12,
                      backgroundColor: Colors.white70,
                      maxRadius: 30,
                      child: Text(widget.name
                          .substring(0, min(4, widget.name.length)))),
                  /*
                  FutureBuilder<ImageProvider?>(
                      future: widget.profilePicture,
                      builder: (BuildContext context,
                          AsyncSnapshot<ImageProvider?> image) {
                        return CircleAvatar(
                            backgroundImage: image.data,
                            foregroundColor: Colors.black12,
                            backgroundColor: Colors.white70,
                            maxRadius: 30,
                            child: Text(widget.name
                                .substring(0, min(4, widget.name.length))));
                      }),
                   */
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