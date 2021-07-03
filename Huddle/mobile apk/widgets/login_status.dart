import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/home.dart';
import '../screens/login.dart';

class LoginStatus extends StatefulWidget {
  @override
  _LoginStatusState createState() => _LoginStatusState();
}

class _LoginStatusState extends State<LoginStatus> {
  bool logincheck() {
    if (FirebaseAuth.instance.currentUser != null) {
      print('User is signed in!');
      return true;
    } else {
      print('User is currently signed out!');
      return false;
    }
    //return false;
    // FirebaseAuth.instance.authStateChanges().listen((User user) {
    //   print("inside auth");
    //   if (user == null) {
    //     print('User is currently signed out!');
    //     return false;
    //   } else {
    //     print('User is signed in!');
    //     return true;
    //   }
    // });

    // return false;
  }

  @override
  Widget build(BuildContext context) {
    return logincheck() ? Home() : Login();
  }
}
