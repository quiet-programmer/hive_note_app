import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //user note collection
  final CollectionReference _userNoteCollection =
      FirebaseFirestore.instance.collection('userNotes');

  Future uploadNotesToCloud(Map userNotes, noteKey, context) async {
    if (_userNoteCollection.doc().id != uid) {
      //this is for if the user already has any data in the collection
      return await _userNoteCollection
          .doc(uid)
          .collection('userNoteArray')
          .doc(noteKey.toString())
          .set({
            'userNotes': FieldValue.arrayUnion([userNotes]),
          })
          .then(
            (value) => Flushbar(
              message: 'Notes have been uploaded',
              duration: Duration(seconds: 4),
              backgroundColor: Colors.green,
            )..show(context),
          )
          .catchError(
            (error) => Flushbar(
              message: 'Error uploading notes',
              duration: Duration(seconds: 4),
              backgroundColor: Colors.red,
            )..show(context),
          );
    } else {
      //this is for if the user does not have any data in the collection
      return await _userNoteCollection
          .doc(uid)
          .collection('userNoteArray')
          .doc(noteKey.toString())
          .set({
            'userNotes': userNotes,
          })
          .then(
            (value) => Flushbar(
              message: 'Cloud Session has been created',
              duration: Duration(seconds: 4),
              backgroundColor: Colors.green,
            )..show(context),
          )
          .catchError(
            (error) => Flushbar(
              message: 'Error uploading notes',
              duration: Duration(seconds: 4),
              backgroundColor: Colors.red,
            )..show(context),
          );
    }
  }

  //list of all notes in database
  // List<CloudNoteModel> _listOfNotesData(QuerySnapshot snapshot) {
  //   return snapshot.docs.map((doc) {
  //     return CloudNoteModel(
  //       id: doc['key'] ?? '',
  //       title: doc['title'] ?? '',
  //       noteBody: doc['noteBody'] ?? '',
  //     );
  //   }).toList();
  // }

  // Stream<List<CloudNoteModel>> get allNotes {
  //   return _userNoteCollection
  //       .doc()
  //       .collection('userNoteArray')
  //       .snapshots()
  //       .map(_listOfNotesData);
  // }
}
