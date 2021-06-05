import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateNotice extends StatefulWidget {
  @override
  _CreateNoticeState createState() => _CreateNoticeState();
}

class _CreateNoticeState extends State<CreateNotice> {
  final _formKey = GlobalKey<FormState>();
  bool checked = false;
  final DateTime timestamp = DateTime.now();
  String noticeID = Uuid().v4();
  TextEditingController title = TextEditingController();
  TextEditingController undersign = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController content = TextEditingController();
  final CollectionReference noticeCollection =
      Firestore.instance.collection('notice');

  postNotice() async {
    await noticeCollection.document(noticeID).setData({
      "noticeID": noticeID,
      "timestamp": timestamp.toString(),
      "title": title.text,
      "content": content.text,
      "undersigning": undersign.text
    });
      Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Notice"),
      ),
      body: Form(
          key: _formKey,
          child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
              children: <Widget>[
                TextFormField(
                  //style: TextStyle(color: Colors.white),
                  controller: title,
                  decoration: InputDecoration(
                    labelText: "Title",
                    contentPadding: EdgeInsets.all(8),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  controller: content,
                  decoration: InputDecoration(
                    labelText: "Content",
                    contentPadding: EdgeInsets.all(8),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  //style: TextStyle(color: Colors.white),
                  controller: undersign,
                  decoration: InputDecoration(
                    labelText: "Undersigning",
                    contentPadding: EdgeInsets.all(8),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(
                      hoverColor: Colors.white,
                      onChanged: (value) {
                        setState(() {
                          checked = true;
                        });
                      },
                      value: checked,
                    ),
                    InkWell(
                      child: Text(
                        "Verified",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      onTap: () {},
                    )
                  ],
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: RaisedButton(
                      elevation: 0.0,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Text('Post Notice',
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.0)),
                      onPressed: () {
                        postNotice();
                        //Navigator.of(context).pop();
                      }
                      // _onRegister(widget.user.phoneNumber);
                      ),
                ),
              ])),
    );
  }
}
