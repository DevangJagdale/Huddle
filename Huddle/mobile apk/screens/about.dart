import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Builder(
        builder: (context) => Container(
          width: 500,
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Colors.amberAccent,
                  Colors.black,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Card(
            margin: EdgeInsets.all(50),
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                ),
                Text(
                  "About",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Huddle is a group based chat application made using flutter and firebase. This a basic application where user can create a group and other people can join that group using a group code that is generated at the time of creation of group. User can send messages on this. Project is made by Devang Jagdale",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
