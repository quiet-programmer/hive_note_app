import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future navigateTo(BuildContext context, {required Widget destination}) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => destination));
}

Future navigateReplaceTo(BuildContext context, {required Widget destination}) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => destination));
}

Future navigateEndTo(BuildContext context, {required Widget destination}) {
  return Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => destination), (route) => false);
}

void clearAndNavigate(BuildContext context, {String? path, Map<String, dynamic>? queryParameters}) {
  while (context.canPop() == true) {
    context.pop();
  }

  if(queryParameters == null) {
    context.pushReplacementNamed(path!);
  } else {
    context.pushReplacementNamed(path!, queryParameters: queryParameters);
  }
}