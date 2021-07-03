import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:huddle/screens/home.dart';
import 'package:huddle/widgets/display_chats.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Group extends StatelessWidget {
  final String grpname;
  final String grpcode;

  Group(this.grpname, this.grpcode);

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        FirebaseDatabase.instance
            .reference()
            .child(
                "users/${FirebaseAuth.instance.currentUser.displayName}/groups/$grpcode")
            .remove()
            .whenComplete(() {
          FirebaseDatabase.instance
              .reference()
              .child("groups/$grpcode")
              .remove()
              .whenComplete(() {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (Route<dynamic> route) => false,
            );
          });
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Group"),
      content: Text("Would you like to delete $grpname group?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("$grpname"),
            Text(
              "Group code:$grpcode",
              style: TextStyle(fontSize: 10),
            )
          ],
        ),
        backgroundColor: Colors.black,
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              showAlertDialog(context);
            },
            child: Text("Delete Group"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: Grp(grpname, grpcode),
    );
  }
}

class Grp extends StatefulWidget {
  final String grpname;
  final String grpcode;

  Grp(this.grpname, this.grpcode);

  @override
  _GrpState createState() => _GrpState();
}

class _GrpState extends State<Grp> {
  bool loading = false;

  List chat = [];
  List chatId = [];

  Future getChatDetails() async {
    chat.clear();
    chatId.clear();
    // await FirebaseDatabase.instance
    //     .reference()
    //     .child("groups/${widget.grpcode}/chats")
    //     .once()
    //     .then((DataSnapshot snapshot) {
    //   //print(snapshot.value);
    //   Map<dynamic, dynamic>.from(snapshot.value).forEach((key, value) {
    //     //print(value["content"]);
    //     chat.add(value["content"]);
    //     chatId.add(value["uid"]);
    //   });
    // }).whenComplete(() {
    //   setState(() {
    //     loading = false;
    //   });
    // });

    // var query = FirebaseDatabase.instance
    //     .reference()
    //     .child('groups/${widget.grpcode}/chats')
    //     .orderByChild('content');
    // query.onChildAdded.forEach((event) {
    //   chat.add(event.snapshot.value["content"]);
    //   chatId.add(event.snapshot.value["uid"]);
    //   print(event.snapshot.value["content"]);
    //   print(event.snapshot.value["uid"]);
    //   print(chat);
    // });
    // setState(() {
    //   print("loading done");
    //   loading = false;
    // });
  }

  void initState() {
    // getChatDetails();
    // print("test");

    // print("chat");
    // print(chat);
    // print(chatId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    final messageController = TextEditingController();
    TextStyle style = TextStyle(fontSize: 17.0);
    final messageField = Theme(
      data: new ThemeData(
        primaryColor: Colors.amber,
      ),
      child: TextField(
        obscureText: false,
        controller: messageController,
        style: style,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  var us = FirebaseAuth.instance.currentUser;
                  var ref = FirebaseDatabase.instance;
                  ref
                      .reference()
                      .child("groups/${widget.grpcode}/chats")
                      .push()
                      .update({
                    "content": [messageController.text.trim()],
                    "uid": [us.displayName],
                  }).whenComplete(() {
                    messageController.clear();
                    getChatDetails();
                    print("done");
                  }).catchError((err) {
                    final snackBar = SnackBar(content: Text(err));

                    Scaffold.of(context).showSnackBar(snackBar);
                  });
                },
                color: Colors.amberAccent),
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Enter Message",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      ),
    );

    return Container(
      height: _screenSize.height,
      child: loading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("If you have any messages it will appear here"),
                ),
                SizedBox(height: 15),
                Center(child: CircularProgressIndicator()),
              ],
            )
          : Stack(
              alignment: Alignment.bottomCenter,
              children: [
                DisplayChats(widget.grpcode),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: messageField,
                )
              ],
            ),
    );
  }
}
