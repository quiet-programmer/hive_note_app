import 'package:flutter/material.dart';
import 'package:note_app/custom_theme.dart';
import 'package:note_app/screens/home.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    // final NoteModel changeTheme = Hive.box(noteBox).get(appHiveKey);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      title: 'VNotes',
      home: Home(),
    );
  }
}
