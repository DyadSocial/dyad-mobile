import 'dart:convert';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:http/http.dart' as http;
import 'package:dyadapp/src/data.dart';

//Utility class for accessing dyad api for user authentication

class APIProvider {
  static final _baseURL = 'https://api.dyadsocial.com';
  static final _chatURL = 'http://74.207.251.32:8000';
  final http.Client httpClient;

  APIProvider(this.httpClient);

  Future<List<User>> getUserList() async {
    final response =
        await httpClient.get(Uri.parse('$_baseURL/core/users-list/'));

    if (response.statusCode == 200) {
      List<User> userList = [];
    }
    return [];
  }

  // Uploads an image file to the Django Static image server
  static Future<String?> uploadImageFile(
      String filepath, String author, String id) async {
    print("Uploading Image file ($author:$id) $filepath");
    var request =
        http.MultipartRequest('POST', Uri.parse('$_baseURL/images/upload/'));
    request.fields['image_id'] = id;
    request.fields['author'] = author;
    request.files.add(await http.MultipartFile.fromPath("image", filepath));
    var response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
     return jsonDecode(response.body)["image"];
    }
    return "";
  }

  // Gets user profile using a query parameter
  static Future<Map<String, dynamic>> getUserProfile(String username) async {
    String token = await UserSession().get("access");
    final response = await http.get(
        Uri.parse('$_baseURL/core/profile/get-user-profile?username=$username'),
        headers: {"jwt": token});
    print(response.statusCode);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return {};
  }

  // Update User profile on Django backend (Picture URL, Desc, Nickname, etc.)
  // Vincent
  static Future<Map<String, dynamic>> updateUserProfile(
      {String? imageURL, String? nickname, String? description}) async {
    try {
      String token = await UserSession().get("access");
      print(token);
      if (imageURL != null)
        await http
            .put(Uri.parse('$_baseURL/core/profile/update-user-profile'), body: {
          "new_image": imageURL,
        }, headers: {
          "jwt": token
        }).timeout(Duration(seconds: 5));
      if (description != null)
        await http
            .put(Uri.parse('$_baseURL/core/profile/update-user-profile'), body: {
          "new_description": description,
        }, headers: {
          "jwt": token
        }).timeout(Duration(seconds: 5));
      if (description != null)
        await http
            .put(Uri.parse('$_baseURL/core/profile/update-user-profile'), body: {
          "new_display_name": nickname
        }, headers: {
          "jwt": token
        }).timeout(Duration(seconds: 5));
      return {"status": 200, "body": "Profile updated!"};
    } catch (e) {
      return {"status": 400, "body": "Could not send POST to server."};
    }
  }

  // Prim
  static Future<Map<String, dynamic>> postUserSignup(
      Map<String, String> formData) async {
    await http.post(
      Uri.parse('$_chatURL/core/register'),
      body: {
        "username": formData['username'],
        "password": formData['password']
      },
    );
    final response = await http.post(
      Uri.parse('$_baseURL/core/register'),
      body: {
        "username": formData['username'],
        "password": formData['password']
      },
    );
    return {"status": 200, "body": response.body};
  }

  // Prim
  static Future<Map<String, dynamic>> logIn(
      Map<String, String> formData) async {
    try {
      final response =
          await http.post(Uri.parse('$_baseURL/core/login'), body: {
        "username": formData['username'],
        "password": formData['password'],
      }).timeout(Duration(seconds: 2));
      return {"status": response.statusCode, "body": response.body};
    } catch (e) {
      var obj = {"status": 400, "body": "Timeout Exception"};
      return obj;
    }
  }

  // Jake/Prim
  static Future<Map<String, dynamic>> fetchMessages(
      Map<String, String> formData) async {
    try {
      final response = await http
          .post(Uri.parse('$_chatURL/chat/api/fetchmessages/'), body: {
        "chatid": formData['chatid'],
        "command": formData['command']
      }).timeout(Duration(seconds: 2));
      return {"status": response.statusCode, "body": response.body};
    } catch (e) {
      var obj = {"status": 400, "body": "Timeout Exception"};
      var json = jsonEncode(obj);
      return jsonDecode(json);
    }
  }

  // Jake/Prim
  static Future<Map<String, dynamic>> fetchLatestMessage(
      Map<String, String> formData) async {
    try {
      final response = await http
          .post(Uri.parse('$_chatURL/chat/api/fetchmessages/'), body: {
        "chatid": formData['chatid'],
        "command": formData['command']
      }).timeout(Duration(seconds: 2));
      return {"status": response.statusCode, "body": response.body};
    } catch (e) {
      var obj = {"status": 400, "body": "Timeout Exception"};
      var json = jsonEncode(obj);
      return jsonDecode(json);
    }
  }

  // Jake/Prim
  static Future<Map<String, dynamic>> fetchChats(
      Map<String, String> formData) async {
    try {
      final response =
          await http.post(Uri.parse('$_chatURL/chat/api/getchats/'), body: {
        "username": formData['username'],
      }).timeout(Duration(seconds: 2));
      return {"status": response.statusCode, "body": response.body};
    } catch (e) {
      var obj = {"status": 400, "body": "Timeout Exception"};
      var json = jsonEncode(obj);
      return jsonDecode(json);
    }
  }

  // Jake/Prim
  static Future<Map<String, dynamic>> checkUserExists(
      Map<String, String> formData) async {
    try {
      final response = await http
          .post(Uri.parse('$_chatURL/chat/api/checkuserexist/'), body: {
        "username": formData['username']
      }).timeout(Duration(seconds: 2));
      return {"status": response.statusCode, "body": response.body};
    } catch (e) {
      var obj = {"status": 404, "body": "User does not exist."};
      var json = jsonEncode(obj);
      return jsonDecode(json);
    }
  }
}
