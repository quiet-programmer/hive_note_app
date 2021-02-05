import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_app/const_values.dart';
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
      theme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0.0,
          shadowColor: Colors.transparent,
          color: Colors.transparent,
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.black54,
              fontSize: 25.0,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.black54,
          ),
        ),
        dialogBackgroundColor: backColor,
        dialogTheme: DialogTheme(
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      title: 'VNotes',
      home: Home(),
    );
  }
}
