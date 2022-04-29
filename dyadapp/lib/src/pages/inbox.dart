import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:provider/provider.dart';

import '../utils/data/group.dart';
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
import 'package:dyadapp/src/pages/message_page.dart';
import 'package:dyadapp/src/utils/suggestive_list.dart';

/*
* The InboxPage is responsible for showing a user's conversations with others. From here, you can create a new conversation or go to existing one's to send messages.
* Individual messaging page is found in message_page.dart
* */
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
  var latestMessage = Message(
      id: "0",
      author: "temp",
      content: "temp",
      lastUpdated: Timestamp.fromDateTime(DateTime.now()));
  String buttonText = "SEND";
  var dropdownvalue;
  var suggestiveList;

  @override
  void initState() {
    getChats();
    suggestiveList = SuggestiveList.getUserList();
    removeUserFromSL();
    dropdownvalue = suggestiveList[0];
    super.initState();
  }

  //Function for removing current user from the suggestive list. Shouldn't be able to message self!
  removeUserFromSL() async {
    await Future.delayed(Duration(seconds: 1));
    suggestiveList.remove(username);
    //print(username);
  }

  //Function for getting all the chats from API endpoint the user is apart of
  getChats() async {
    //get username
    var user = await UserSession().get("username");
    setState(() {
      username = user;
    });
    //API Call
    final response = await APIProvider.fetchChats({'username': username});
    if (response['status'] == 200) {
      //List of obj
      var res = json.decode(response['body']);
      //Go through every chat (res)
      for (var msg in res) {
        var participants = new List<String>.from(msg['participants']);
        Chat tempchat = Chat(recipients: participants, messages: []);
        //Get the latest message for a specific chatroom, chatid is built from a chat object's recipients, hence use of tempchat
        final response2 = await APIProvider.fetchLatestMessage(
            {'chatid': getChatId(tempchat), 'command': "1"});
        if (response2['status'] == 200) {
          var res2 = json.decode(response2['body']);
          //Make the tempchat have the latest message of the chat
          tempchat.messages.add(Message(
              id: res2[0]['message_id'].toString(),
              author: res2[0]['author_name'],
              content: res2[0]['content'],
              lastUpdated: Timestamp.fromDateTime(
                  DateTime.parse(res2[0]['timestamp']))));
        } else {
          print('TIMEOUT EXCEPTION: GETLATESTMESSAGE');
        }
        setState(() {
          //If the chat already exists, firstWhere gets the chat object in the list of chats. If it doesn't exist, it is an empty chat object
          var existingChat = _chats.firstWhere(
              (element) => element.recipients == tempchat.recipients,
              orElse: () => Chat());
          //Means it doesn't already exist, so add tempchat to the _chats
          if (existingChat == Chat()) {
            _chats.add(tempchat);
          } else {
            var i = _chats.indexOf(existingChat);
            print(i.toString() + ' index of existing chat');
            _chats[i].messages[0] = tempchat.messages[0];
          }
          _chats.sort((a, b) {
            if (a.messages[0].lastUpdated.seconds >
                b.messages[0].lastUpdated.seconds) {
              return -1;
            } else if (a.messages[0].lastUpdated.seconds <
                b.messages[0].lastUpdated.seconds) {
              return 1;
            } else {
              return 0;
            }
          });
        });
      }
    } else {
      print("TIMEOUT : GETCHATS");
    }

    //get chats that user is a part of from api endpoint
  }

  addToMessages(List<Message> messageList, String chatid) async {
    if (messageList != []) {
      for (var message in messageList) {
        DatabaseHandler().insertMessage(message, chatid);
      }
    }
  }

  //Function to check if a user exists in the database. Since we are using suggestive messaging, or you can only message people who are online/posted recently this should always work.
  checkUser(String user) async {
    //request to check if user exists
    final response = await APIProvider.checkUserExists({'username': user});

    var res = json.decode(response['body']);

    if (res['status'] == 200) {
      return true;
    } else {
      return false;
    }
  }

  //Function for chatID which will be a concatenation of all recipients usernames in alphabetical order, like goobygroovesprimchi or infuhnitvncp
  getChatId(Chat chat) {
    //print(chat.recipients);
    List<String> chatIdList = [];
    for (var recipient in chat.recipients) {
      chatIdList.add(recipient);
    }
    chatIdList.sort();
    String chatID = "";
    for (var user in chatIdList) {
      chatID = chatID + user;
    }
    return chatID;
  }

  //Helper function for getting profile picture of a user
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
    final groupInstance = Provider.of<Group>(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Dyad')),
        leading: Text(" "),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => {
              Navigator.of(context).push<void>(MaterialPageRoute<void>(
                  builder: (context) => const SettingsScreen()))
              //Changed temporarily for inbox screen from SettingsScreen()
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
                        padding: EdgeInsets.only(left: 4, right: 4),
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
                            TextButton(
                                onPressed: () => {
                                      if (suggestiveList.length > 0)
                                        {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                //Stateful builder is used in conjunction with Dropdown button to choose user from list
                                                return StatefulBuilder(builder:
                                                    (context, setState) {
                                                  return AlertDialog(
                                                    insetPadding:
                                                        EdgeInsets.all(8.0),
                                                    content: Stack(
                                                        children: <Widget>[
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5.0),
                                                                  height: 50,
                                                                  width: 200,
                                                                  //Dropdown button is for choosing a list of available users to message.
                                                                  //There is no typing in the box because you should only be able to message people who have posted recently,
                                                                  //to help protect anonymity
                                                                  child:
                                                                      DropdownButton<
                                                                          String>(
                                                                    items: suggestiveList.map<
                                                                        DropdownMenuItem<
                                                                            String>>((String
                                                                        value) {
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value:
                                                                            value,
                                                                        child: Text(
                                                                            value),
                                                                      );
                                                                    }).toList(),
                                                                    isExpanded:
                                                                        true,
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .arrow_downward),
                                                                    elevation:
                                                                        16,
                                                                    value:
                                                                        dropdownvalue,
                                                                    onChanged:
                                                                        (newValue) {
                                                                      setState(
                                                                          () {
                                                                        dropdownvalue =
                                                                            newValue.toString();
                                                                        _toController.text =
                                                                            newValue.toString();
                                                                      });
                                                                      print(
                                                                          dropdownvalue);
                                                                    },
                                                                  )),
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            5.0),
                                                                height: 50,
                                                                width: 200,
                                                                child:
                                                                    TextFormField(
                                                                  decoration:
                                                                      InputDecoration(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .edit),
                                                                    hintText:
                                                                        'Message',
                                                                  ),
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .multiline,
                                                                  controller:
                                                                      _msgController,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 50),
                                                              TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    //Put away the alert dialog so user doesn't spam press send.
                                                                    Navigator.pop(
                                                                        context);
                                                                    //Check if other user exists first
                                                                    if (await checkUser(_toController
                                                                            .value
                                                                            .text) ==
                                                                        false) {
                                                                      _msgController
                                                                          .clear();
                                                                      _toController
                                                                          .clear();
                                                                      return showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return AlertDialog(
                                                                                title: Text("Could not send!"),
                                                                                insetPadding: EdgeInsets.all(8.0),
                                                                                content: Column(
                                                                                  children: [
                                                                                    Text("Could not send a message because that user does not exist."),
                                                                                    TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
                                                                                  ],
                                                                                ));
                                                                          });
                                                                    } else {
                                                                      //For id, first check if a chat exists, if it doesn't create a new message in a new chatroom. If it exists
                                                                      //open the websocket connection and add in using latest_id.
                                                                      //Make a new chat object with new chat
                                                                      List<String>
                                                                          tempRecList =
                                                                          [];
                                                                      //Put recipients in alphabetical order
                                                                      tempRecList
                                                                          .add(
                                                                              username);
                                                                      tempRecList.add(_toController
                                                                          .value
                                                                          .text);
                                                                      tempRecList
                                                                          .sort();
                                                                      Chat newChat = Chat(
                                                                          recipients: [],
                                                                          messages: []);
                                                                      for (var recipient
                                                                          in tempRecList) {
                                                                        newChat
                                                                            .recipients
                                                                            .add(recipient);
                                                                      }
                                                                      //Open a ws channel to send the message, then close the connection
                                                                      final channel = WebSocketChannel.connect(Uri.parse('ws://74.207.251.32:8000/ws/chat/' +
                                                                          getChatId(
                                                                              newChat) +
                                                                          '/'));
                                                                      //Send to websocket so other user can get message too
                                                                      var jsonString =
                                                                          {
                                                                        'roomname':
                                                                            getChatId(newChat),
                                                                        'username':
                                                                            username,
                                                                        'recipients':
                                                                            newChat.recipients,
                                                                        'message': _msgController
                                                                            .value
                                                                            .text,
                                                                        'command':
                                                                            'new_message',
                                                                      };
                                                                      channel
                                                                          .sink
                                                                          .add(jsonEncode(
                                                                              jsonString));
                                                                      await Future.delayed(Duration(
                                                                          seconds:
                                                                              1));
                                                                      //Get the message id from the latest websocket message so we can add to our local cache
                                                                      channel
                                                                          .stream
                                                                          .listen(
                                                                              (event) {
                                                                        var jsonString =
                                                                            json.decode(event);
                                                                        if (this
                                                                            .mounted) {
                                                                          latestID =
                                                                              jsonString['message_id'].toString();
                                                                          print(
                                                                              latestID);
                                                                        }
                                                                      });
                                                                      await Future.delayed(Duration(
                                                                          seconds:
                                                                              2));
                                                                      print(
                                                                          "SENT");
                                                                      channel
                                                                          .sink
                                                                          .close();
                                                                      Message message = Message(
                                                                          id:
                                                                              latestID,
                                                                          author:
                                                                              username,
                                                                          content: _msgController
                                                                              .value
                                                                              .text,
                                                                          lastUpdated: Timestamp.fromDateTime(DateTime.now()
                                                                              .toUtc()),
                                                                          created:
                                                                              null,
                                                                          image:
                                                                              null);
                                                                      //Insert into our local cache so we have the message even when we leave websocket connection
                                                                      DatabaseHandler().insertMessage(
                                                                          message,
                                                                          getChatId(
                                                                              newChat));
                                                                      getChats();
                                                                      _msgController
                                                                          .clear();
                                                                      _toController
                                                                          .clear();
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                      buttonText))
                                                            ],
                                                          )
                                                        ]),
                                                    title: Text(
                                                        'Send a new message'),
                                                  );
                                                });
                                              })
                                        }
                                      else
                                        {
                                          //If there is nobody in the suggestive message list, means there is nobody online. Can only message someone you have talked to before,
                                          //or wait for someone to post
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                    title: Text(
                                                        "Could not compose a message!"),
                                                    insetPadding:
                                                        EdgeInsets.all(8.0),
                                                    content: Column(
                                                      children: [
                                                        Text(
                                                            "There doesn't seem to be anybody nearby to send a message to. Wait for someone to post!"),
                                                        TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: Text("OK"))
                                                      ],
                                                    ));
                                              })
                                        }
                                    },
                                child: Text("New")),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
                //Listview builder builds a inbox full of the latest message between the user and others
                ListView.builder(
                  itemCount: _chats.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 16),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    //Pressing on a message will bring to individual message page
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MessagePage(
                                profilePicture: null,
                                nickname: _chats[index].recipients.firstWhere(
                                    (element) => element != username,
                                    orElse: () => 'temp'),
                                chat_id: getChatId(_chats[index]),
                              ),
                            )).then((value) {
                          //Refreshes the chats when leaving message page
                          getChats();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 10, bottom: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                      backgroundImage: null,
                                      foregroundColor: Colors.black12,
                                      backgroundColor: Colors.white70,
                                      maxRadius: 30,
                                      child: Text(_chats[index]
                                          .recipients
                                          .firstWhere(
                                              (element) => element != username,
                                              orElse: () => 'temp'
                                                  .substring(0, min(4, 5))))),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            _chats[index].recipients.firstWhere(
                                                (element) =>
                                                    element != username,
                                                orElse: () => 'temp'),
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            _chats[index].messages[0].content,
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey.shade600,
                                                fontWeight: false
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
                              timeago.format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      (_chats[index]
                                                  .messages[0]
                                                  .lastUpdated
                                                  .seconds *
                                              1000)
                                          .toInt()),
                                  locale: 'en_short'),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: false
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            )),
      ),
    );
  }
}
