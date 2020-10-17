import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:note_app/const_values.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/screens/home.dart';
import 'package:text_style_editor/text_style_editor.dart';
import 'package:toast/toast.dart';

import '../utils/slide_transition.dart';

class NoteEditScreen extends StatefulWidget {
  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  Box<NoteModel> storeData;

  TextEditingController _noteText = TextEditingController();

  TextStyle myTextStyle;
  TextAlign myTextAlign;

  @override
  void initState() {
    super.initState();
    storeData = Hive.box<NoteModel>(noteBox);
    myTextStyle = TextStyle(
      fontSize: 18.5,
      color: Colors.black54,
    );
    myTextAlign = TextAlign.left;
  }

  @override
  void dispose() {
    super.dispose();
    _noteText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return Home();
        }));
      },
      child: Scaffold(
        backgroundColor: backColor,
        appBar: AppBar(
          title: Text("Create note"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () {
                if (_noteText.text.isEmpty) {
                  return;
                } else {
                  final String note = _noteText.text;
                  final TextStyle style = myTextStyle;
                  print("This is the Style....................$style");
                  NoteModel noteM = NoteModel(
                    notes: note,
                  );
                  storeData.add(noteM);
                  Toast.show("Note Saved", context,
                      duration: 3, gravity: Toast.BOTTOM);
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MySlide(builder: (_) {
                    return Home();
                  }));
                }
              },
              icon: Icon(
                Icons.done,
                color: Colors.black54,
              ),
              label: Text(
                "Save",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SafeArea(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: TextStyleEditor(
                      backgroundColor: Colors.white38,
                      height: 220,
                      textStyle: myTextStyle,
                      onTextStyleChanged: (val) {
                        setState(() {
                          myTextStyle = val;
                        });
                      },
                      onTextAlignChanged: (val) {
                        setState(() {
                          myTextAlign = val;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(children: [
                  TextFormField(
                    autofocus: true,
                    controller: _noteText,
                    decoration: InputDecoration(
                      hintText: "Type Note...",
                      border: InputBorder.none,
                    ),
                    style: myTextStyle,
                    textAlign: myTextAlign,
                    maxLines: height.toInt(),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
