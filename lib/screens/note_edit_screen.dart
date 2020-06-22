import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:note_app/const_value.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/screens/home.dart';
import 'package:toast/toast.dart';

class NoteEditScreen extends StatefulWidget {
  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  Box<NoteModel> storeData;

  TextEditingController _noteText = TextEditingController();

  @override
  void initState() {
    super.initState();
    storeData = Hive.box<NoteModel>(noteBox);
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
        title: Text("Create note"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              final String note = _noteText.text;
              NoteModel noteM = NoteModel(
                notes: note,
              );
              storeData.add(noteM);
              print(noteM.notes);
              Toast.show("Note Saved", context,
                  duration: 3, gravity: Toast.BOTTOM);
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return Home();
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
                autofocus: true,
                controller: _noteText,
                decoration: InputDecoration(
                  hintText: "Type Note...",
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
