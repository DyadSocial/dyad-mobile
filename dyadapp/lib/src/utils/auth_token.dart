import 'dart:convert';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:flutter/material.dart';

import '../routing.dart';

enum UserStatus { loggedIn, loggedOut }

class AuthToken {
  Map<String, dynamic>? _decodedToken;

  Map<String, dynamic>? get decodedToken => _decodedToken;
  static String get authorizationString =>
      'Bearer ${UserSession().get("access")}';
  DateTime get expiresAt => _decodedToken != null
      ? DateTime.fromMillisecondsSinceEpoch(_decodedToken!['exp'])
      : DateTime(0);

  static AuthToken? _authTokenInstance;

  AuthToken._constructor(String? token) {
    _authTokenInstance = this;
    try {
      if (token != null) {
        this._decodedToken = jwtDecode(token)!;
      }
    } catch (e) {
      this._decodedToken = {};
    }
  }

  factory AuthToken({BuildContext? context, String? token}) =>
      _authTokenInstance ??= AuthToken._constructor(token);

  static Map<String, dynamic>? jwtDecode(String token) {
    final splitToken = token.split(".");
    if (splitToken.length != 3) {
      throw FormatException('Invalid Token');
    }
    try {
      // Base64 to UTF8 to JSON
      return jsonDecode(
        utf8.decode(
          base64.decode(
            base64.normalize(
              splitToken[1],
            ),
          ),
        ),
      );
    } catch (e) {
      throw FormatException('Could not decode payload');
    }
  }

  static storeToken(String token) async {
    UserSession().set("access", token);
    AuthToken()._decodedToken = jwtDecode(token)!;
  }

  static getStatus() async {
    var token = await UserSession().get("access");
    if (token != null) {
      AuthToken()._decodedToken = jwtDecode(token)!;
      if (AuthToken().expiresAt.compareTo(DateTime.now()) == -1) {
        return UserStatus.loggedIn;
      }
    }
    return UserStatus.loggedOut;
  }

  static logout() async {
    UserSession().remove('access');
  }
}
