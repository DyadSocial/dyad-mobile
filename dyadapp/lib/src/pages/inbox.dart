import 'package:dyadapp/src/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dyadapp/src/widgets/message_list.dart';
import 'package:dyadapp/src/utils/data/test_message.dart';
import 'package:dyadapp/src/utils/data/protos/messages.pb.dart';
import 'package:dyadapp/src/utils/database_handler.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:dyadapp/src/utils/network_handler.dart';

class InboxPage extends StatefulWidget {
 
  InboxPage({Key? key}): super(key: key);

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> 
    with SingleTickerProviderStateMixin {
  List<Chat> _chats = [];
  List<Message> _messages =[];
  List <ImageProvider> profilePictures = [];

  @override
  void initState() {
    super.initState();
    for (var chat in _chats)
    {
      if (chat.messages.length > 0) {
        _messages.add(chat.messages[0]);
      }
      else {
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
  getProfilePictures() async {
    for (var chat in _chats)
    {
      profilePictures.add((Image.memory(await runPullProfileImage(chat.recipients))).image);
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Dyad')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {},
        ),
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
                            left: 8, right: 8, top: 2, bottom: 2),
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
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "New",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
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
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return MessageList(
                      name: _messages[index].author,
                      text: _messages[index].content,
                      //TO DO: 
                      profilePicture: profilePictures[index],
                      time: timeago.format(DateTime.fromMillisecondsSinceEpoch((_messages[index].created.seconds * 1000).toInt()), locale: 'en_short'),
                      isMessageRead: (index == 0 || index == 3) ? true : false,
                    );
                  },
                ),
              ],
            )),
      ),
    );
  }
}
