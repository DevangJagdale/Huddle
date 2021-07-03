import 'package:flutter/material.dart';
import './login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextStyle style = TextStyle(fontSize: 17.0);
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final usernameField = TextField(
      obscureText: false,
      controller: usernameController,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Username",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final emailField = TextField(
      obscureText: false,
      controller: emailController,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      controller: passController,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final signinButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.amber,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          FirebaseAuth.instance
              .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passController.text.trim(),
          )
              .then((value) async {
            var us = FirebaseAuth.instance.currentUser;
            FirebaseAuth.instance.currentUser
                .updateProfile(displayName: usernameController.text.trim());
            print("us is:");
            print(us);
            await us.reload();
            us = FirebaseAuth.instance.currentUser;
            print("us is:");
            print(us);
            FirebaseDatabase.instance
                .reference()
                .child("users/${us.displayName}")
                .set({
              "email": us.email,
              "username": us.displayName,
            });
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Login()),
              (Route<dynamic> route) => false,
            );
          }).catchError((err) {
            final snackBar = SnackBar(content: Text(err.toString()));

            Scaffold.of(context).showSnackBar(snackBar);
          });
        },
        child: Text("Sign Up",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
            elevation: 10,
            margin: EdgeInsets.all(30),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 155.0,
                        child: Image.asset(
                          "assets/favicon.png",
                          // fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 45.0),
                      Text(
                        "SignUp",
                        style: style.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 45.0),
                      usernameField,
                      SizedBox(height: 25.0),
                      emailField,
                      SizedBox(height: 25.0),
                      passwordField,
                      SizedBox(
                        height: 35.0,
                      ),
                      signinButon,
                      SizedBox(height: 25.0),
                      FlatButton(
                        child: Text(
                          "Click here to Login ->",
                          style: style.copyWith(
                            color: Colors.blueAccent,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                            (Route<dynamic> route) => false,
                          );
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
