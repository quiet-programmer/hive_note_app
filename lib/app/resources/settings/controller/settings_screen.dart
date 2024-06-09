import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/app/helpers/hive_manager.dart';
import 'package:note_app/app/resources/trash/controller/trashed_notes.dart';
import 'package:note_app/providers/hide_play_button_provider.dart';
import 'package:note_app/providers/theme_provider.dart';
import 'package:note_app/request/get_request.dart';
import 'package:note_app/utils/const_values.dart';
import 'package:note_app/utils/message_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? appName;
  String? packageName;
  String? version;
  String? buildNumber;

  bool isLoading = false;
  bool isLoadingRemoveKeys = false;

  Future logout() async {
    setState(() {
      isLoading = true;
    });

    final userModel = HiveManager().userModelBox;

    var res = await GetRequest.makeGetRequest(
      requestEnd: 'user/logout',
      bearer: userModel.get(tokenKey)!.accessToken,
      context: context,
    );

    logger.i(res);

    var status = res['status'];
    var msg = res['message'];

    try {
      if (status == 202) {
        userModel.delete(tokenKey);
        if (mounted) {
          context.pop();
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
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        appName = packageInfo.appName;
        packageName = packageInfo.packageName;
        version = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final checkTheme = Provider.of<ThemeProvider>(context);
    final checkButtonState = Provider.of<HidePlayButtonProvider>(context);
    final userModel = HiveManager().userModelBox;
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  //Body here
                  const SizedBox(
                    child: Column(
                      children: [
                        Text(
                          'VNotes',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'VNotes is a simple lite Note taking app, here to make Note taking easy.',
                          style: TextStyle(),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: Icon(checkTheme.mTheme == false
                        ? Icons.brightness_3
                        : Icons.brightness_6),
                    title: const Text(
                      'Enable Dark Theme',
                      style: TextStyle(),
                    ),
                    trailing: Switch(
                      value: checkTheme.mTheme,
                      onChanged: (val) {
                        checkTheme.checkTheme();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: const Icon(Icons.play_arrow),
                    title: const Text(
                      'Hide Play Button',
                      style: TextStyle(),
                    ),
                    subtitle: const Text(
                      'This will disable or hide the play '
                      'in the read note screen',
                    ),
                    trailing: Switch(
                      value: checkButtonState.mPlayButton,
                      onChanged: (val) {
                        checkButtonState.checkButtonState();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text(
                      'Trash',
                      style: TextStyle(),
                    ),
                    subtitle: const Text(
                      'You can recover any note you delete and'
                      ' also delete them permanently',
                      style: TextStyle(),
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return const TrashedNotes();
                      }));
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  userModel.get(tokenKey) == null
                      ? const SizedBox.shrink()
                      : ListTile(
                          leading: const Icon(Icons.logout),
                          title: Text(
                            isLoading == false ? 'Logout' : 'Please wait...',
                          ),
                          subtitle: const Text(
                            'This will log you out of you cloud account',
                            style: TextStyle(),
                          ),
                          onTap: isLoading == false
                              ? () {
                                  logout();
                                }
                              : null,
                        ),
                ],
              ),
            ),
            Flexible(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Platform.isAndroid
                    ? Text('$packageName Version $version')
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text('$packageName Version $version'),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
