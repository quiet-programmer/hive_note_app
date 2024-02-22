import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:note_app/app/resources/home/views/local_notes/read_notes_screens.dart';
import 'package:note_app/utils/const_values.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/providers/theme_provider.dart';
import 'package:note_app/utils/slide_transition.dart';
import 'package:provider/provider.dart';

class EditNoteScreen extends StatefulWidget {
  final NoteModel? notes;
  final int? noteKey;

  const EditNoteScreen({key, @required this.notes, @required this.noteKey})
      : super(key: key);
  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  Box<NoteModel>? storeData;
  final goToNotes = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextStyle? myTextStyle;
  TextAlign? myTextAlign;

  dynamic coText;
  var _initValue = {'notes': '', 'conText': ''};

  var _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _noteText = widget.notes.notes;
    if (_isInit) {
      _initValue = {
        'title': widget.notes!.title.toString(),
        'notes': widget.notes!.notes.toString(),
        'conText': widget.notes!.notes.toString()
      };
    }
    _isInit = false;
  }

  @override
  void initState() {
    super.initState();
    storeData = Hive.box<NoteModel>(noteBox);
    myTextStyle = const TextStyle(
      fontSize: 18.5,
    );
    myTextAlign = TextAlign.left;
  }

  bool? isEdited;

  //TODO? thinking of a better way to check for this
  // Future<bool> verifyIfNoteIsEdited() async {
  //   if (_initValue['notes'].length > widget.notes.notes.toString().length) {
  //     print('save the note');
  //     var key = widget.noteKey;
  //     String title = _initValue['title'];
  //     String note = _initValue['notes'];
  //     NoteModel noteM = NoteModel(
  //       title: title,
  //       notes: note,
  //     );
  //     storeData.put(key, noteM);
  //     Navigator.of(context).pop();
  //     Toast.show("Note Saved", context, duration: 3, gravity: Toast.BOTTOM);
  //     isEdited = true;
  //   } else {
  //     print('text was not save');
  //     Toast.show(
  //       "No changes made, nothing was saved",
  //       context,
  //       duration: 5,
  //     );
  //     Navigator.of(context).pop();
  //     isEdited = false;
  //   }
  //   return isEdited;
  // }

  @override
  Widget build(BuildContext context) {
    final checkTheme = Provider.of<ThemeProvider>(context);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: TextFormField(
          initialValue: _initValue['title'],
          autofocus: true,
          onChanged: (val) {
            _initValue['title'] = val;
          },
          decoration: const InputDecoration(
            hintText: 'Create Note Title...',
            hintStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            border: InputBorder.none,
          ),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(goToNotes);
          },
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
        ),
        centerTitle: false,
        actions: <Widget>[
          TextButton.icon(
            onPressed: () {
              if (_initValue['title']!.isEmpty ||
                  _initValue['notes']!.isEmpty) {
                Fluttertoast.showToast(
                  msg: 'Title or note body cannot be empty',
                  toastLength: Toast.LENGTH_SHORT,
                );
                return;
              } else {
                var key = widget.noteKey;
                String? title = _initValue['title'];
                String? note = _initValue['notes'];
                NoteModel noteM = NoteModel(
                  title: title!,
                  notes: note!,
                  // dateTime: DateTime.now().toString(),
                );
                storeData!.put(key, noteM);
                Fluttertoast.showToast(
                  msg: 'Note Saved',
                  toastLength: Toast.LENGTH_SHORT,
                );
                Navigator.of(context).pop();
                Navigator.of(context).push(MySlide(builder: (_) {
                  return ReadNotesScreen(note: noteM, noteKey: key);
                }));
              }
            },
            icon: Icon(
              Icons.done,
              color:
                  checkTheme.mTheme == false ? Colors.black45 : Colors.white38,
            ),
            label: Text(
              'Update',
              style: TextStyle(
                color: checkTheme.mTheme == false
                    ? Colors.black45
                    : Colors.white38,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: TextFormField(
          initialValue: _initValue['notes'],
          autofocus: true,
          onChanged: (value) {
            _initValue['notes'] = value;
          },
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          focusNode: goToNotes,
          style: myTextStyle,
          textCapitalization: TextCapitalization.sentences,
          textAlign: myTextAlign!,
          maxLines: height.toInt(),
        ),

        //TODO! trying to add styling functionality, having issues
        //TODO! persisting the style for a saved note
      ),
    );
  }
}
