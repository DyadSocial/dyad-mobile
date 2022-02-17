import 'dart:convert';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:http/http.dart' as http;
import 'package:dyadapp/src/data.dart';

class APIProvider {
  static final _baseURL = 'http://api.dyadsocial.com:8000';
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

  static Future<String> postUserSignup(Map<String, String> formData) async {
    final response = await http.post(
      Uri.parse('$_baseURL/core/register'),
      body: {
        "username": formData['username'],
        "password": formData['password']
      },
    );
    if(response.statusCode == 200) {
      return response.body;
    }
    return '';
  }

  static Future<String> logIn(Map <String, String> formData) async {
    final response = await http.post(Uri.parse('${_baseURL}/core/login/'),
    body: {
        "username": formData['username'],
        "password": formData['password'],
      }
    );
    print(response.statusCode);
    if(response.statusCode == 200) {
      return response.body;
    }
    return '';
  }
}
