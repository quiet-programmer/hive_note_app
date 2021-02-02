import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:note_app/const_values.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/screens/note_screen.dart';
import 'package:note_app/utils/slide_transition.dart';
import 'package:toast/toast.dart';

class EditNoteScreen extends StatefulWidget {
  final NoteModel notes;
  final int noteKey;

  EditNoteScreen({key, @required this.notes, @required this.noteKey})
      : super(key: key);
  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  Box<NoteModel> storeData;

  TextStyle myTextStyle;
  TextAlign myTextAlign;

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
    myTextStyle = TextStyle(
      fontSize: 18.5,
      color: Colors.black54,
    );
    myTextAlign = TextAlign.left;
  }

  bool isEdited;

  Future<bool> verifyIfNoteIsEdited() async {
    if (_initValue['notes'].length > widget.notes.notes.toString().length) {
      print('save the note');
      var key = widget.noteKey;
      String note = _initValue['notes'];
      NoteModel noteM = NoteModel(
        notes: note,
      );
      storeData.put(key, noteM);
      Navigator.of(context).pop();
      Toast.show("Note Saved", context, duration: 3, gravity: Toast.BOTTOM);
      isEdited = true;
    } else {
      print('text was not save');
      Toast.show(
        "No changes made, nothing was saved",
        context,
        duration: 5,
      );
      Navigator.of(context).pop();
      isEdited = false;
    }
    return isEdited;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: verifyIfNoteIsEdited,
      child: Scaffold(
        backgroundColor: backColor,
        appBar: AppBar(
          title: Text("Edit note"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () {
                if (_initValue['notes'].isEmpty) {
                  return;
                } else {
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
                }
              },
              icon: Icon(
                Icons.done,
                color: Colors.black54,
              ),
              label: Text(
                "Update",
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
            initialValue: _initValue['notes'],
            autofocus: true,
            onChanged: (value) {
              _initValue['notes'] = value;
            },
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            style: myTextStyle,
            textAlign: myTextAlign,
            maxLines: height.toInt(),
          ),

          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.stretch,
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
          //       child: ListView(
          //         children: [
          //           TextFormField(
          //             initialValue: _initValue['notes'],
          //             autofocus: true,
          //             onChanged: (value) {
          //               _initValue['notes'] = value;
          //             },
          //             decoration: InputDecoration(
          //               border: InputBorder.none,
          //             ),
          //             style: myTextStyle,
          //             textAlign: myTextAlign,
          //             maxLines: height.toInt(),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
