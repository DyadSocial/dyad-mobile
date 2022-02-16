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
      'https://scontent-sjc3-1.xx.fbcdn.net/v/t1.6435-9/120904095_10217726686145469_5615115273804572193_n.jpg?_nc_cat=109&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=VbLO0epcTzkAX_m1SgK&_nc_ht=scontent-sjc3-1.xx&oh=00_AT9GljfezSRmVfN_RKeeZXQkd_py5X4JoWcOjxROSfhRRA&oe=623211ED',
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
        'https://scontent-sjc3-1.xx.fbcdn.net/v/t1.6435-9/122292494_3745393062147578_9171079194156674668_n.jpg?_nc_cat=107&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=QVYdpSLA0iAAX_Btxaw&_nc_ht=scontent-sjc3-1.xx&oh=00_AT96GBGi8MCRUfy476UwXPKAF2ro4VFNSKsQLjXhuL8_qA&oe=6232CBA2'),
  )
  ..addUser(
    username: 'primchi',
    nickname: 'prim',
    biography: 'UNR ‘22 | ΚΦΛ | 🇹🇭',
    profilePicture: NetworkImage(
        'https://scontent-sjc3-1.xx.fbcdn.net/v/t1.6435-9/102380597_1514900362022644_5290959128538387371_n.jpg?_nc_cat=105&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=SIyORgrVRMMAX92KTb_&tn=ruCaUUGVVERAM7KS&_nc_ht=scontent-sjc3-1.xx&oh=00_AT_1oVw-8vEc82fs9J7ApWi7mcN3EgPO76C0Koa-egLvrw&oe=622FD551'),
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
        'https://scontent-sjc3-1.xx.fbcdn.net/v/t1.6435-9/93430317_1470948506417830_421140398279229440_n.jpg?_nc_cat=107&ccb=1-5&_nc_sid=e3f864&_nc_ohc=e80ZG_4yX90AX-e21QP&_nc_ht=scontent-sjc3-1.xx&oh=00_AT-HzulLWBpzUMYeg6cjcNCY2is-KK-uIzovi_fd90Qpxw&oe=6231DDBB'),
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
    return allUsers.firstWhere((user) {
      return user.username == username;
    });
  }

  void removeUser(String username) {
    allUsers.remove(allUsers.firstWhere((user) => user.username == username));
  }
}
