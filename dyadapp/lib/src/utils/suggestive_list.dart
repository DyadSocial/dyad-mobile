import 'dart:convert';
import 'package:dyadapp/src/utils/user_session.dart';
/*
* Utility class for helping get a list of users for the suggestive list in inbox page (inbox.dart)
* */
class SuggestiveList{
  static Set<String> users = {};
  final username = UserSession().get("username");

  static void addUser(String user){
    users.add(user);
  }

  static List<String> getUserList(){
    final List<String> list = users.toList();
    list.sort();
    return list;
  }

}