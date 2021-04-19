import 'package:flutter/material.dart';
import 'package:note_app/services/auth.dart';
import 'package:package_info/package_info.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  String appName;
  String packageName;
  String version;
  String buildNumber;

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
                              'What VNotes is all about',
                              style: TextStyle(),
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
                        leading: Icon(Icons.cloud_upload),
                        title: Text(
                          'Enable Cloud Storage',
                          style: TextStyle(),
                        ),
                        subtitle: Text(
                          'All you need is to sign in with your Google account',
                          style: TextStyle(),
                        ),
                        onTap: () {
                          _authService.signUpWithGoogle(context);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: Icon(Icons.brightness_3),
                        title: Text(
                          'Enable Dark Theme',
                          style: TextStyle(),
                        ),
                        subtitle: Text('Not working right now'),
                        trailing: Switch(
                          value: false,
                          onChanged: (val) {},
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text('$packageName Version $version'),
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
