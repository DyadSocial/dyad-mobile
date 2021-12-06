import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dyadapp/src/data.dart';

class APIProvider {
  static final _baseURL = 'https://api.vncp.me:8000';
  final http.Client httpClient;
  APIProvider(this.httpClient);

  Future<List<User>> getUserList() async {
    final response =
        await httpClient.get(Uri.parse('$_baseURL/core/user-list/'));

    if (response.statusCode == 200) {
      List<User> userList = [];
      print(response.body);
    }
    return [];
  }

  static Future<bool> postUserSignup(Map<String, String> formData) async {
    final response = await http.post(
      Uri.parse('$_baseURL/core/create-user/'),
      body: {
        "username": formData['username'],
        "password": formData['password'],
        "nickname": formData['nickname'],
        "profilePicture": formData['profilepicture'],
      },
    );
    print(response.body);

    return true;
  }
}
