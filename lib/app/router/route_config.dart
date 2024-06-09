import 'package:go_router/go_router.dart';
import 'package:note_app/app/resources/home/controller/home.dart';
import 'package:note_app/app/resources/home/views/cloud_notes/controller/cloud_notes.dart';
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

          // ends here

          // Local Notes Route
          GoRoute(
            path: 'create_notes_screen',
            name: RouteName.create_notes_screen,
            builder: (_, state) => const CreateNoteScreen(),
          ),
          // ends here
        ],
      ),
    ],
  );
}
