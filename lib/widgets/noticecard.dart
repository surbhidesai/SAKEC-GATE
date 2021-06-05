import 'dart:developer';

import 'package:SAKEC_GATE/widgets/noticeDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:SAKEC_GATE/global.dart' as global;

class NoticeCard extends StatefulWidget {
  final String content;
  final String time;

  final String title;

  final String undersigned;

  final String id;

  NoticeCard({this.content, this.title, this.time, this.undersigned, this.id});

  @override
  _NoticeCardState createState() => _NoticeCardState();
}

class _NoticeCardState extends State<NoticeCard> {
  CollectionReference noticeCollection =
      Firestore.instance.collection('notice');
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.rss_feed),
            title: Text("Notice"),
            subtitle: Text(widget.time),
          ),
          ListTile(
              leading: Icon(Icons.message_outlined),
              title: Text(
                widget.title,
                overflow: TextOverflow.fade,
              )),
          ListTile(
              leading: Icon(Icons.person_outline_rounded),
              title: Text(
                widget.undersigned,
                overflow: TextOverflow.fade,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                child: Text("Read More"),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => NoticeDialog(
                            title: widget.title,
                            description: widget.content,
                            undersigned: widget.undersigned,
                          ));
                },
              ),
              global.role == "staff"
                  ? RaisedButton(
                      child: Text("Delete"),
                      onPressed: () {
                        noticeCollection.document(widget.id).delete(); 
                        log("Deleted");
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: new Text("Delete Notice"),
                                  content:
                                      new Text("Notice will be delete soon."),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('ok'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                ));
                      },
                    )
                  : SizedBox(width: 0),
            ],
          )
        ],
      ),
    );
  }
}
