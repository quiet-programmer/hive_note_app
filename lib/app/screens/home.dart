import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack_payment/flutter_paystack_payment.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_version/new_version.dart';
import 'package:note_app/app/screens/local_notes/local_notes.dart';
import 'package:note_app/app/screens/notifications/notifications_view.dart';
import 'package:note_app/app/screens/settings_screen.dart';
import 'package:note_app/const_values.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/providers/theme_provider.dart';
import 'package:note_app/utils/greetings.dart';
import 'package:note_app/utils/slide_transition.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'local_notes/create_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Box<NoteModel>? storeData;
  final plugin = PaystackPayment();

  @override
  void initState() {
    super.initState();
    storeData = Hive.box<NoteModel>(noteBox);
    initPlatformState();
    _checkVersion();
    plugin.initialize(publicKey: payStackPubKey);
  }

  void _checkVersion() async {
    final newVersion = NewVersion(
      androidId: 'com.viewus.v_notes',
    );
    final status = await newVersion.getVersionStatus();
    if (status!.canUpdate) {
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Update V Notes',
        dialogText: 'There is a new update for V Notes, '
            'would you like to update to check up '
            'what we have improved about the app',
        updateButtonText: 'Update now',
        dismissButtonText: 'Maybe Later',
      );
    }
  }

  Future startPayment() async {
    Charge charge = Charge()
      ..amount = 10000
      ..reference = 'dafsddafdfas'
      ..email = 'customer@email.com';
    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      charge: charge,
    );
  }

  static const String oneSignalAppId = 'e41ee34c-a2e9-4345-aa95-078b223419b3';

  @override
  Widget build(BuildContext context) {
    final checkTheme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('VNotes'),
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
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 SizedBox(
                  height: 30.h,
                ),
                Text(
                  'Hi 👋🏾, ${greetingMessage()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: checkTheme.mTheme == false
                      ? backColor.withOpacity(0.7)
                      : cardColor,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MySlide(builder: (_) {
                        return const LocalNotesScreen();
                      }));
                    },
                    child: Container(
                      height: 200.h,
                      width: 300.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sd_storage_outlined,
                              size: 100.r,
                              color: checkTheme.mTheme == false
                                  ? defaultBlack
                                  : defaultWhite,
                            ),
                            Text(
                              'Local Note',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: checkTheme.mTheme == false
                      ? backColor.withOpacity(0.7)
                      : cardColor,
                  child: InkWell(
                    onTap: () {
                      // Navigator.of(context).push(MySlide(builder: (_) {
                      //   return const LocalNotesScreen();
                      // }));
                      // startPayment();
                    },
                    child: Container(
                      height: 200.h,
                      width: 300.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_queue_outlined,
                              size: 100.r,
                              color: checkTheme.mTheme == false
                                  ? defaultBlack
                                  : defaultWhite,
                            ),
                            Text(
                              'Could Note',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Coming Soon...',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;

    OneSignal.shared.setAppId(oneSignalAppId);

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      logger.i(result.notification.body);
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return NotificationView(
          title: result.notification.title,
          body: result.notification.body,
        );
      }));
      // push to another screen.
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
            (OSNotificationReceivedEvent event) {
          logger.i(event.notification.body);
          // push to another screen
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return NotificationView(
              title: event.notification.title,
              body: event.notification.body,
            );
          }));

          /// Display Notification, send null to not display
          event.complete(null);
        });

    if (Platform.isIOS) {
      OneSignal.shared
          .setPermissionObserver((OSPermissionStateChanges changes) {
        logger.i("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
      });

      OneSignal.shared
          .promptUserForPushNotificationPermission()
          .then((accepted) {
        logger.i("Accepted permission: $accepted");
      });
    }
  }

}
