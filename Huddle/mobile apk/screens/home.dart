import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huddle/screens/about.dart';
import 'package:huddle/screens/create_group.dart';
import 'package:huddle/screens/join_group.dart';
import 'package:huddle/screens/login.dart';
import 'package:huddle/screens/profile.dart';
import '../widgets/display_groups.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Huddle"),
        backgroundColor: Colors.black,
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Login()),
                (Route<dynamic> route) => false,
              );
            },
            child: Text("Logout"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Welcome Huddler'),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
            ),
            ListTile(
              title: Text('Create Group'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateGroup()),
                );
              },
            ),
            ListTile(
              title: Text('Join Group'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JoinGroup()),
                );
              },
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
            ),
            ListTile(
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => About()),
                );
              },
            ),
          ],
        ),
      ),
      body: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var groupnames = [];
  var groupcodes = [];
  bool loading = true;

  Future getProjectDetails() async {
    await FirebaseDatabase.instance
        .reference()
        .child("users/${FirebaseAuth.instance.currentUser.displayName}/groups")
        .once()
        .then((DataSnapshot snapshot) {
      print("snapshot is:");
      print(snapshot.value);
      Map<dynamic, dynamic>.from(snapshot.value).forEach((key, values) {
        //print(values);
        //print(key);
        groupcodes.add(key);
        FirebaseDatabase.instance
            .reference()
            .child("groups/$key/Groupname")
            .once()
            .then((DataSnapshot snapshot) {
          groupnames.add(snapshot.value);
          print(snapshot.value);
          setState(() {
            loading = false;
          });
          //return groupcodes;
          loading = false;
        });
      });
    });
    return groupnames;
  }

  void initState() {
    getProjectDetails();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //getProjectDetails();
    return loading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                    "If you have subscribed to any group it will appear here"),
              ),
              Text("Or else create or join a group..."),
              SizedBox(height: 15),
              Center(child: CircularProgressIndicator()),
            ],
          )
        : DisplayGroups(groupnames, groupcodes);
  }
}
