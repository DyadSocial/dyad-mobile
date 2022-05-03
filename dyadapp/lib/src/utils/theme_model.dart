// Authors: Jakob
// Gives theme preferences and if the theme is currently light or dark
// via change notifier - provider model (global state management)

import 'package:flutter/cupertino.dart';
import 'package:dyadapp/src/utils/theme_preferences.dart';

class ThemeModel extends ChangeNotifier {
  bool _isDark = false;
  ThemePreferences _preferences =
      ThemePreferences(); //Used for using small amount of memory to save theme
  bool get isDark => _isDark;

  ThemeModel() {
    _isDark = false;
    _preferences = ThemePreferences();
    getPreferences();
  }

  getPreferences() async {
    _isDark = await _preferences.getTheme() ?? true;
    notifyListeners();
  }

  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }
}

class ThemeModelScope extends InheritedNotifier<ThemeModel> {
  const ThemeModelScope({
    required ThemeModel notifier,
    required Widget child,
    Key? key,
  }) : super(key: key, notifier: notifier, child: child);

  static ThemeModel of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeModelScope>()!.notifier!;
}
