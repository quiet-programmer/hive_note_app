import 'package:flutter/material.dart';
import 'package:note_app/app/screens/home.dart';
import 'package:note_app/custom_theme.dart';
import 'package:note_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({Key? key}) :super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final checkTheme = Provider.of<ThemeProvider>(context);
    // final NoteModel changeTheme = Hive.box(noteBox).get(appHiveKey);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: checkTheme.mTheme == false ? buildLightTheme() : buildDarkTheme(),
      title: 'VNotes',
      home: const Home(),
    );
  }
}
