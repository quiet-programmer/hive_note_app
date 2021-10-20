import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note_app/providers/hide_play_button_provider.dart';
import 'package:note_app/providers/theme_provider.dart';
import 'package:note_app/services/auth.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
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
        title: Text('App Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Center(
          child: Container(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      //Body here
                      Container(
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
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: Icon(checkTheme.mTheme == false
                            ? Icons.brightness_3
                            : Icons.brightness_6),
                        title: Text(
                          'Enable Dark Theme',
                          style: TextStyle(),
                        ),
                        subtitle: Text('Not working right now'),
                        trailing: Switch(
                          value: checkTheme.mTheme,
                          onChanged: (val) {
                            checkTheme.checkTheme();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: Icon(Icons.play_arrow),
                        title: Text(
                          'Hide Play Button',
                          style: TextStyle(),
                        ),
                        subtitle: Text(
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
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: Icon(Icons.cloud_upload),
                        title: Text(
                          'Enable Cloud Storage',
                          style: TextStyle(),
                        ),
                        subtitle: Text(
                          'You will have to create an account with us \n(not available yet)',
                          style: TextStyle(),
                        ),
                        onTap: () {
                          // _authService.signUpWithGoogle(context);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: Icon(Icons.help_center_outlined),
                        title: Text(
                          'How the Cloud Storage works',
                          style: TextStyle(),
                        ),
                        subtitle: Text(
                          'All you need to know about what is going on when you signin \n(not available yet)',
                          style: TextStyle(),
                        ),
                        onTap: () {
                          // show a dialog or bottom panel sheet
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: Icon(Icons.delete),
                        title: Text(
                          'Delete all data from cloud',
                          style: TextStyle(),
                        ),
                        subtitle: Text(
                          'Request for all your notes to be deleted from cloud \n(not available yet)',
                          style: TextStyle(),
                        ),
                        onTap: () {},
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                        ),
                        title: Text(
                          'Sign Out',
                          style: TextStyle(),
                        ),
                        subtitle: Text(
                          'Sign out from cloud storage \n(not available yet)',
                          style: TextStyle(),
                        ),
                        onTap: () {
                          _authService.signUserOut();
                        },
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
