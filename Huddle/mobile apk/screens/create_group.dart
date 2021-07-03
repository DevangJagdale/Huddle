import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import './home.dart';

class CreateGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Group"),
        backgroundColor: Colors.black,
      ),
      body: Creategrp(),
    );
  }
}

class Creategrp extends StatefulWidget {
  @override
  _CreategrpState createState() => _CreategrpState();
}

class _CreategrpState extends State<Creategrp> {
  final grpnameController = TextEditingController();

  TextStyle style = TextStyle(fontSize: 17.0);

  @override
  Widget build(BuildContext context) {
    int codeGenerator() {
      Random random = new Random();
      int randomNumber = random.nextInt(10000000);
      print("Group code is:");
      print(randomNumber);
      return randomNumber;
    }

    final grpnameField = TextField(
      obscureText: false,
      controller: grpnameController,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter Group Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final creategrpButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.amber,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (grpnameController.text != "") {
            print("group name is:");
            print(grpnameController.text);
            String groupcode = codeGenerator().toString();
            var us = FirebaseAuth.instance.currentUser;
            var ref = FirebaseDatabase.instance;
            ref.reference().child("users/${us.displayName}/groups").update({
              groupcode: "admin",
            });
            ref.reference().child("groups/${int.parse(groupcode)}").set({
              "Admin": ["${us.displayName}"],
              "Code": int.parse(groupcode),
              "Groupname": grpnameController.text.trim(),
              "member": ["${us.email}"],
            });

            print("Done");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (Route<dynamic> route) => false,
            );
          } else {
            final snackBar =
                SnackBar(content: Text("Please enter group name."));

            Scaffold.of(context).showSnackBar(snackBar);
          }
        },
        child: Text("Create Group",
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
            creategrpButon,
          ],
        ),
      ),
    );
  }
}
