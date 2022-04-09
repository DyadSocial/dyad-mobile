import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/utils/data/protos/messages.pb.dart';
import 'package:dyadapp/src/utils/data/test_message.dart';
import 'package:flutter/src/widgets/framework.dart';

//MessagePage is the page the user is brought to if they want to see the private messages between themselves and another user
class MessagePage extends StatefulWidget {
  ImageProvider<Object>? profilePicture;
  String nickname;
  //As mentioned in message_list_entry, might just want to pass in a Chat object to this page which can then render instead of a list of messages
  List<Message> messages;

  MessagePage({Key? key, required this.profilePicture, required this.nickname, required this.messages})
      : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  //Commented out for demo
  //List<Message> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,

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
                      //Title top bar
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
                      //No online functionality. Maybe implement or just take out?
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
          //Build messages will display a list view of the messages between current user and other
          buildMessages(widget.nickname),
          //Begin view of bottom bar for sending message
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
                    //Needs functionality to be added. Adding media?
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
                    //Need to add a controller for this textfield, which then should append to the chat object and POST to the server. Then messages should be rendered
                    //again to show updated
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  //Send button is where you would POST to the server and rerender
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

  //Method for rendering list of messages using ListViewBuilder.
  buildMessages(String sender) {
    return ListView.builder(
      itemCount: widget.messages.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        //If the author is the other user, then the messages should be appended to the listview and display on the left
        if (widget.messages[index].author == sender) {
          return Container(
            padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade200,
                ),
                padding: EdgeInsets.all(16),
                child: Text(
                  widget.messages[index].content,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ),
          );
        } //If the author is not the other user, messages should display on the right or be appended to list view on the right
        else {
          return Container(
            padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue.shade50,
                ),
                padding: EdgeInsets.all(16),
                child: Text(
                  widget.messages[index].content,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
