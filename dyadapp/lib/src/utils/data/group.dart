// Author: Vincent
// A global state management solution in which we get information
// for all users.
// Simple class that notifies listeners and stores users.

import 'package:collection/collection.dart';

import '../user_session.dart';
import 'user.dart';
import 'package:flutter/material.dart';

class Group extends ChangeNotifier {
  final List<User> allUsers = [];
  User? self = null;

  Group() {
  }

  int addUser({
    required String username,
    String? nickname,
    String? biography,
    String? imageURL,
  }) {
    var user = User(username, nickname, biography, imageURL);
    allUsers.add(user);
    return allUsers.indexWhere((user) => user.username == username);
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
  void updateUser(
      {required String username,
      String? nickname,
      String? biography,
      String? imageURL,
      bool? isModerator}) {
    int idx = allUsers.indexWhere((user) => user.username == username);
    // Don't want error trying to access idx = -1
    // If user not found add it
    if (idx == -1) {
      idx = addUser(username: username);
    }
    if (nickname != null) {
      allUsers[idx].nickname = nickname;
    }
    if (biography != null) {
      allUsers[idx].biography = biography;
    }
    if (imageURL != null) {
      allUsers[idx].profilePicture = imageURL;
    }
    if (isModerator != null) {
      allUsers[idx].isModerator = isModerator;
    }
    notifyListeners();
  }
}
