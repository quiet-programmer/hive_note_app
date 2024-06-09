import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();

    // final hiveData = HiveManager().userModelBox;
    // return ValueListenableBuilder(
    //   valueListenable: hiveData.listenable(),
    //   builder: (context, Box<UserModel> userData, _) {
    //     if (userData.get(tokenKey) == null) {
    //       return OnBoardingScreen();
    //     } else {
    //       // return const HomeScreen();
    //       // return const PTabControl();
    //       return const MTabControl();
    //     }
    //   },
    // );
  }
}
