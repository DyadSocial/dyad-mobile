import 'user.dart';
import 'package:flutter/material.dart';

final groupInstance = Group()
  ..addUser(
    username: 'vncp',
    nickname: 'Vincent',
    biography: '''
    eat..
    sleep..
    code..
    repeat..''',
    profilePicture: NetworkImage(
      'https://scontent-sjc3-1.xx.fbcdn.net/v/t1.6435-9/120904095_10217726686145469_5615115273804572193_n.jpg?_nc_cat=109&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=NfWBNs2uzGcAX9e_voQ&_nc_ht=scontent-sjc3-1.xx&oh=4f154cab8d24cf91568717cc232079cd&oe=61D325ED',
    ),
  )
  ..addUser(
    username: 'infuhnit',
    nickname: 'Jake',
    biography: '''
    unr | snap: jakelkjhgfdsa
twitch.tv/infuhnit
    ''',
    profilePicture: NetworkImage(
        'https://scontent-sjc3-1.xx.fbcdn.net/v/t1.6435-9/122292494_3745393062147578_9171079194156674668_n.jpg?_nc_cat=107&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=slQEMErmpZgAX-AUIuG&_nc_ht=scontent-sjc3-1.xx&oh=45f59b5c1286c2fae62f46c248fa6745&oe=61CBF6A2'),
  )
  ..addUser(
    username: 'primchi',
    nickname: 'prim',
    biography: 'UNR ‘22 | ΚΦΛ | 🇹🇭',
    profilePicture: NetworkImage(
        'https://scontent-sjc3-1.xx.fbcdn.net/v/t1.6435-9/102380597_1514900362022644_5290959128538387371_n.jpg?_nc_cat=105&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=XX21z4bwB1cAX87haow&_nc_ht=scontent-sjc3-1.xx&oh=2f05cc1801cb3c32196dc289e7e5ce80&oe=61D0E951'),
  )
  ..addUser(
    username: 'wavy_gooby',
    nickname: 'Sam',
    biography: '''サムエル / 사무엘 日常人間
UNR Comp Sci & Engineering 22"
"GOOBY GROOVES"
🌤 - [ Programmer | Engineer ]
🌃 - [ Composer | Singer-Songwriter | Mix Engineer ]''',
    profilePicture: NetworkImage(
        'https://scontent-sjc3-1.xx.fbcdn.net/v/t1.6435-9/194829152_10226669115340587_3025307937493221262_n.jpg?_nc_cat=111&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=MMTu96a2Y8AAX8pJW4E&_nc_ht=scontent-sjc3-1.xx&oh=f6306242882645b47753f1b25ad60a21&oe=61D16A39'),
  );

class Group {
  final List<User> allUsers = [];

  void addUser({
    required String username,
    required String nickname,
    required String biography,
    required ImageProvider<Object> profilePicture,
  }) {
    var user = User(username, nickname, biography, profilePicture);
    // TODO: Add future functionality for close friends
    allUsers.add(user);
  }

  User getUser(String username) {
    return allUsers.firstWhere((user) => user.username == username);
  }

  void removeUser(String username) {
    allUsers.remove(allUsers.firstWhere((user) => user.username == username));
  }
}
