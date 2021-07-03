import 'package:flutter/material.dart';
import 'package:huddle/screens/group.dart';

class DisplayGroups extends StatefulWidget {
  final List groupnames;
  final List groupcodes;
  DisplayGroups(this.groupnames, this.groupcodes);
  @override
  _DisplayGroupsState createState() => _DisplayGroupsState();
}

class _DisplayGroupsState extends State<DisplayGroups> {
  void initState() {
    print(widget.groupnames);

    super.initState();
  }

  bool checkifgroupEmpty() {
    if (widget.groupnames.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return checkifgroupEmpty()
        ? Center(
            child: Text("You are not subscribed to any group"),
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  height: 50,
                  color: Colors.amberAccent,
                  child: Center(
                    child: FlatButton(
                      color: Colors.amberAccent,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Group(
                                  widget.groupnames[index],
                                  widget.groupcodes[index])),
                        );
                      },
                      child: Text(widget.groupnames[index]),
                    ),
                  ),
                ),
              );
            },
            itemCount: widget.groupnames.length,
          );
  }
}
