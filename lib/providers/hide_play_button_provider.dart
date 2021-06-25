import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HidePlayButtonProvider with ChangeNotifier {
  final String key = 'playButton';
  SharedPreferences _pref;
  bool _mPlayButton;

  bool get mPlayButton => _mPlayButton;

  HidePlayButtonProvider() {
    _mPlayButton = false;
    _loadFromPref();
  }

  Future _initPrefs() async {
    _pref == null ? _pref = await SharedPreferences.getInstance() : null;
  }

  void _loadFromPref() async {
    await _initPrefs();
    _mPlayButton = _pref.getBool(key) ?? false;
    notifyListeners();
  }

  void _saveToPref() async {
    await _initPrefs();
    await _pref.setBool(key, _mPlayButton);
  }

  void checkTheme() {
    _mPlayButton = !_mPlayButton;
    _saveToPref();
    notifyListeners();
  }
}
