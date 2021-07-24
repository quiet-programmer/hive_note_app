import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  final String? key = 'appTheme';
  SharedPreferences? _pref;
  bool? _mTheme;

  bool get mTheme => _mTheme!;

  ThemeProvider() {
    _mTheme = false;
    _loadFromPref();
  }

  Future _initPrefs() async {
    _pref == null ? _pref = await SharedPreferences.getInstance() : null;
  }

  void _loadFromPref() async {
    await _initPrefs();
    _mTheme = _pref!.getBool(key!) ?? false;
    notifyListeners();
  }

  void _saveToPref() async {
    await _initPrefs();
    await _pref!.setBool(key!, _mTheme!);
  }

  void checkTheme() {
    _mTheme = !_mTheme!;
    _saveToPref();
    notifyListeners();
  }
}
