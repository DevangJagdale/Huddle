import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DisplayChats extends StatefulWidget {
  final String code;
  DisplayChats(this.code);
  @override
  _DisplayChatsState createState() => _DisplayChatsState();
}

class _DisplayChatsState extends State<DisplayChats> {
  List chat = [];
  List chatId = [];
  ScrollController _controller = ScrollController();

  bool checkUser(List name, List name1) {
    if (name[0] == name1[0])
      return true;
    else
      return false;
  }

  bool checkifgroupEmpty() {
    if (chat.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> getChatDetails() async {
    chat.clear();
    chatId.clear();

    await FirebaseDatabase.instance
        .reference()
        .child("users/${FirebaseAuth.instance.currentUser.displayName}/groups")
        .once()
        .then((DataSnapshot snapshot) {
      FirebaseDatabase.instance
          .reference()
          .child('groups/${widget.code}/chats')
          .orderByChild('content')
          .onChildAdded
          .forEach((event) {
        chat.add(event.snapshot.value["content"]);
        chatId.add(event.snapshot.value["uid"]);
        print(event.snapshot.value["content"]);
        print(event.snapshot.value["uid"]);
        print(chat);
        setState(() {
          print("set state");
          if (_controller.hasClients) {
            _controller.animateTo(_controller.position.maxScrollExtent,
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
          }
        });
      });
    });

    return chat;
  }

  void initState() {
    getChatDetails();

    print("display chat");
    print(chat);
    print(chat.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.animateTo(_controller.position.maxScrollExtent,
            duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
      }
    });
    return checkifgroupEmpty()
        ? Center(
            child: Text("Start Chatting :)"),
          )
        : Container(
            child: ListView.builder(
              reverse: false,
              controller: _controller,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 45),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Container(
                        alignment: checkUser(chatId[index],
                                [FirebaseAuth.instance.currentUser.displayName])
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                "Username : ${chatId[index].toString()}",
                                style: TextStyle(
                                  color: checkUser(chatId[index], [
                                    FirebaseAuth
                                        .instance.currentUser.displayName
                                  ])
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              Text("Message : ${chat[index].toString()}"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              itemCount: chat.length,
            ),
          );
  }
}
