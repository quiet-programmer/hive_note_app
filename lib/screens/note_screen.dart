import 'package:flutter/material.dart';
import 'package:note_app/const_values.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/screens/edit_screen.dart';
import 'package:note_app/utils/slide_transition.dart';

class NoteScreen extends StatefulWidget {
  final NoteModel note;
  final int notekey;

  NoteScreen({
    key,
    @required this.note,
    @required this.notekey,
  }) : super(key: key);

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final bool isEditing = true;

  Widget showText() {
    var test;
    setState(() {
      test = SelectableText(
        "${widget.note.notes}",
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.black54,
        ),
      );
    });
    return test;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        title: Text(
          "Read Note",
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MySlide(builder: (_) {
                return EditScreen(
                  notes: widget.note,
                  noteKey: widget.notekey,
                );
              }));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[showText()],
          ),
        ),
      ),
    );
  }
}
