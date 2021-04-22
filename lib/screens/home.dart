import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/const_values.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/screens/create_note_screen.dart';
import 'package:note_app/screens/read_notes_screens.dart';
import 'package:note_app/screens/settings_screen.dart';
import 'package:note_app/utils/slide_transition.dart';
import 'package:upgrader/upgrader.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Box<NoteModel> storeData;

  @override
  void initState() {
    super.initState();
    storeData = Hive.box<NoteModel>(noteBox);
  }

  void deleteDialog(key) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: backColor,
          titleTextStyle: TextStyle(
            color: Colors.black54,
          ),
          contentTextStyle: TextStyle(
            color: Colors.black54,
          ),
          title: Text('Warning'),
          content: Text('Are you sure you want to delete this note?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                storeData.delete(key);
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final NoteModel changeTheme = Hive.box(noteBox).get(appHiveKey);
    Upgrader().clearSavedSettings();
    final config = AppcastConfiguration(
      url: appCast,
      supportedOS: ['android'],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        // TODO:* adding support for localization soon.
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return SettingsScreen();
              }));
            },
            icon: Icon(
              Icons.settings,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MySlide(builder: (_) {
            return CreateNoteScreen();
          }));
        },
        backgroundColor: Colors.white60,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: UpgradeAlert(
        appcastConfig: config,
        debugLogging: true,
        countryCode: 'NG',
        dialogStyle: UpgradeDialogStyle.material,
        canDismissDialog: true,
        durationToAlertAgain: Duration(days: 1),
        child: storeData.isEmpty
            ? Center(
                child: Text(
                  'No Notes Yet...',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black54,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: ValueListenableBuilder(
                    valueListenable: storeData.listenable(),
                    builder: (context, Box<NoteModel> notes, _) {
                      List<int> keys = notes.keys.cast<int>().toList();
                      return StaggeredGridView.countBuilder(
                        physics: NeverScrollableScrollPhysics(),
                        primary: false,
                        shrinkWrap: true,
                        crossAxisCount: 4,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        addRepaintBoundaries: true,
                        itemBuilder: (_, index) {
                          final key = keys[index];
                          final NoteModel note = notes.get(key);
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MySlide(builder: (_) {
                                return ReadNotesScreen(
                                  note: note,
                                  noteKey: key,
                                );
                              }));
                            },
                            onLongPress: () {
                              deleteDialog(key);
                            },
                            child: note.title == null
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white38,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        '${note.notes}',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white38,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: backColor,
                                            ),
                                            child: Text(
                                              note.title == null ||
                                                      note.title == ''
                                                  ? 'No Title'
                                                  : '${note.title}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${note.notes}',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          );
                        },
                        itemCount: keys.length,
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.count(2, index.isEven ? 2 : 1),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
