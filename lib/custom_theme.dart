import 'package:flutter/material.dart';
import 'package:note_app/const_values.dart';

ThemeData buildLightTheme() => ThemeData.light().copyWith(
      cardColor: Colors.white,
      backgroundColor: Colors.grey[100],
      accentColor: Colors.grey[800],
      scaffoldBackgroundColor: backColor,
      iconTheme: IconThemeData(
        color: defaultBlack,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: backColor,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: Colors.black,
        ),
      ),
      dividerColor: defaultBlack,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        textTheme: TextTheme(
          headline6: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.grey[900],
        ),
      ),
      dialogBackgroundColor: backColor,
      textTheme: Typography.blackCupertino,
    );

ThemeData buildDarkTheme() => ThemeData.dark().copyWith(
      cardColor: Colors.grey[850],
      backgroundColor: Colors.grey[900],
      accentColor: Colors.grey[400],
      scaffoldBackgroundColor: darkColor,
      dividerColor: defaultWhite,
      iconTheme: IconThemeData(
        color: defaultWhite,
      ),
      cardTheme: CardTheme(
        color: cardColor,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.grey[900],
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith(
          (states) => Colors.grey[400],
        ),
        trackColor: MaterialStateProperty.resolveWith(
          (states) => Colors.white,
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0.0,
        textTheme: TextTheme(
          headline6: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        color: Colors.grey[900],
        iconTheme: IconThemeData(
          color: Colors.grey[400],
        ),
      ),
      textTheme: Typography.whiteCupertino,
    );
