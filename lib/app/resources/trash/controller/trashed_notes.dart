import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:note_app/utils/const_values.dart';
import 'package:note_app/models/note_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TrashedNotes extends StatefulWidget {
  const TrashedNotes({Key? key}) : super(key: key);

  @override
  State<TrashedNotes> createState() => _TrashedNotesState();
}

class _TrashedNotesState extends State<TrashedNotes> {
  Box<NoteModel>? storeData;
  Box<NoteModel>? deletedData;

  @override
  void initState() {
    super.initState();
    storeData = Hive.box<NoteModel>(noteBox);
    deletedData = Hive.box<NoteModel>(deletedNotes);
  }

  void removeFromTrashDialog(key, NoteModel? note) {
    showDialog(
      context: context,
      builder: (_) {
        return Platform.isAndroid
            ? AlertDialog(
                title: const Text('Hi, there'),
                content:
                    const Text('Are you sure you want to recover this note?'),
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
                      NoteModel noteToRecover = NoteModel(
                        title: note!.title,
                        notes: note.notes,
                      );
                      storeData!.add(noteToRecover);
                      deletedData!.delete(key);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trashed Note'),
      ),
      body: deletedData!.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'No notes have been deleted',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Icon(
                    Icons.delete,
                    size: 60,
                  )
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ValueListenableBuilder(
                  valueListenable: deletedData!.listenable(),
                  builder: (context, Box<NoteModel> notes, _) {
                    List<int>? keys = notes.keys.cast<int>().toList();
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      primary: false,
                      shrinkWrap: true,
                      itemCount: keys.length,
                      itemBuilder: (context, index) {
                        final key = keys[index];
                        final NoteModel? note = notes.get(key);
                        return GestureDetector(
                          onLongPress: () {
                            removeFromTrashDialog(key, note);
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
                                          note.title == null || note.title == ''
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
                                              '${note.notes!.length >= 70 ? note.notes!.substring(0, 70) + '...' : note.notes}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                              ),
                                              softWrap: true,
                                            ),
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
