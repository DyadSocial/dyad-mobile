import 'package:collection/collection.dart';

import '../user_session.dart';
import 'user.dart';
import 'package:flutter/material.dart';

class Group extends ChangeNotifier {
  final List<User> allUsers = [];

  Group() {
    () async {
      addUser(username: await UserSession().get("username"));
    } ();
  }

  void addUser({
    required String username,
    String? nickname,
    String? biography,
    String? imageURL,
  }) {
    var user =
    User(username, nickname, biography, imageURL);
    allUsers.add(user);
  }

  // Get users
  User? getUser(String username) {
    return allUsers.firstWhereOrNull((user) {
      return user.username == username;
    });
  }

  // Removes the user
  void removeUser(String username) {
    allUsers.remove(allUsers.firstWhere((user) => user.username == username));
    notifyListeners();
  }

  // Updates the user object on various parameters if found
  void updateUser({
    required String username,
    String? nickname,
    String? biography,
    String? imageURL}) {
    int idx = allUsers.indexWhere((user) => user.username == username);
    // Don't want error trying to access idx = -1
    if (idx == -1) return;
    if (nickname != null) {
      allUsers[idx].nickname = nickname;
    }
    if (biography != null) {
      allUsers[idx].biography = biography;
    }
    if (imageURL != null) {
      allUsers[idx].profilePicture = imageURL;
    }
    notifyListeners();
  }
}
