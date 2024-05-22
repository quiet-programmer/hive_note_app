import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/utils/const_values.dart';
import 'package:path_provider/path_provider.dart';

class HiveManager {
  static final HiveManager _instance = HiveManager._internal();

  factory HiveManager() {
    return _instance;
  }

  HiveManager._internal();

  static late Box<NoteModel> _noteModelBox;
  static late Box<NoteModel> _deleteNoteModelBox;

  Future<void> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    Hive
      ..init(directory.path)
      ..registerAdapter(NoteModelAdapter());
    _noteModelBox = await Hive.openBox<NoteModel>(noteBox);
    _deleteNoteModelBox = await Hive.openBox<NoteModel>(deletedNotes);
  }


  Box<NoteModel> get noteModelBox => _noteModelBox;
  Box<NoteModel> get deleteNoteModelBox => _deleteNoteModelBox;

}