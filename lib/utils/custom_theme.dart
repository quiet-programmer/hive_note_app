import 'package:flutter/material.dart';
import 'package:note_app/utils/const_values.dart';

ThemeData buildLightTheme() => ThemeData.light().copyWith(
      cardColor: Colors.white,
      scaffoldBackgroundColor: backColor,
      iconTheme: const IconThemeData(
        color: defaultBlack,
      ),
      cardTheme: const CardTheme(
        color: Colors.white,
      ),
      dialogTheme: const DialogTheme(
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
        elevation: 0.0,
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        iconTheme: IconThemeData(
          color: Colors.grey[900],
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.resolveWith(
            (states) => const TextStyle(
              color: defaultBlack,
            ),
          ),
        ),
      ),
      dialogBackgroundColor: backColor,
      textTheme: Typography.blackCupertino,
    );

ThemeData buildDarkTheme() => ThemeData.dark().copyWith(
      cardColor: Colors.grey[850],
      scaffoldBackgroundColor: darkColor,
      dividerColor: defaultWhite,
      iconTheme: const IconThemeData(
        color: defaultWhite,
      ),
      cardTheme: CardTheme(
        color: cardColor,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.grey[900],
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(
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
        elevation: 0.0,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: Colors.grey[900],
        iconTheme: IconThemeData(
          color: Colors.grey[400],
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.resolveWith(
            (states) => const TextStyle(
              color: defaultBlack,
            ),
          ),
        ),
      ),
      textTheme: Typography.whiteCupertino,
    );
