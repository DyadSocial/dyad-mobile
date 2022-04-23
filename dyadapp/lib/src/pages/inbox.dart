import 'dart:async';
import 'dart:convert';
import 'package:dyadapp/src/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dyadapp/src/widgets/message_list_entry.dart';
import 'package:dyadapp/src/utils/data/test_message.dart';
import 'package:dyadapp/src/utils/data/protos/messages.pb.dart';
import 'package:dyadapp/src/utils/database_handler.dart';
import 'package:dyadapp/src/utils/network_handler.dart';
import 'package:dyadapp/src/utils/data/protos/google/protobuf/timestamp.pb.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:dyadapp/src/utils/api_provider.dart';
import '../utils/data/group.dart';

Chat chattest = Chat(recipients: ["infuhnit", "goobygrooves"], messages: []);

class InboxPage extends StatefulWidget {
  InboxPage({Key? key}) : super(key: key);

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage>
    with SingleTickerProviderStateMixin {
  final _toController = TextEditingController();
  final _msgController = TextEditingController();
  var username;
  //Will hold the list of chats that the user is apart of from api endpoint
  List<Chat> _chats = [];
  List<ImageProvider> profilePictures = [];
  var latestID;
  var latestMessage;



  @override
  void initState() {
    getUser();
    getChats();
    super.initState();
    /*for (var chat in _chats) {
      if (chat.messages.length > 0) {
        _messages.add(chat.messages[0]);
      } else {
        _messages.add(Message(id: "", author: "", content: ""));
      }
    }*/
  }

  getUser() async{
    //print(username);
  }

  getChats() async{
    //get username
    var user = await UserSession().get("username");
    setState(() {
      username = user;
    });
    //print(username);
    final response = await APIProvider.fetchChats({'username': username});
    if (response['status'] == 200) {
      //List of obj
      var res = json.decode(response['body']);
      //print(res);
      //Go through every chat
      for(var msg in res){
        var participants = new List<String>.from(msg['participants']);
        //print(participants);
        Chat tempchat = Chat(recipients: participants, messages: []);
        //print(tempchat);
         setState(() {
           _chats.add(tempchat);
         });
      }
    }
    else{
      print("TIMEOUT : CHATS");
    }

    //get chats that user is a part of from api endpoint
  }

  getLatestMessage(String chatid) async{
    //Put chatid in here once its figured out
    List<Message> messageList = await DatabaseHandler().getMessages(chatid);
    if(messageList.length>0){
      setState(() {
        latestMessage = messageList[messageList.length-1];
      });
    }
    else{
      return "test";
    }
  }

//grab ten latest messages
  getLatestMessages(String chatid) async
  {
    //Put in chatid once we figure it out
    final response = await APIProvider.fetchMessages({'chatid': chatid});
    List<Message> messageList = [];
    if (response['status'] == 200) {
      //List of obj
      var res = json.decode(response['body']);
      for(var msg in res){
        String msg_id = msg['message_id'].toString();
        Message message = Message(id: msg_id, content: msg['content'], author: msg['author_name'], lastUpdated: null);
        messageList.add(message);
      }
      return messageList;
    }
    else{
      print("TIMEOUT EXCEPTION : MESSAGES");
      return [];
    }
  }

  //The chatID will be a concatenation of all recipients usernames in alphabetical order, like goobygroovesprimchi or infuhnitvncp
  getChatId(Chat chat){
    //print(chat.recipients);
    List<String> chatIdList = [];
    for(var recipient in chat.recipients){
      chatIdList.add(recipient);
    }
    chatIdList.sort();
    String chatID = "";
    for(var user in chatIdList){
      chatID = chatID + user;
    }
    return chatID;
  }

  //TO DO: Helper function for profile picture
  //Image provider = (Image.memory(await runPullProfileImage(message[index].author))).image;
  Future<ImageProvider<Object>?> getProfilePicture(Chat chat) async {
    String current_user = await UserSession().get("username");
    for (var recipient in chat.recipients) {
      if (recipient != current_user) {
        return Image.network(
                "https://th.bing.com/th/id/OIP.Nen6j3vBZdl8g8kzNfoEHQAAAA?pid=ImgDet&rs=1")
            .image;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Dyad')),
        leading: Text(" "),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => {
              Navigator.of(context).push<void>(MaterialPageRoute<void>(
                  builder: (context) =>
                      const SettingsScreen())) //Changed temporarily for inbox screen from SettingsScreen()
            },
            tooltip: 'About Dyad',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SafeArea(
                    child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Messages",
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 4, right: 4),
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey,
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.add,
                              color: Colors.blueGrey,
                              size: 20,
                            ),
                            //The new button brings up an alert dialog to send a message to someone
                            TextButton(onPressed: ()=>{
                              showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    insetPadding: EdgeInsets.all(8.0),
                                    content: Stack(
                                      children: <Widget>[
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(5.0),
                                              height: 50,
                                              width: 200,
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                  icon: Icon(Icons.person),
                                                  hintText: 'To who?',
                                                ),
                                                keyboardType: TextInputType.text,
                                                controller: _toController,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(5.0),
                                              height: 50,
                                              width: 200,
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                  icon: Icon(Icons.edit),
                                                  hintText: 'Message',
                                                ),
                                                keyboardType: TextInputType.multiline,
                                                controller: _msgController,
                                              ),
                                            ),
                                            SizedBox(height: 50),
                                            TextButton(onPressed: () async {
                                              //For id, first check if a chat exists, if it doesn't create a new message in a new chatroom. If it exists
                                              //open the websocket connection and add in using latest_id.
                                              //Would help if sam could send the chats with their latest message?
                                              for(var chat in _chats){
                                                //Already exists; add to websocket
                                                if(chat.recipients.contains(username) && chat.recipients.contains(_toController.value.text)){
                                                  final channel = WebSocketChannel.connect(
                                                    //put in chatid once we figure it out
                                                      Uri.parse('ws://74.207.251.32:8000/ws/chat/' + getChatId(chat) + '/')
                                                  );
                                                  var jsonString = {
                                                    'roomname': getChatId(chat),
                                                    'username': username,
                                                    'message': _msgController.value.text,
                                                    'command': 'new_message',
                                                  };

                                                  channel.sink.add(jsonEncode(jsonString));
                                                  print(channel.stream.last);
                                                  channel.sink.close();

                                                  //Get latest ID from 10 chats or if sam sends back latest message in chat
                                                  //Used for getting the latestID in a chat to display as an entry
                                                  //Problem may arise from getting id like this, maybe have an id
                                                  List<Message> _tenLatestMessages = getLatestMessages(getChatId(chat));
                                                  var temp = int.parse(_tenLatestMessages[0].id);
                                                  temp = temp + 1;
                                                  latestID = temp.toString();
                                                  Message message = Message(
                                                      id: latestID,
                                                      author: username,
                                                      content: _msgController.value.text,
                                                      lastUpdated: Timestamp.fromDateTime(DateTime.now().toUtc()),
                                                      created: null,
                                                      image: null);
                                                  //Put in chatid once we figure it out
                                                  DatabaseHandler().insertMessage(message, getChatId(chat));
                                                  //Send to websocket so other user can get message too
                                                }
                                              }
                                              //Make a new chat object with new chat
                                              List<String> tempRecList = [];
                                              //Put recipients in alphabetical order
                                              tempRecList.add(username);
                                              tempRecList.add(_toController.value.text);
                                              tempRecList.sort();
                                              Chat newChat = Chat(recipients: [], messages: []);
                                              for(var recipient in tempRecList){
                                                newChat.recipients.add(recipient);
                                              }
                                              //If it is a new chat and doesn't already exist; getChats one more time
                                              getChats();
                                              if(!_chats.contains(newChat)){
                                                  //_chats.add(newChat);
                                                  final channel = WebSocketChannel.connect(
                                                    //put in chatid once we figure it out
                                                      Uri.parse('ws://74.207.251.32:8000/ws/chat/' + getChatId(newChat) + '/')
                                                  );
                                                  //Send to websocket so other user can get message too
                                                  var jsonString = {
                                                    'roomname': getChatId(newChat),
                                                    'username': username,
                                                    'message': _msgController.value.text,
                                                    'command': 'new_message',
                                                  };
                                                  channel.sink.add(jsonEncode(jsonString));
                                                  print(await channel.stream.last);
                                                  channel.sink.close();
                                                  //LatestID should be 1 because its a new chatroom
                                                  latestID = "1";
                                                  Message message = Message(
                                                      id: latestID,
                                                      author: username,
                                                      content: _msgController.value.text,
                                                      lastUpdated: Timestamp.fromDateTime(DateTime.now().toUtc()),
                                                      created: null,
                                                      image: null);
                                                  //Chatid for inserting into database can be like currentuser-touser?
                                                  //put in chatid once we figure it out
                                                  DatabaseHandler().insertMessage(message, getChatId(newChat));
                                              }
                                              Navigator.pop(context);
                                            }, child: Text("SEND"))
                                          ],
                                        )
                                      ]
                                    ),
                                    title: Text('Send a new message'),
                                  );
                                }
                              )
                            }, child: Text("New")),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
                //Search button does not work yet; Possibly implement?
                /*Padding(
                  padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search...",
                      hintStyle: TextStyle(color: Colors.grey.shade800),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey.shade100)),
                    ),
                  ),
                ),*/
                //Listview builder builds a inbox full of the latest message between the user and others

                ListView.builder(
                  itemCount: _chats.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 16),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {

                    //Get the latestmessage in that chat; had to edit out for video but make sure to get it done by demo
                    getLatestMessage(getChatId(_chats[index]));
                    //Message list entry shows the first message from every chat, initialized in initState()
                    return MessageListEntry(
                      name: _chats[index].recipients.firstWhere((element) => element != username),
                      //first message here
                      text: latestMessage.content,
                      //TO DO:
                      profilePicture: groupInstance
                              .getUser(_chats[index].recipients.firstWhere((element) => element != username && element != 'test123', orElse: ()=> 'infuhnit'))
                              ?.profilePicture ??
                          null,
                      time: timeago.format(
                          DateTime.fromMillisecondsSinceEpoch(
                              (Timestamp.fromDateTime(DateTime.utc(2022, 4, 21, 12, 30)).seconds * 1000)
                                  .toInt()),
                          locale: 'en_short'),
                      isMessageRead: false,
                      //Put chatid in here once its figured out
                      chat_id: getChatId(_chats[index]),//(index == 0 || index == 3) ? true : false,
                    );
                  },
                ),
              ],
            )),
      ),
    );
  }
}
