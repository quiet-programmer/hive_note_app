import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_app/screens/home.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // final NoteModel changeTheme = Hive.box(noteBox).get(appHiveKey);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
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
      ),
      title: "VNotes",
      home: Home(),
    );
  }
}
