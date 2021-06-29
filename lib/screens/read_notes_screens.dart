import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/providers/hide_play_button_provider.dart';
import 'package:note_app/screens/edit_note_screen.dart';
import 'package:note_app/utils/slide_transition.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';

class ReadNotesScreen extends StatefulWidget {
  final NoteModel note;
  final int noteKey;

  ReadNotesScreen({
    Key key,
    @required this.note,
    @required this.noteKey,
  }) : super(key: key);

  @override
  _ReadNotesScreenState createState() => _ReadNotesScreenState();
}

enum TtsState {
  playing,
  stopped,
  paused,
  continued,
}

class _ReadNotesScreenState extends State<ReadNotesScreen> {
  FlutterTts flutterTts;
  dynamic languages;
  String language;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.9;

  String _newVoiceText;

  TtsState ttsState = TtsState.stopped;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWeb => kIsWeb;

  @override
  void initState() {
    super.initState();
    initTts();
    _onChange(widget.note.notes.toString());
  }

  void initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    // flutterTts.setVoice("en-us-x-sfg#male_1-local");
    flutterTts.setLanguage('en-Us');

    if (isAndroid) {
      _getEngines();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print('Playing');
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print('Complete');
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print('Cancel');
        ttsState = TtsState.stopped;
      });
    });

    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
        setState(() {
          print('Paused');
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          print('Continued');
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print('error: $msg');
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    if (languages != null) setState(() => languages);
  }

  Future _getEngines() async {
    var engines = await flutterTts.getEngines;
    if (engines != null) {
      for (dynamic engine in engines) {
        print(engine);
      }
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(_newVoiceText);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  // Android does not support pause as of this moment
  // Future _pause() async {
  //   var result =
  //       await flutterTts.setSilence(widget.note.notes.toString().length);
  //   if (result == 1) setState(() => ttsState = TtsState.paused);
  // }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  void _onChange(String text) {
    setState(() {
      _newVoiceText = text;
    });
  }

  final bool isEditing = true;

  Widget showText() {
    var test;
    setState(() {
      test = SelectableText(
        '${widget.note.notes.toString()}',
        style: TextStyle(
          fontSize: 18.0,
        ),
      );
    });
    return test;
  }

  @override
  Widget build(BuildContext context) {
    final checkButtonState = Provider.of<HidePlayButtonProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Read Note',
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MySlide(builder: (_) {
                return EditNoteScreen(
                  notes: widget.note,
                  noteKey: widget.noteKey,
                );
              }));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Center(
                  child: Text(
                    '${widget.note.title}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              showText(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: checkButtonState.mPlayButton == false
          ? FloatingActionButton(
              child: Icon(
                ttsState == TtsState.stopped
                    ? Icons.play_circle_outline
                    : Icons.stop_circle_outlined,
                color: Colors.black45,
              ),
              backgroundColor: Colors.white60,
              onPressed: () {
                ttsState == TtsState.stopped ? _speak() : _stop();
              },
            )
          : null,
    );
  }
}
