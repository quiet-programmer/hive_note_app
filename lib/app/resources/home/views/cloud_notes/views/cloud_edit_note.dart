import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/app/helpers/hive_manager.dart';
import 'package:note_app/app/resources/home/views/cloud_notes/models/cloud_note_model.dart';
import 'package:note_app/app/resources/home/views/cloud_notes/views/cloud_read_note.dart';
import 'package:note_app/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/m_functions/navigate_to.dart';
import 'package:note_app/request/post_request.dart';
import 'package:note_app/utils/const_values.dart';
import 'package:provider/provider.dart';

class CloudEditNote extends StatefulWidget {
  final CloudNoteModel? notes;
  final int? noteKey;

  const CloudEditNote({
    super.key,
    @required this.notes,
    @required this.noteKey,
  });

  @override
  State<CloudEditNote> createState() => _CloudEditNoteState();
}

class _CloudEditNoteState extends State<CloudEditNote> {
  final goToNotes = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextStyle? myTextStyle;
  TextAlign? myTextAlign;

  dynamic coText;
  var _initValue = {'notes': '', 'conText': ''};

  var _isInit = true;

  Future editNote(String? title, String? notes, String? uuid) async {

    final userModel = HiveManager().userModelBox;
    final storeData = HiveManager().noteModelBox;

    var params = {
      'note_title': '$title',
      'note_content': '$notes',
      'note_uuid': '$uuid',
    };

    var res = await PostRequest.makePostRequest(
      requestEnd: 'user/edit_notes',
      params: params,
      context: context,
      bearer: userModel.get(tokenKey)!.accessToken,
    );

    logger.i(res);
  }

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
    myTextStyle = const TextStyle(
      fontSize: 18.5,
    );
    myTextAlign = TextAlign.left;
  }

  bool? isEdited;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    final storeData = HiveManager().cloudNoteModelBox;
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

                CloudNoteModel noteM = CloudNoteModel(
                  title: title!,
                  notes: note!,
                );

                editNote(title, note, widget.notes!.uuid);

                storeData.put(key, noteM);
                Fluttertoast.showToast(
                  msg: 'Note Saved',
                  toastLength: Toast.LENGTH_SHORT,
                );
                Navigator.pop(context);
                navigateTo(context,
                    destination: CloudReadNote(note: noteM, noteKey: key));
              }
            },
            icon: Icon(
              Icons.done,
              color:
              context.watch<ThemeCubit>().state.isDarkTheme == false ? Colors.black45 : Colors.white38,
            ),
            label: Text(
              'Update',
              style: TextStyle(
                color: context.watch<ThemeCubit>().state.isDarkTheme == false
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
