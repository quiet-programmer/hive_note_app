import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/app/helpers/hive_manager.dart';
import 'package:note_app/app/resources/home/views/cloud_notes/auth/login_screen.dart';
import 'package:note_app/app/resources/home/views/cloud_notes/controller/cloud_notes.dart';
import 'package:note_app/app/resources/home/views/cloud_notes/models/user_model.dart';
import 'package:note_app/utils/const_values.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final hiveData = HiveManager().userModelBox;
    return ValueListenableBuilder(
      valueListenable: hiveData.listenable(),
      builder: (context, Box<UserModel> userData, _) {
        if (userData.get(tokenKey) == null) {
          return const LoginScreen();
        } else {
          // return const HomeScreen();
          // return const PTabControl();
          return const CloudNotesScreen();
        }
      },
    );
  }
}
