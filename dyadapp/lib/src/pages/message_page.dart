import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/utils/data/message.dart';
import 'package:dyadapp/src/utils/data/test_message.dart';
import 'package:flutter/src/widgets/framework.dart';

class MessagePage extends StatefulWidget {
  ImageProvider<Object>? profilePicture;
  String nickname;

  MessagePage({Key? key, required this.profilePicture, required this.nickname})
      : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Message> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
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
                          child: Text(widget.nickname
                              .substring(0, min(4, widget.nickname.length))));
                    }),
                 */
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.nickname,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade800, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          buildMessages(widget.nickname),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.send,
                      color: Colors.grey,
                      size: 18,
                    ),
                    backgroundColor: Colors.blueGrey,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildMessages(String sender) {
    return ListView.builder(
      itemCount: _messages.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (_messages[index].author.username == sender ||
            _messages[index].recipient.username == sender) {
          return Container(
            padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
            child: Align(
              alignment: (_messages[index].author.username == widget.nickname
                  ? Alignment.topLeft
                  : Alignment.topRight),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: (_messages[index].author.username == widget.nickname
                      ? Colors.grey.shade200
                      : Colors.blue[200]),
                ),
                padding: EdgeInsets.all(16),
                child: Text(
                  _messages[index].content,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
