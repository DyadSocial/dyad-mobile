import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:dyadapp/src/utils/database_handler.dart';

import 'api_provider.dart';
import 'auth_token.dart';

class DyadAuth extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  void set isSignedIn(bool signedIn) {
    this._isSignedIn = signedIn;
  }

  Future<void> signOut() async {
    // Simulating response from server
    DatabaseHandler().clearData();
    UserSession().clear();
    AuthToken.logout();
    _isSignedIn = false;
    notifyListeners();
  }

  Future<bool> signIn(String username, String password) async {
    var resp =
        await APIProvider.logIn({'username': username, 'password': password});
    if (resp['status'] == 200) {
      _isSignedIn = true;
      await UserSession().set("username", username);
      AuthToken.storeToken(jsonDecode(resp['body'])['jwt']);
    }
    notifyListeners();
    return _isSignedIn;
  }

  @override
  bool operator ==(Object other) {
    return other is DyadAuth && other._isSignedIn == _isSignedIn;
  }

  @override
  int get hashCode => _isSignedIn.hashCode;
}

class DyadAuthScope extends InheritedNotifier<DyadAuth> {
  const DyadAuthScope({
    required DyadAuth notifier,
    required Widget child,
    Key? key,
  }) : super(key: key, notifier: notifier, child: child);

  static DyadAuth of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DyadAuthScope>()!.notifier!;
}
