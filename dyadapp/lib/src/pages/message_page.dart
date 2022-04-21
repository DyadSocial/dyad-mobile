import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:flutter/material.dart';
import 'package:dyadapp/src/utils/data/protos/messages.pb.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:dyadapp/src/utils/data/protos/google/protobuf/timestamp.pb.dart';
import 'package:timeago/timeago.dart' as timeago;

//MessagePage is the page the user is brought to if they want to see the private messages between themselves and another user
class MessagePage extends StatefulWidget {
  ImageProvider<Object>? profilePicture;
  String nickname;
  //As mentioned in message_list_entry, might just want to pass in a Chat object to this page which can then render instead of a list of messages
  Chat chat;
  List<Message> messages = [Message(
  id: "1",
  author: "goobygrooves",
  content: "I like to make music",
  lastUpdated: Timestamp.fromDateTime(DateTime.utc(2022, 4, 21, 12, 30)))];

  MessagePage({Key? key, required this.profilePicture, required this.nickname, required this.chat})
      : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final channel = WebSocketChannel.connect(
  Uri.parse('ws://74.207.251.32:8000/ws/chat/testroom/')
);
  late Stream broadCast;
  //late Timer refresh;
  final _msgController = TextEditingController();


  //List<Message> messages = []; //get last 10 messages from backend database 
  @override
  void initState() {
    broadCast = channel.stream.asBroadcastStream();
    //getMessages();
    //refresh = Timer.periodic(Duration(seconds: 5), (timer) {
    //  setState(() {
        
    //  });
    //});
    super.initState();
    
  }

@override
void dispose() {
  channel.sink.close();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    //getMessages();
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
      body: 
      Stack(
        children: <Widget>[
        //Build messages will display a list view of the messages between current user and other
          buildMessages(widget.nickname),
    //       StreamBuilder(
    //         stream: channel.stream,
    //         builder: (context, snapshot) {
    //       return Text(snapshot.hasData ? '${snapshot.data}' : 'x');
    //     }
    //  ),
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
                    child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        icon: Icon(Icons.edit),
                        iconColor: Colors.grey,
                        hintText: 'Write a message...',
                        hintStyle: TextStyle(color:Colors.grey),
                      ),
                      keyboardType: TextInputType.multiline,
                      controller: _msgController,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  //Send button is where you would POST to the server and rerender
                  FloatingActionButton(
                    onPressed: () async {
                      Message message = Message(author: await UserSession().get("user"), content: _msgController.value.text, lastUpdated: null, created: null, image: null);
                      _msgController.clear();
                      setState(() {
                        widget.messages.add(message);
                      });
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
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

  addToMessages(var messageList)
  {
    setState(() {
      var i = 0;
      for (var msg in messageList) {
        widget.messages.add(Message(author: msg['author'], id: i.toString(), content: msg['content'], lastUpdated: null, created: null, image: false));
        i++;
      }
    });
    print("LENGTH " + widget.messages.length.toString());
  }

  getMessages()
  {
    var command = {
      "message": "aaaa",
      "command": "fetch_messages",
      "roomname": "testroom", //widget.chat.id,
      "username" : "test123"
    };
    
    var jsonString = json.encode(command);
    channel.sink.add(jsonString);
    print("added to sink");

    broadCast.listen((event) {
      var messagelist = jsonDecode(event)['message'] as List;
      addToMessages(messagelist); 
      print("listening");
    });
  }
  

  //Method for rendering list of messages using ListViewBuilder.
  buildMessages(String sender) {
    return ListView.builder(
      itemCount: widget.messages.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      physics: ClampingScrollPhysics(),
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
