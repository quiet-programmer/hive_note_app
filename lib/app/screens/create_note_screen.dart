import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:note_app/app/screens/home.dart';
import 'package:note_app/const_values.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/providers/theme_provider.dart';
import 'package:note_app/utils/slide_transition.dart';
import 'package:provider/provider.dart';


class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({Key? key}) : super(key: key);
  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  Box<NoteModel>? storeData;

  final TextEditingController _noteTitle = TextEditingController();
  final TextEditingController _noteText = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextStyle? myTextStyle;
  TextAlign? myTextAlign;

  bool? _isNotEmpty;

  final goToNotes = FocusNode();

  @override
  void initState() {
    super.initState();
    storeData = Hive.box<NoteModel>(noteBox);
    myTextStyle = const TextStyle(
      fontSize: 18.5,
    );
    myTextAlign = TextAlign.left;
  }

  @override
  void dispose() {
    super.dispose();
    _noteTitle.dispose();
    _noteText.dispose();
  }

  Future<bool> checkIfNoteIsNotEmptyWhenGoingBack() async {
    if (_noteText.text.isNotEmpty || _noteTitle.text.isNotEmpty) {
      final String noteTitle = _noteTitle.text;
      final String note = _noteText.text;
      NoteModel noteM = NoteModel(
        title: noteTitle,
        notes: note,
      );
      await storeData!.add(noteM);
      await Fluttertoast.showToast(
        msg: 'Note Saved',
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.of(context).pop();
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return const Home();
      }));
      _isNotEmpty = true;
    } else {
      await Fluttertoast.showToast(
        msg: 'Note was empty, nothing was saved',
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.of(context).pop();
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return const Home();
      }));
      _isNotEmpty = false;
    }
    return _isNotEmpty!;
  }

  void checkIfNoteIsNotEmptyAndSaveNote() {
    if (_noteTitle.text.isEmpty || _noteText.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Title or note body cannot be empty',
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    } else {
      final String noteTitle = _noteTitle.text;
      final String note = _noteText.text;
      NoteModel noteM = NoteModel(
        title: noteTitle,
        notes: note,
      );
      storeData!.add(noteM);
      Fluttertoast.showToast(
        msg: 'Note Saved',
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.of(context).pop();
      Navigator.of(context).push(MySlide(builder: (_) {
        return const Home();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkTheme = Provider.of<ThemeProvider>(context);
    var height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: checkIfNoteIsNotEmptyWhenGoingBack,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          // used a text form field for the app bar
          leading: Platform.isIOS
              ? IconButton(
                  icon: const Icon(CupertinoIcons.back),
                  onPressed: checkIfNoteIsNotEmptyWhenGoingBack)
              : null,
          title: TextFormField(
            autofocus: true,
            controller: _noteTitle,
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
          // ends here //
          centerTitle: false,
          actions: <Widget>[
            TextButton.icon(
              onPressed: () {
                checkIfNoteIsNotEmptyAndSaveNote();
              },
              icon: Icon(
                Icons.done,
                color: checkTheme.mTheme == false
                    ? Colors.black45
                    : Colors.white38,
              ),
              label: Text(
                'Save',
                style: TextStyle(
                  color: checkTheme.mTheme == false
                      ? Colors.black45
                      : Colors.white38,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              controller: _noteText,
              decoration: const InputDecoration(
                hintText: 'Type Note...',
                hintStyle: TextStyle(),
                border: InputBorder.none,
              ),
              textCapitalization: TextCapitalization.sentences,
              focusNode: goToNotes,
              style: myTextStyle,
              textAlign: myTextAlign!,
              maxLines: height.toInt(),
            ),

            //TODO! trying to add styling functionality, having issues
            //TODO! persisting the style for a saved note
          ),
        ),
      ),
    );
  }
}
