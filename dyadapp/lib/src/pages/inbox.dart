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
import 'dart:math';
import 'package:dyadapp/src/pages/message_page.dart';

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
  var latestMessage = Message(
      id: "0",
      author: "temp",
      content: "temp",
      lastUpdated: Timestamp.fromDateTime(DateTime.now()));
  String buttonText = "SEND";
  bool isButtonDisabled = false;

  @override
  void initState() {
    getChats();
    super.initState();
  }

  getUser() async {
    //print(username);
  }

  getChats() async {
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
      for (var msg in res) {
        var participants = new List<String>.from(msg['participants']);
        //print(participants);
        Chat tempchat = Chat(recipients: participants, messages: []);
        Chat copy = Chat(recipients: participants, messages: []);
        final response2 = await APIProvider.fetchLatestMessage(
            {'chatid': getChatId(tempchat), 'command': "1"});
        if (response2['status'] == 200) {
          var res2 = json.decode(response2['body']);
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

  //The chatID will be a concatenation of all recipients usernames in alphabetical order, like goobygroovesprimchi or infuhnitvncp
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
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              insetPadding: EdgeInsets.all(8.0),
                                              content: Stack(children: <Widget>[
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      height: 50,
                                                      width: 200,
                                                      child: TextFormField(
                                                        decoration:
                                                            InputDecoration(
                                                          icon: Icon(
                                                              Icons.person),
                                                          hintText: 'To who?',
                                                        ),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        controller:
                                                            _toController,
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      height: 50,
                                                      width: 200,
                                                      child: TextFormField(
                                                        decoration:
                                                            InputDecoration(
                                                          icon:
                                                              Icon(Icons.edit),
                                                          hintText: 'Message',
                                                        ),
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        controller:
                                                            _msgController,
                                                      ),
                                                    ),
                                                    SizedBox(height: 50),
                                                    TextButton(
                                                        onPressed: () async {
                                                          //Put away the alert dialog so user doesn't spam press send.
                                                          Navigator.pop(
                                                              context);
                                                          //Check if other user exists first
                                                          if (await checkUser(
                                                                  _toController
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
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                      title: Text(
                                                                          "Could not send!"),
                                                                      insetPadding:
                                                                          EdgeInsets.all(
                                                                              8.0),
                                                                      content:
                                                                          Column(
                                                                        children: [
                                                                          Text(
                                                                              "Could not send a message because that user does not exist."),
                                                                          TextButton(
                                                                              onPressed: () => Navigator.pop(context),
                                                                              child: Text("OK"))
                                                                        ],
                                                                      ));
                                                                });
                                                          } else {
                                                            //For id, first check if a chat exists, if it doesn't create a new message in a new chatroom. If it exists
                                                            //open the websocket connection and add in using latest_id.
                                                            //Would help if sam could send the chats with their latest message?
                                                            //Make a new chat object with new chat
                                                            List<String>
                                                                tempRecList =
                                                                [];
                                                            //Put recipients in alphabetical order
                                                            tempRecList
                                                                .add(username);
                                                            tempRecList.add(
                                                                _toController
                                                                    .value
                                                                    .text);
                                                            tempRecList.sort();
                                                            Chat newChat = Chat(
                                                                recipients: [],
                                                                messages: []);
                                                            for (var recipient
                                                                in tempRecList) {
                                                              newChat.recipients
                                                                  .add(
                                                                      recipient);
                                                            }

                                                            final channel = WebSocketChannel
                                                                .connect(
                                                                    //put in chatid once we figure it out
                                                                    Uri.parse('ws://74.207.251.32:8000/ws/chat/' +
                                                                        getChatId(
                                                                            newChat) +
                                                                        '/'));
                                                            //Send to websocket so other user can get message too
                                                            var jsonString = {
                                                              'roomname':
                                                                  getChatId(
                                                                      newChat),
                                                              'username':
                                                                  username,
                                                              'recipients':
                                                                  newChat
                                                                      .recipients,
                                                              'message':
                                                                  _msgController
                                                                      .value
                                                                      .text,
                                                              'command':
                                                                  'new_message',
                                                            };
                                                            channel.sink.add(
                                                                jsonEncode(
                                                                    jsonString));
                                                            await Future
                                                                .delayed(
                                                                    Duration(
                                                                        seconds:
                                                                            1));
                                                            //Seeing if we could get message id from this
                                                            channel.stream
                                                                .listen(
                                                                    (event) {
                                                              var jsonString =
                                                                  json.decode(
                                                                      event);
                                                              if (this
                                                                  .mounted) {
                                                                latestID = jsonString[
                                                                        'message_id']
                                                                    .toString();
                                                                print(latestID);
                                                              }
                                                            });
                                                            await Future
                                                                .delayed(
                                                                    Duration(
                                                                        seconds:
                                                                            2));
                                                            print("SENT");
                                                            channel.sink
                                                                .close();
                                                            Message message = Message(
                                                                id: latestID,
                                                                author:
                                                                    username,
                                                                content:
                                                                    _msgController
                                                                        .value
                                                                        .text,
                                                                lastUpdated: Timestamp
                                                                    .fromDateTime(
                                                                        DateTime.now()
                                                                            .toUtc()),
                                                                created: null,
                                                                image: null);
                                                            //Chatid for inserting into database can be like currentuser-touser?
                                                            //put in chatid once we figure it out
                                                            DatabaseHandler()
                                                                .insertMessage(
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
                                                        child: Text(buttonText))
                                                  ],
                                                )
                                              ]),
                                              title: Text('Send a new message'),
                                            );
                                          })
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MessagePage(
                                profilePicture: groupInstance
                                        .getUser(_chats[index]
                                            .recipients
                                            .firstWhere(
                                                (element) =>
                                                    element != username,
                                                orElse: () => 'infuhnit'))
                                        ?.profilePicture ??
                                    null,
                                nickname: _chats[index].recipients.firstWhere(
                                    (element) => element != username,
                                    orElse: () => 'temp'),
                                //As said above, might want to instead pass in a Chat between the current user and widget.name instead of a list of messages
                                //This was for demo purposes only
                                chat_id: getChatId(_chats[index]),
                              ),
                            )).then((value) {
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
                                      backgroundImage: groupInstance
                                              .getUser(_chats[index]
                                                  .recipients
                                                  .firstWhere(
                                                      (element) =>
                                                          element != username,
                                                      orElse: () => 'infuhnit'))
                                              ?.profilePicture ??
                                          null,
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
