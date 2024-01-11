import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class uiHelper {
  static CustomAlertBox(BuildContext context, String title, String content) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
          );
        });
  }

  static checkUser(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        return print('User is currently signed out!');
      } else {
        return print('User is signed in!');
      }
    });
  }
}
