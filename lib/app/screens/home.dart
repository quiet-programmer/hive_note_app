import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_version/new_version.dart';
import 'package:note_app/app/screens/read_notes_screens.dart';
import 'package:note_app/app/screens/settings_screen.dart';
import 'package:note_app/const_values.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/providers/change_view_style_provider.dart';
import 'package:note_app/providers/theme_provider.dart';
import 'package:note_app/utils/slide_transition.dart';
import 'package:provider/provider.dart';

import 'create_note_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Box<NoteModel>? storeData;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    storeData = Hive.box<NoteModel>(noteBox);
    _checkVersion();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void _checkVersion() async {
    final newVersion = NewVersion(
      androidId: 'com.viewus.v_notes',
    );
    final status = await newVersion.getVersionStatus();
    if (status!.localVersion != status.storeVersion) {
      newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          dialogTitle: 'Update V Notes',
          dialogText: 'There is a new update for V Notes, '
              'would you like to update to check up '
              'what we have improved about the app',
          dismissAction: () {
            SystemNavigator.pop();
          },
          updateButtonText: 'Update now',
          dismissButtonText: 'Close');
    }
  }

  void deleteDialog(key) {
    showDialog(
      context: context,
      builder: (_) {
        return Platform.isAndroid
            ? AlertDialog(
                title: const Text('Warning'),
                content:
                    const Text('Are you sure you want to delete this note?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      storeData!.delete(key);
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(),
                    ),
                  )
                ],
              )
            : CupertinoAlertDialog(
                title: const Text('Warning'),
                content:
                    const Text('Are you sure you want to delete this note?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      storeData!.delete(key);
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(),
                    ),
                  ),
                ],
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final checkTheme = Provider.of<ThemeProvider>(context);
    final homeViewStyle = Provider.of<ChangeViewStyleProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        // TODO:* adding support for localization soon.
        actions: [
          if (Platform.isIOS)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MySlide(builder: (_) {
                  return const CreateNoteScreen();
                }));
              },
              icon: const Icon(
                CupertinoIcons.add_circled,
              ),
            ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return const SettingsScreen();
              }));
            },
            icon: const Icon(
              Icons.settings,
            ),
          ),
          IconButton(
            onPressed: () {
              homeViewStyle.checkButtonState();
            },
            icon: Icon(
              homeViewStyle.mChangeViewStyle == false
                  ? Icons.list
                  : Icons.grid_view_outlined,
            ),
          ),
        ],
      ),
      floatingActionButton: Platform.isAndroid
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MySlide(builder: (_) {
                  return const CreateNoteScreen();
                }));
              },
              backgroundColor: Colors.white60,
              child: const Icon(
                Icons.add,
              ),
            )
          : null,
      body: storeData!.isEmpty
          ? const Center(
              child: Text(
                'No Notes Yet...',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ValueListenableBuilder(
                  valueListenable: storeData!.listenable(),
                  builder: (context, Box<NoteModel> notes, _) {
                    List<int>? keys = notes.keys.cast<int>().toList();
                    return homeViewStyle.mChangeViewStyle == false
                        ? StaggeredGridView.countBuilder(
                            physics: const NeverScrollableScrollPhysics(),
                            primary: false,
                            shrinkWrap: true,
                            crossAxisCount: 4,
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 8.0,
                            addRepaintBoundaries: true,
                            itemBuilder: (_, index) {
                              final key = keys[index];
                              final NoteModel? note = notes.get(key);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MySlide(builder: (_) {
                                    return ReadNotesScreen(
                                      note: note,
                                      noteKey: key,
                                    );
                                  }));
                                },
                                onLongPress: () {
                                  deleteDialog(key);
                                },
                                child: note!.title == null
                                    ? Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.white38,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            '${note.notes}',
                                            style: const TextStyle(),
                                            softWrap: true,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        decoration: const BoxDecoration(
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
                                                padding:
                                                    const EdgeInsets.all(8),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  color:
                                                      checkTheme.mTheme == false
                                                          ? backColor
                                                          : Colors.grey[900],
                                                ),
                                                child: Text(
                                                  note.title == null ||
                                                          note.title == ''
                                                      ? 'No Title'
                                                      : '${note.title}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  softWrap: true,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${note.notes}',
                                                  style: const TextStyle(),
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
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            primary: false,
                            shrinkWrap: true,
                            itemCount: keys.length,
                            itemBuilder: (context, index) {
                              final key = keys[index];
                              final NoteModel? note = notes.get(key);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MySlide(builder: (_) {
                                    return ReadNotesScreen(
                                      note: note,
                                      noteKey: key,
                                    );
                                  }));
                                },
                                onLongPress: () {
                                  deleteDialog(key);
                                },
                                child: note!.title == null
                                    ? Column(
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white38,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                            child: ListTile(
                                              title: Text(
                                                '${note.notes}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white38,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                            child: ListTile(
                                              title: Text(
                                                note.title == null ||
                                                        note.title == ''
                                                    ? 'No Title'
                                                    : '${note.title}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                        ],
                                      ),
                              );
                            },
                          );
                  },
                ),
              ),
            ),
    );
  }
}