import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/app/api/api_constant.dart';
import 'package:note_app/app/helpers/hive_manager.dart';
import 'package:note_app/app/src/app.dart';
import 'package:note_app/cubits/note_style_cubit/note_style_cubit.dart';
import 'package:note_app/cubits/play_button_cubit/play_button_cubit.dart';
import 'package:note_app/cubits/theme_cubit/theme_cubit.dart';
import 'package:provider/provider.dart';
import 'package:yaml/yaml.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize hive
  await HiveManager().init();

  loadApiCredentials();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<PlayButtonCubit>(
          create: (context) => PlayButtonCubit(),
        ),
        BlocProvider<NoteStyleCubit>(
          create: (context) => NoteStyleCubit(),
        ),
      ],
      child: const App(),
    ),
  );
}

Future<void> loadApiCredentials() async {
  String yamlString = await rootBundle.loadString('api_credentials.yaml');
  Map<dynamic, dynamic> yamlMap = loadYaml(yamlString);
  Map<String, dynamic> credentialsMap = Map<String, dynamic>.from(yamlMap);
  ApiConstants.apiUrl = credentialsMap['api_url'];
}
