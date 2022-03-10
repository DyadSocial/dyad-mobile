import 'dart:convert';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:http/http.dart' as http;
import 'package:dyadapp/src/data.dart';

class APIProvider {
  static final _baseURL = 'https://api.dyadsocial.com';
  final http.Client httpClient;
  APIProvider(this.httpClient);

  Future<List<User>> getUserList() async {
    final response =
        await httpClient.get(Uri.parse('$_baseURL/core/users-list/'));

    if (response.statusCode == 200) {
      List<User> userList = [];
      print(response.body);
    }
    return [];
  }

  static Future<Map<String, dynamic>> postUserSignup(
      Map<String, String> formData) async {
    final response = await http.post(
      Uri.parse('$_baseURL/core/register'),
      body: {
        "username": formData['username'],
        "password": formData['password']
      },
    );
    return {"status": response.statusCode, "body": response.body};
  }

  static Future<Map<String, dynamic>> logIn(
      Map<String, String> formData) async {
    try {
      final response =
          await http.post(Uri.parse('$_baseURL/core/login'), body: {
        "username": formData['username'],
        "password": formData['password'],
      }).timeout(Duration(seconds: 4));
      return {"status": response.statusCode, "body": response.body};
    } catch (e) {
      var obj = {"status": 420, "body": "Timeout Exception"};
      var json = jsonEncode(obj);
      return jsonDecode(json);
    }
  }
}
