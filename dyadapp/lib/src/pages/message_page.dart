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
import 'package:dyadapp/src/utils/database_handler.dart';
import 'package:dyadapp/src/utils/api_provider.dart';

//MessagePage is the page the user is brought to if they want to see the private messages between themselves and another user
class MessagePage extends StatefulWidget {
  ImageProvider<Object>? profilePicture;
  String nickname;
  String chat_id;
  List<Message> messages = [];

  MessagePage({Key? key, required this.profilePicture, required this.nickname, required this.chat_id})
      : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  var channel;
  var latestID;
  final _msgController = TextEditingController();
  var username;

  @override
  void initState() {
    //Connect to the websocket for responsive messaging
    channel = WebSocketChannel.connect(
        Uri.parse('ws://74.207.251.32:8000/ws/chat/' + widget.chat_id + '/')
    );
    latestID = "";
    getLatestMessages();
    super.initState();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

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
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 6,
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
          Container(padding: EdgeInsets.only(bottom: 36), child: buildMessages(widget.nickname),),
          //Streambuilder grabs latest message from the websocket, then rebuilds the widget of messages after adding to local cache of messages
          StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot){
                if (snapshot.hasData) {
                  var jsonString = json.decode(snapshot.data.toString());
                  Future.delayed(Duration.zero, () async {
                    setState(() {
                      latestID = jsonString['message_id'] + 1;
                      latestID = latestID.toString();
                    });
                  });
                  Message msg = Message(content: jsonString['message'], author: jsonString['author'], id: jsonString['message_id'].toString(), lastUpdated: Timestamp.fromDateTime(DateTime.parse(jsonString['timestamp'])));
                  DatabaseHandler().insertMessage(msg, widget.chat_id);
                  setMessages();
                }
                return Text("");
              }
          ),
          //Begin view of bottom bar for sending message
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 50,
              width: double.infinity,
              color: Colors.white,
              child: Row(

                children: <Widget>[
                  GestureDetector(
                    //Media functionality not yet added.
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
                    child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
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
                  //This is the send button, should add to local cache/db and also send to the websocket
                  FloatingActionButton(
                    onPressed: () async {
                      //Make a message object to be saved to local database
                      print(latestID + 'ID TEST');
                      Message message = Message(id: latestID, author: username, content: _msgController.value.text, lastUpdated: Timestamp.fromDateTime(DateTime.now().toUtc()), created: null, image: null);
                      DatabaseHandler().insertMessage(message, widget.chat_id);
                      List<String> tempRecList = [];
                      //Put recipients in alphabetical order
                      tempRecList.add(username);
                      tempRecList.add(widget.nickname);
                      tempRecList.sort();
                      Chat newChat = Chat(recipients: [], messages: []);
                      for(var recipient in tempRecList){
                        newChat.recipients.add(recipient);
                      }
                      //Send to websocket so other user can get message too
                      var jsonString = {
                        'roomname': widget.chat_id,
                        'username': username,
                        'recipients': newChat.recipients,
                        'message': _msgController.value.text,
                        'command': 'new_message',
                      };
                      channel.sink.add(jsonEncode(jsonString));
                      final messageList = await DatabaseHandler().getMessages(widget.chat_id);
                      setState((){
                        widget.messages = messageList;
                      });
                      //Clear text controller and reset keyboard
                      _msgController.clear();
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

  //Helper function for adding to local database and finding out what the latestID will be
  addToMessages(List<Message> messageList) async
  {
    if(messageList != []){
      for (var message in messageList) {
        DatabaseHandler().insertMessage(message, widget.chat_id);
      }
    }
    //Get new set of messages after adding to db
    final messagelist = await DatabaseHandler().getMessages(widget.chat_id);
    if(messageList != []){
      var temp = int.parse(messageList[0].id);
      print("TEMP: " + temp.toString());
      temp = temp + 1;
      var latest = temp.toString();
      var user = await UserSession().get("username");
      setState((){
        username = user;
        widget.messages = messagelist;
        latestID = latest;
      });
    }
  }

//Function to grab 10 messages from api endpoint
  getLatestMessages() async
  {
    final response = await APIProvider.fetchMessages({'chatid': widget.chat_id, 'command': "10"});
    List<Message> messageList = [];
    if (response['status'] == 200) {
      //List of obj
      var res = json.decode(response['body']);
      for(var msg in res){
        String msg_id = msg['message_id'].toString();
        Message message = Message(id: msg_id, content: msg['content'], author: msg['author_name'], lastUpdated: Timestamp.fromDateTime(DateTime.parse(msg['timestamp'])));
        messageList.add(message);
      }
    }
    else{
      print("TIMEOUT EXCEPTION: MESSAGES");
    }
    addToMessages(messageList);
  }

  //Get the latest messages from the local cache. Call whenever we get something from streambuilder or websocket
  setMessages() async{
    List<Message> messageList = await DatabaseHandler().getMessages(widget.chat_id);
    messageList.sort((a, b) {
      if (a.lastUpdated.seconds < b.lastUpdated.seconds) {
        return -1;
      } else if (a.lastUpdated.seconds == b.lastUpdated.seconds) {
        return 0;
      } else {
        return 1;
      }
    });

    setState(() {
      widget.messages = messageList;
    });
  }


  //Method for rendering list of messages using ListViewBuilder.
  buildMessages(String sender){
    //Reverse the list as it starts from the bottom.
    return ListView.builder(

      itemCount: widget.messages.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      physics: BouncingScrollPhysics(),
      reverse: true,
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
                  color: Colors.grey.shade500,
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
                  color: Colors.blue.shade200,
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
