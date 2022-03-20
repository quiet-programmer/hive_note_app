import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

var logger = Logger();

const Color backColor = Color.fromRGBO(224, 211, 175, 1);

const Color appbarColor = Color.fromRGBO(48, 48, 48, 1);
const Color bodyColor = Color.fromRGBO(33, 33, 33, 1);

//other colors
const defaultWhite = Color.fromRGBO(255, 255, 255, 1);
const defaultBlack = Color.fromRGBO(0, 0, 0, 1);

// dark and light theme color
Color? darkColor = Colors.grey[900];
const darkColorTwo = Color.fromRGBO(32, 32, 96, 1);

Color? cardColor = Colors.grey[850];

// Hive details
const String noteBox = 'notebox';
const String deletedNotes = 'deletedNotes';
const String appHiveKey = 'state';
const String deleteNote = 'deleteNote';
