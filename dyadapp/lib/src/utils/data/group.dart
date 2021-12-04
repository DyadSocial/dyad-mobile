import 'user.dart';
import 'package:flutter/material.dart';

final groupInstance = Group()
  ..addUser(
    username: 'vncp',
    nickname: 'Vincent',
    biography: 'no sleep..',
    profilePicture: NetworkImage(
        'https://scontent-sjc3-1.cdninstagram.com/v/t51.2885-19/s150x150/221272971_882420812371217_4398966687878976385_n.jpg?_nc_ht=scontent-sjc3-1.cdninstagram.com&_nc_cat=105&_nc_ohc=zH30VxZwLpoAX_KPENW&edm=ABfd0MgBAAAA&ccb=7-4&oh=43f276103bf80802fdb83365baae9f41&oe=61ADDC0A&_nc_sid=7bff83'),
  )
  ..addUser(
    username: 'infuhnit',
    nickname: 'Jake',
    biography: 'im strimmer!',
    profilePicture: NetworkImage(
        'https://scontent-sjc3-1.xx.fbcdn.net/v/t1.6435-9/122292494_3745393062147578_9171079194156674668_n.jpg?_nc_cat=107&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=slQEMErmpZgAX-AUIuG&_nc_ht=scontent-sjc3-1.xx&oh=45f59b5c1286c2fae62f46c248fa6745&oe=61CBF6A2'),
  )
  ..addUser(
    username: 'wavy_gooby',
    nickname: 'Sam',
    biography: 'music msuic msciu',
    profilePicture: NetworkImage(
        'https://scontent-sjc3-1.cdninstagram.com/v/t51.2885-15/e35/187247982_306589957790743_74766615813586783_n.jpg?_nc_ht=scontent-sjc3-1.cdninstagram.com&_nc_cat=107&_nc_ohc=cty8Gpl_qNYAX9gQTcx&tn=Mv0ZUYUdjngGSdlw&edm=AP_V10EBAAAA&ccb=7-4&oh=21ff0d99ae2f8ae81835a980f9e465e1&oe=61ACF916&_nc_sid=4f375e 640w,https://scontent-sjc3-1.cdninstagram.com/v/t51.2885-15/e35/187247982_306589957790743_74766615813586783_n.jpg?_nc_ht=scontent-sjc3-1.cdninstagram.com&_nc_cat=107&_nc_ohc=cty8Gpl_qNYAX9gQTcx&tn=Mv0ZUYUdjngGSdlw&edm=AP_V10EBAAAA&ccb=7-4&oh=21ff0d99ae2f8ae81835a980f9e465e1&oe=61ACF916&_nc_sid=4f375e 750w,https://scontent-sjc3-1.cdninstagram.com/v/t51.2885-15/e35/187247982_306589957790743_74766615813586783_n.jpg?_nc_ht=scontent-sjc3-1.cdninstagram.com&_nc_cat=107&_nc_ohc=cty8Gpl_qNYAX9gQTcx&tn=Mv0ZUYUdjngGSdlw&edm=AP_V10EBAAAA&ccb=7-4&oh=21ff0d99ae2f8ae81835a980f9e465e1&oe=61ACF916&_nc_sid=4f375e 1080w'),
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
