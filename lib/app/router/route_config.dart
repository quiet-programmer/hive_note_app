import 'package:go_router/go_router.dart';
import 'package:note_app/app/resources/home/controller/home.dart';
import 'package:note_app/app/resources/home/views/cloud_notes/auth/login_screen.dart';
import 'package:note_app/app/resources/home/views/cloud_notes/auth/register_screen.dart';
import 'package:note_app/app/resources/home/views/cloud_notes/auth/verify_code.dart';
import 'package:note_app/app/resources/home/views/cloud_notes/auth/wrapper.dart';
import 'package:note_app/app/resources/home/views/cloud_notes/controller/cloud_notes.dart';
import 'package:note_app/app/resources/home/views/cloud_notes/views/cloud_create_note.dart';
import 'package:note_app/app/resources/home/views/local_notes/create_note_screen.dart';
import 'package:note_app/app/resources/home/views/local_notes/edit_note_screen.dart';
import 'package:note_app/app/resources/home/views/local_notes/local_notes.dart';
import 'package:note_app/app/resources/home/views/local_notes/read_notes_screens.dart';
import 'package:note_app/app/resources/settings/controller/settings_screen.dart';
import 'package:note_app/app/router/route_name.dart';

class AppNavigation {
  AppNavigation._();

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: RouteName.home_screen,
        builder: (_, state) => HomeScreen(),
        routes: [
          // initiate routes
          GoRoute(
            path: 'local_notes',
            name: RouteName.local_notes,
            builder: (_, state) => const LocalNotesScreen(),
          ),
          GoRoute(
            path: 'cloud_notes',
            name: RouteName.cloud_notes,
            builder: (_, state) => const CloudNotesScreen(),
          ),
          GoRoute(
            path: 'settings_screen',
            name: RouteName.settings_screen,
            builder: (_, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'wrapper',
            name: RouteName.wrapper,
            builder: (_, state) => const Wrapper(),
          ),

          // ends here

          // Local Notes Route
          GoRoute(
            path: 'create_notes_screen',
            name: RouteName.create_notes_screen,
            builder: (_, state) => const CreateNoteScreen(),
          ),
          // ends here

          // Local Notes Route
          GoRoute(
            path: 'cloud_create_notes_screen',
            name: RouteName.cloud_create_notes_screen,
            builder: (_, state) => const CloudCreateNote(),
          ),
          // ends here

          // Auth Route
          GoRoute(
            path: 'login_screen',
            name: RouteName.login_screen,
            builder: (_, state) => const LoginScreen(),
          ),
          GoRoute(
            path: 'register_screen',
            name: RouteName.register_screen,
            builder: (_, state) => const RegisterScreen(),
          ),
          GoRoute(
            path: 'verify_code_screen',
            name: RouteName.verify_code_screen,
            builder: (_, state) => VerifyCode(
              from: state.uri.queryParameters['from'],
            ),
          ),
          // ends here
        ],
      ),
    ],
  );
}
