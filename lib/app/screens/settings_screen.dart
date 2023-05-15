import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note_app/app/screens/trash_screen/trashed_notes.dart';
import 'package:note_app/providers/hide_play_button_provider.dart';
import 'package:note_app/providers/theme_provider.dart';
import 'package:package_info/package_info.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Center(
          child: SizedBox(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      //Body here
                      SizedBox(
                        child: Column(
                          children: const [
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
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                            return const TrashedNotes();
                          }));
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: const Icon(Icons.cloud_upload),
                        title: const Text(
                          'Enable Cloud Storage',
                          style: TextStyle(),
                        ),
                        subtitle: const Text(
                          'You will have to create an account with us \n(not available yet)',
                          style: TextStyle(),
                        ),
                        onTap: () {
                          // _authService.signUpWithGoogle(context);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: const Icon(Icons.help_center_outlined),
                        title: const Text(
                          'How the Cloud Storage works',
                          style: TextStyle(),
                        ),
                        subtitle: const Text(
                          'All you need to know about what is going on when you signin \n(not available yet)',
                          style: TextStyle(),
                        ),
                        onTap: () {
                          // show a dialog or bottom panel sheet
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete),
                        title: const Text(
                          'Delete all data from cloud',
                          style: TextStyle(),
                        ),
                        subtitle: const Text(
                          'Request for all your notes to be deleted from cloud \n(not available yet)',
                          style: TextStyle(),
                        ),
                        onTap: () {},
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                        ),
                        title: const Text(
                          'Sign Out',
                          style: TextStyle(),
                        ),
                        subtitle: const Text(
                          'Sign out from cloud storage \n(not available yet)',
                          style: TextStyle(),
                        ),
                        onTap: () {},
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
        ),
      ),
    );
  }
}
