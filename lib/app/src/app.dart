import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/app/resources/home/controller/home.dart';
import 'package:note_app/utils/custom_theme.dart';
import 'package:note_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final checkTheme = Provider.of<ThemeProvider>(context);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme:
              checkTheme.mTheme == false ? buildLightTheme() : buildDarkTheme(),
          title: 'VNotes',
          home: const HomeScreen(),
        );
      },
    );
  }
}
