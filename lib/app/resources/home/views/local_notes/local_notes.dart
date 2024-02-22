import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/app/resources/home/views/local_notes/read_notes_screens.dart';
import 'package:note_app/utils/const_values.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/providers/change_view_style_provider.dart';
import 'package:note_app/providers/theme_provider.dart';
import 'package:note_app/utils/slide_transition.dart';
import 'package:provider/provider.dart';

import 'create_note_screen.dart';

class LocalNotesScreen extends StatefulWidget {
  const LocalNotesScreen({Key? key}) : super(key: key);

  @override
  _LocalNotesScreenState createState() => _LocalNotesScreenState();
}

class _LocalNotesScreenState extends State<LocalNotesScreen> {
  Box<NoteModel>? storeData;
  Box<NoteModel>? deletedData;

  @override
  void initState() {
    super.initState();
    storeData = Hive.box<NoteModel>(noteBox);
    deletedData = Hive.box<NoteModel>(deletedNotes);
  }

  void deleteDialog(key, NoteModel note) {
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
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'No',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      NoteModel noteToDelete = NoteModel(
                        title: note.title,
                        notes: note.notes,
                      );
                      deletedData!.add(noteToDelete);
                      storeData!.delete(key);
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    child: const Text(
                      'Yes',
                    ),
                  ),
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
    final LocalNotesScreenViewStyle =
        Provider.of<ChangeViewStyleProvider>(context);
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
              LocalNotesScreenViewStyle.checkButtonState();
            },
            icon: Icon(
              LocalNotesScreenViewStyle.mChangeViewStyle == false
                  ? Icons.list
                  : Icons.grid_view_outlined,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isAndroid
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MySlide(builder: (_) {
                  return const CreateNoteScreen();
                }));
              },
              backgroundColor: checkTheme.mTheme == true ? cardColor : backColor,
              tooltip: 'Add Note',
              child: const Icon(
                Icons.add,
                color: defaultBlack,
              ),
            )
          : null,
      body: storeData!.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No Notes Yet... \n(Tap on the Add Button below)',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Icon(
                    Icons.arrow_downward_sharp,
                    size: 60,
                  )
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ValueListenableBuilder(
                  valueListenable: storeData!.listenable(),
                  builder: (context, Box<NoteModel> notes, _) {
                    List<int>? keys = notes.keys.cast<int>().toList();
                    return LocalNotesScreenViewStyle.mChangeViewStyle == false
                        ? MasonryGridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            primary: false,
                            shrinkWrap: true,
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 8.0,
                            addRepaintBoundaries: true,
                            itemCount: keys.length,
                            gridDelegate:
                                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
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
                                  deleteDialog(key, note!);
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
                                            mainAxisSize: MainAxisSize.min,
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
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      '${note.notes!.length >= 70 ? '${note.notes!.substring(0, 70)}...' : note.notes}',
                                                      style: const TextStyle(),
                                                      softWrap: true,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                              );
                            },
                            // staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 2 : 1),
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
                                  deleteDialog(key, note!);
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
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${note.notes!.length >= 70 ? '${note.notes!.substring(0, 70)}...' : note.notes}',
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                    softWrap: true,
                                                  ),
                                                  // const SizedBox(
                                                  //   height: 10,
                                                  // ),
                                                  // Text(
                                                  //   noteDate,
                                                  //   style: const TextStyle(
                                                  //     color: Colors.grey,
                                                  //     fontSize: 14,
                                                  //   ),
                                                  //   softWrap: true,
                                                  // ),
                                                ],
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
