import 'user.dart';

final groupInstance = Group()
  ..addUser(username: 'vncp', nickname: 'Vincent', biography: 'no sleep..')
  ..addUser(username: 'infuhnit', nickname: 'Jake', biography: 'im strimmer!');

class Group {
  final List<User> allUsers = [];

  void addUser({
    required String username,
    required String nickname,
    required String biography,
  }) {
    var user = User(username, nickname, biography);
    // Add future functionality for close friends
    allUsers.add(user);
  }
}
