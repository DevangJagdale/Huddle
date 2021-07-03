import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home.dart';

class JoinGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Join Group"),
        backgroundColor: Colors.black,
      ),
      body: Joingrp(),
    );
  }
}

class Joingrp extends StatefulWidget {
  @override
  _JoingrpState createState() => _JoingrpState();
}

class _JoingrpState extends State<Joingrp> {
  TextStyle style = TextStyle(fontSize: 17.0);
  bool groupfound = false;
  final grpnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final grpnameField = TextField(
      obscureText: false,
      keyboardType: TextInputType.number,
      controller: grpnameController,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter Group Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final joingrpButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.amber,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          var us = FirebaseAuth.instance.currentUser;
          var ref = FirebaseDatabase.instance;
          ref.reference().child("groups/").once().then((DataSnapshot snapshot) {
            Map<dynamic, dynamic>.from(snapshot.value).forEach((key, values) {
              print(key);
              if (key == grpnameController.text) {
                print("found");
                groupfound = true;
                print(key);
                ref
                    .reference()
                    .child("groups/${grpnameController.text.trim()}/member")
                    .update({
                  "${us.uid}": ["${us.email}"]
                }).whenComplete(() {
                  ref
                      .reference()
                      .child("users/${us.displayName}/groups")
                      .update({
                    "${grpnameController.text.trim()}": "member",
                  });
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                    (Route<dynamic> route) => false,
                  );
                }).catchError((err) {
                  final snackBar = SnackBar(content: Text(err));

                  Scaffold.of(context).showSnackBar(snackBar);
                });
              } else {
                print("not found");
                groupfound = false;
              }
            });
          }).whenComplete(() {
            if (!groupfound) {
              final snackBar =
                  SnackBar(content: Text("No Group found with this code."));

              Scaffold.of(context).showSnackBar(snackBar);
            }
          });
        },
        child: Text("Join Group",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            grpnameField,
            SizedBox(
              height: 35.0,
            ),
            joingrpButon,
          ],
        ),
      ),
    );
  }
}
