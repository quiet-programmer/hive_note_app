import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class to toggle btw Grid View and List View for Home screen
class ChangeViewStyleProvider with ChangeNotifier {
  final String? key = 'changeViewStyle';
  SharedPreferences? _pref;
  bool? _mChangeViewStyle;

  bool get mChangeViewStyle => _mChangeViewStyle!;

  ChangeViewStyleProvider() {
    _mChangeViewStyle = false;
    _loadFromPref();
  }

  Future _initPrefs() async {
    _pref == null ? _pref = await SharedPreferences.getInstance() : null;
  }

  void _loadFromPref() async {
    await _initPrefs();
    _mChangeViewStyle = _pref!.getBool(key!) ?? false;
    notifyListeners();
  }

  void _saveToPref() async {
    await _initPrefs();
    await _pref!.setBool(key!, _mChangeViewStyle!);
  }

  void checkButtonState() {
    _mChangeViewStyle = !_mChangeViewStyle!;
    _saveToPref();
    notifyListeners();
  }
}
