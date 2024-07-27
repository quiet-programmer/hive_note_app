import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/app/helpers/hive_manager.dart';
import 'package:note_app/app/resources/home/views/local_notes/edit_note_screen.dart';
import 'package:note_app/app/resources/home/views/local_notes/models/note_model.dart';
import 'package:note_app/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/m_functions/navigate_to.dart';
import 'package:note_app/providers/theme_provider.dart';
import 'package:note_app/request/post_request.dart';
import 'package:note_app/utils/const_values.dart';
import 'package:note_app/providers/hide_play_button_provider.dart';
import 'package:note_app/utils/message_dialog.dart';
import 'package:note_app/utils/slide_transition.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';

class ReadNotesScreen extends StatefulWidget {
  final NoteModel? note;
  final int? noteKey;

  const ReadNotesScreen({
    Key? key,
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
  FlutterTts? flutterTts;
  dynamic languages;
  String? language;
  double? volume = 0.5;
  double? pitch = 0.2;
  double? rate = 0.4;

  String? _newVoiceText;

  TtsState ttsState = TtsState.stopped;

  bool get isIOS => !kIsWeb && Platform.isIOS;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  bool get isWeb => kIsWeb;

  @override
  void initState() {
    super.initState();
    initTts();
    _onChange(widget.note!.notes.toString());
  }

  void initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    // flutterTts.setVoice("en-us-x-sfg#male_1-local");
    flutterTts!.setLanguage('en-Us');

    if (isAndroid) {
      _getEngines();
    }

    flutterTts!.setStartHandler(() {
      setState(() {
        logger.i('Playing');
        ttsState = TtsState.playing;
      });
    });

    flutterTts!.setCompletionHandler(() {
      setState(() {
        logger.i('Complete');
        ttsState = TtsState.stopped;
      });
    });

    flutterTts!.setCancelHandler(() {
      setState(() {
        logger.i('Cancel');
        ttsState = TtsState.stopped;
      });
    });

    if (isWeb || isIOS) {
      flutterTts!.setPauseHandler(() {
        setState(() {
          logger.i('Paused');
          ttsState = TtsState.paused;
        });
      });

      flutterTts!.setContinueHandler(() {
        setState(() {
          logger.i('Continued');
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts!.setErrorHandler((msg) {
      setState(() {
        logger.i('error: $msg');
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts!.getLanguages;
    if (languages != null) setState(() => languages);
  }

  Future _getEngines() async {
    var engines = await flutterTts!.getEngines;
    if (engines != null) {
      for (dynamic engine in engines) {
        logger.i(engine);
      }
    }
  }

  Future _speak() async {
    await flutterTts!.setVolume(volume!);
    await flutterTts!.setSpeechRate(rate!);
    await flutterTts!.setPitch(pitch!);

    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await flutterTts!.awaitSpeakCompletion(true);
        await flutterTts!.speak(_newVoiceText!);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts!.stop();
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
    flutterTts!.stop();
  }

  void _onChange(String text) {
    setState(() {
      _newVoiceText = text;
    });
  }

  final bool isEditing = true;

  Widget showText() {
    dynamic test;
    setState(() {
      test = SelectableText(
        widget.note!.notes.toString(),
        style: const TextStyle(
          fontSize: 18.0,
        ),
      );
    });
    return test;
  }

  bool isLoading = false;

  Future uploadNote() async {
    setState(() {
      isLoading = true;
    });

    final userModel = HiveManager().userModelBox;
    final storeData = HiveManager().noteModelBox;

    var params = {
      'note_title': '${widget.note!.title}',
      'note_content': '${widget.note!.notes}',
    };

    var res = await PostRequest.makePostRequest(
      requestEnd: 'user/move_to_cloud',
      params: params,
      context: context,
      bearer: userModel.get(tokenKey)!.accessToken,
    );

    logger.i(res);

    var status = res['status'];
    var msg = res['message'];

    try {
      if (status == 200) {
        logger.i('Yes');
        showSuccess('Uploaded');

        if (mounted) {
          Navigator.pop(context);
          storeData.delete(widget.noteKey);
        }
      }
    } catch (error) {
      if (error.toString().contains('Unhandled Exception')) {
        showError('Something went wrong, it\'s not you it\'s us.');
      }
      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkButtonState = Provider.of<HidePlayButtonProvider>(context);
    final hiveData = HiveManager().userModelBox;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Read Note',
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: <Widget>[
          isLoading == false
              ? hiveData.get(tokenKey) == null ? const SizedBox() : IconButton(
                  icon: const Icon(Icons.cloud_upload_outlined),
                  onPressed: isLoading == false
                      ? () {
                          uploadNote();
                        }
                      : null,
                )
              : SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    color: context.watch<ThemeCubit>().state.isDarkTheme == false
                        ? defaultBlack
                        : defaultWhite,
                  ),
                ),
          IconButton(
            icon: const Icon(Icons.mode_edit),
            onPressed: () {
              Navigator.pop(context);
              navigateTo(context,
                  destination: EditNoteScreen(
                    notes: widget.note,
                    noteKey: widget.noteKey,
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Center(
                  child: Text(
                    '${widget.note!.title}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(
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
              backgroundColor: Colors.white60,
              onPressed: () {
                ttsState == TtsState.stopped ? _speak() : _stop();
              },
              child: Icon(
                ttsState == TtsState.stopped
                    ? Icons.play_circle_outline
                    : Icons.stop_circle_outlined,
                color: Colors.black45,
              ),
            )
          : null,
    );
  }
}
