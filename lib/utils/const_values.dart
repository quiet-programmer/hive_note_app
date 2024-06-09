import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:note_app/app/api/api_constant.dart';
import 'package:note_app/utils/hex_to_color.dart';

var logger = Logger();

// String apiUrl = dotenv.env['API_URL'].toString();
// String payStackPubKey = dotenv.env['PAYSTACK_PUB_KEY'].toString();
// String payStackSecKey = dotenv.env['PAYSTACK_SEC_KEY'].toString();

String apiUrl = ApiConstants.apiUrl;

const String androidID = 'com.viewus.v_notes';
const String dialogTitle = 'Update V Notes';
const String dialogText = 'There is a new update for V Notes, '
    'would you like to update to check up '
    'what we have improved about the app';

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
const String cloudNoteBox = 'cloudNoteBox';
const String userBox = 'userBox';
const String deletedNotes = 'deletedNotes';
const String appHiveKey = 'state';
const String deleteNote = 'deleteNote';


const String userKey = 'userKey';
const String tokenKey = 'tokenKey';

Color transparent = Colors.transparent;
Color grey = hexToColor('#AFACAB');
Color mGrey = grey.withOpacity(0.4);
