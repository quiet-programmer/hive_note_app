import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:note_app/const_values.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/screens/note_screen.dart';
import 'package:note_app/utils/slide_transition.dart';
import 'package:text_style_editor/text_style_editor.dart';
import 'package:toast/toast.dart';

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

  TextStyle myTextStyle;
  TextAlign myTextAlign;

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
    return Scaffold(
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
                  // myStyle: myTextStyle,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              child: ListView(
                children: [
                  TextFormField(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
