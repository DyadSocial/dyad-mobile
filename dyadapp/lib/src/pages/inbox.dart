import 'dart:async';

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

import '../utils/data/group.dart';

class InboxPage extends StatefulWidget {
  InboxPage({Key? key}) : super(key: key);

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage>
    with SingleTickerProviderStateMixin {
  final _toController = TextEditingController();
  final _msgController = TextEditingController();
  List<Chat> _chats = [
    Chat(recipients: [
      "vncp",
      "primchi",
      "goobygrooves",
      "infuhnit"
    ], messages: [
      Message(
          id: "1",
          author: "goobygrooves",
          content: "I like to make music",
          lastUpdated: Timestamp.fromDateTime(DateTime.utc(2022, 3, 7, 2, 30))),
    ]),

  ];
  List<Message> _messages = [];
  List<ImageProvider> profilePictures = [];

  //Fake message list to send for demo 4-4-22
  List<Chat> _chatsDemo = [];
  List<Message> _messagesDemo = [];

  @override
  void initState() {
    super.initState();
    for (var chat in _chats) {
      if (chat.messages.length > 0) {
        _messages.add(chat.messages[0]);
      } else {
        _messages.add(Message(id: "", author: "", content: ""));
      }
    }
  }

  Future<List<Chat>> _getChatData() async {
    await DatabaseHandler().chats().then((newChats) {
      _chats = newChats;
    });
    return _chats;
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
    for(var msg in _messages){
      print("In inbox, _messages has first message from user: " + msg.author);
    }
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
                                              //Temporary for demo
                                              _chats[0].messages.add(
                                                Message(
                                                  id: "1",
                                                  author: await UserSession().get("username"),
                                                  content: _msgController.value.text,
                                                  lastUpdated: Timestamp.fromDateTime(DateTime.utc(2022, 3, 17, 2, 30))),
                                              );
                                              _messagesDemo.add(_chats[0].messages[0]);
                                              _messagesDemo.add(_chats[0].messages[1]);
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
                Padding(
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
                ),

                ListView.builder(
                  itemCount: _messages.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 16),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return MessageListEntry(
                      name: _messages[index].author,
                      text: _messages[index].content,
                      //TO DO:
                      profilePicture: groupInstance
                              .getUser(_messages[index].author)
                              ?.profilePicture ??
                          null,
                      time: timeago.format(
                          DateTime.fromMillisecondsSinceEpoch(
                              (_messages[index].lastUpdated.seconds * 1000)
                                  .toInt()),
                          locale: 'en_short'),
                      isMessageRead: false,
                      messages: _messagesDemo,//(index == 0 || index == 3) ? true : false,
                    );
                  },
                ),
              ],
            )),
      ),
    );
  }
}
