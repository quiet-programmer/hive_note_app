import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:note_app/const_values.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/screens/home.dart';
import 'package:toast/toast.dart';

import '../utils/slide_transition.dart';

class CreateNoteScreen extends StatefulWidget {
  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  Box<NoteModel> storeData;

  TextEditingController _noteText = TextEditingController();

  TextStyle myTextStyle;
  TextAlign myTextAlign;

  bool _isNotEmpty;

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

  Future<bool> checkIfNoteIsNotEmpty() async {
    if (_noteText.text.isNotEmpty) {
      print('save the note');
      final String note = _noteText.text;
      NoteModel noteM = NoteModel(
        notes: note,
      );
      storeData.add(noteM);
      Toast.show("Note Saved", context, duration: 3, gravity: Toast.BOTTOM);
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return Home();
      }));
      _isNotEmpty = true;
    } else {
      print('text was not save');
      Toast.show(
        "Note was empty, nothing was saved",
        context,
        duration: 5,
      );
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return Home();
      }));
      _isNotEmpty = false;
    }
    return _isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: checkIfNoteIsNotEmpty,
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
          child: TextFormField(
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

          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: <Widget>[
          //     SafeArea(
          //       child: Container(
          //         width: MediaQuery.of(context).size.width,
          //         child: Align(
          //           alignment: Alignment.topCenter,
          //           child: TextStyleEditor(
          //             backgroundColor: Colors.white38,
          //             height: 220,
          //             textStyle: myTextStyle,
          //             onTextStyleChanged: (val) {
          //               setState(() {
          //                 myTextStyle = val;
          //               });
          //             },
          //             onTextAlignChanged: (val) {
          //               setState(() {
          //                 myTextAlign = val;
          //               });
          //             },
          //           ),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: ListView(children: [
          //         TextFormField(
          //           autofocus: true,
          //           controller: _noteText,
          //           decoration: InputDecoration(
          //             hintText: "Type Note...",
          //             border: InputBorder.none,
          //           ),
          //           style: myTextStyle,
          //           textAlign: myTextAlign,
          //           maxLines: height.toInt(),
          //         ),
          //       ]),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}