import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/screens/note_screen.dart';
import 'package:note_app/utils/slide_transition.dart';
import 'package:toast/toast.dart';

import '../const_value.dart';

class EditScreen extends StatefulWidget {
  final NoteModel notes;
  final int noteKey;

  EditScreen({key, @required this.notes, @required this.noteKey})
      : super(key: key);
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  Box<NoteModel> storeData;

  var _noteText = TextEditingController();

  var coText;
  var _initValue = {'notes': '', 'conText': ''};

  var _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _noteText = widget.notes.notes;
    if (_isInit) {
      _initValue = {
        'notes': widget.notes.notes.toString(),
        'conText': widget.notes.notes.toString()
      };
    }
    _isInit = false;
  }

  @override
  void initState() {
    super.initState();
    storeData = Hive.box<NoteModel>(noteBox);
    // coText = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _noteText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit note"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              var key = widget.noteKey;
              String note = _initValue['notes'];
              NoteModel noteM = NoteModel(
                notes: note,
              );
              storeData.put(key, noteM);
              Toast.show("Note Saved", context,
                  duration: 3, gravity: Toast.BOTTOM);
              Navigator.of(context).pop();
              Navigator.of(context).push(MySlide(builder: (_) {
                return NoteScreen(note: noteM, notekey: key);
              }));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                initialValue: _initValue['notes'],
                autofocus: true,
                onChanged: (value) {
                  _initValue['notes'] = value;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 18.5,
                ),
                maxLines: height.toInt(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
