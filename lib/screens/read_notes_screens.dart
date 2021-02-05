import 'package:flutter/material.dart';
import 'package:note_app/const_values.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/screens/edit_note_screen.dart';
import 'package:note_app/utils/slide_transition.dart';

class ReadNotesScreen extends StatefulWidget {
  final NoteModel note;
  final int notekey;

  ReadNotesScreen({
    Key key,
    @required this.note,
    @required this.notekey,
  }) : super(key: key);

  @override
  _ReadNotesScreenState createState() => _ReadNotesScreenState();
}

class _ReadNotesScreenState extends State<ReadNotesScreen> {
  final bool isEditing = true;

  Widget showText() {
    var test;
    setState(() {
      test = SelectableText(
        '${widget.note.notes.toString()}',
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
    print(widget.note.notes.toString());
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        title: Text(
          'Read Note',
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
                return EditNoteScreen(
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Center(
                  child: Text(
                    '${widget.note.title}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              showText(),
            ],
          ),
        ),
      ),
    );
  }
}