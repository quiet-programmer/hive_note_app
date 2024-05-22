import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:note_app/app/helpers/hive_manager.dart';
import 'package:note_app/app/src/app.dart';
import 'package:note_app/utils/const_values.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/providers/change_view_style_provider.dart';
import 'package:note_app/providers/hide_play_button_provider.dart';
import 'package:note_app/providers/theme_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize hive
  await HiveManager().init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ThemeProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ChangeViewStyleProvider(),
        ),
        ChangeNotifierProvider.value(
          value: HidePlayButtonProvider(),
        ),
        // Provider.value(
        //   value: UserModels(),
        // ),
      ],
      child: const App(),
    ),
  );
}
