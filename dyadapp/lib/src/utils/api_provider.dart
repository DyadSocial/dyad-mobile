// Authors: Vincent, Prim, and Jake
// Various functions calling the Django HTTPS server using requests

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
  // Vincent
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

  // Reports user and adddoes not yet works entry to the backend database
  // Vincent
  static Future<void> reportContent(
      String offender,
      String offending_content,
      String offending_title,
      String image_url,
      String report_reason
      ) async {
    var body = {
      "offender": offender,
      "offending_content": offending_content,
      "offending_title": offending_title,
      "image_url": image_url,
      "report_reason": report_reason
    };
    Map<String, String> headers = {"jwt": await UserSession().get("access")};
    final response = await http.post(
      Uri.parse('$_baseURL/core/report'),
      headers: headers,
      body: body);
    print(response.statusCode.toString() + response.body);
  }

  // Gets user profile using a query parameter
  // Vincent
  static Future<Map<String, dynamic>> getUserProfile(String username) async {
    String token = await UserSession().get("access");
    final response = await http.get(
        Uri.parse('$_baseURL/core/profile/get-user-profile?username=$username'),
        headers: {"jwt": token});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return {};
  }

  // Calls the first instantiation of UserProfile on the backend
  // Vincent
  static Future<Map<String, dynamic>> createUserProfile(String? biography, String? nickname) async {
    String token = await UserSession().get("access");
    final response = await http.post(
        Uri.parse('$_baseURL/core/profile/create-user-profile'),
        headers: {"jwt": token},
        body: {
          "display_name": nickname ?? "",
          "profile_description": biography ?? ""
        });
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

  // Signs up User
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

  // Logins in User
  // Prim & Vincent
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

  // Fetches messages from api (first-online retrieval)
  // Jake & Prim
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

  // calls fetch latest messages to get messages from a chat
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

  // calls fetch chat endpoint to get all available chats
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

  // Calls check user exists endpoint
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
