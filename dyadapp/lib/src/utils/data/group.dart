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
      'https://media-exp1.licdn.com/dms/image/C5603AQGf4tbhyvvvOw/profile-displayphoto-shrink_800_800/0/1642625696688?e=1654732800&v=beta&t=im4-szJJ1v97pUlNK_mjUX8pFupdSegAXOdMUfDy5Lo',
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
        'https://media-exp1.licdn.com/dms/image/C4E03AQEA6K6FqRUwug/profile-displayphoto-shrink_800_800/0/1603301837498?e=1654732800&v=beta&t=t14MryYkwq2pA1RypgreCWjUplrKeD0VWt-GMdkLDQI'),
  )
  ..addUser(
    username: 'primchi',
    nickname: 'prim',
    biography: 'UNR ‘22 | ΚΦΛ | 🇹🇭',
    profilePicture: NetworkImage(
        'https://media-exp1.licdn.com/dms/image/C5603AQFNHj_f33DmjA/profile-displayphoto-shrink_800_800/0/1572290373534?e=1654732800&v=beta&t=B-3RTRdUDE7Sb0Dwb1DdA3YNLRHRMT8SQniXA_hmmPM'),
  )
  ..addUser(
    username: 'goobygrooves',
    nickname: 'Sam',
    biography: '''サムエル / 사무엘 日常人間
UNR Comp Sci & Engineering 22"
"GOOBY GROOVES"
🌤 - [ Programmer | Engineer ]
🌃 - [ Composer | Singer-Songwriter | Mix Engineer ]''',
    profilePicture: NetworkImage(
        'https://media-exp1.licdn.com/dms/image/C5603AQHvXGtCb_kI6w/profile-displayphoto-shrink_800_800/0/1603825712378?e=1654732800&v=beta&t=ShDzRtDI_Zwh5CFw4FrL-U3ozbf4gHil0j2UdS0kvg4'),
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

  User? getUser(String username) {
    return allUsers.firstWhere((user) {
      return user.username == username;
    });
  }

  void removeUser(String username) {
    allUsers.remove(allUsers.firstWhere((user) => user.username == username));
  }
}
