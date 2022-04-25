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
  //As mentioned in message_list_entry, might just want to pass in a Chat object to this page which can then render instead of a list of messages
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
  ScrollController _scrollController = new ScrollController();
  var username;


  //List<Message> messages = []; //get last 10 messages from backend database 
  @override
  void initState() {
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
          Container(padding: EdgeInsets.only(bottom: 36), child: buildMessages(widget.nickname),),
          //buildMessages(widget.nickname),
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

//TO DO: grab 10 messages from api endpoint 
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

  setMessages() async{
    var messageList = await DatabaseHandler().getMessages(widget.chat_id);
    setState(() {
      widget.messages = messageList;
    });
  }


  //Method for rendering list of messages using ListViewBuilder.
  buildMessages(String sender){
    //Reverse the list as it starts from the bottom.
    var messages = new List.from(widget.messages.reversed);

    return ListView.builder(

      itemCount: messages.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      physics: BouncingScrollPhysics(),
      reverse: true,
      itemBuilder: (context, index) {

        //If the author is the other user, then the messages should be appended to the listview and display on the left
        if (messages[index].author == sender) {
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
                  messages[index].content,
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
                  messages[index].content,
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
