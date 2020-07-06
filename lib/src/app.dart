import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_app/screens/home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          textTheme: TextTheme(
            headline6: TextStyle(
              fontSize: 25.0,
            ),
          ),
        ),
      ),
      title: "VNotes",
      home: Home(),
    );
  }
}
