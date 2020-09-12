import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel {
  @HiveField(0)
  final String notes;

  @HiveField(1)
  final dynamic myStyle;

  NoteModel({
    this.notes,
    this.myStyle,
  });
}
