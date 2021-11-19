import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class DyadAuth extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  Future<void> signOut() async {
    // Simulating response from server
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _isSignedIn = false;
    notifyListeners();
  }

  Future<bool> signIn(String phone, String password) async {
    // Simulating response from server
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _isSignedIn = true;
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
