import 'package:flashy_flushbar/flashy_flushbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/app/router/route_config.dart';
import 'package:note_app/cubits/theme_cubit/theme_cubit.dart';
import 'package:note_app/utils/custom_theme.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme:
              context.watch<ThemeCubit>().state.isDarkTheme == false ? buildLightTheme() : buildDarkTheme(),
          title: 'VNotes',
          routerConfig: AppNavigation.router,
          builder: FlashyFlushbarProvider.init(),
        );
      },
    );
  }
}
