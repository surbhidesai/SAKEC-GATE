import 'dart:developer';

import 'package:SAKEC_GATE/models/user.dart';
import 'package:SAKEC_GATE/screens/vistors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:SAKEC_GATE/global.dart' as global;
import 'noticeboard.dart';

class BottomBar extends StatefulWidget {
  int i;
  BottomBar({this.i=0});
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    NoticeBoard(),
    Vistors(),
  ];
  List<UserFirebase> users = [];
  List<UserFirebase> staffs = [];
  List<String>docum=[];

  final CollectionReference securityCollection =
      Firestore.instance.collection('security');
  final CollectionReference staffCollection =
      Firestore.instance.collection('staff');
  UserFirebase curruser;

 void  getStaffdetials() async {
    QuerySnapshot staff = await staffCollection.getDocuments();
    print("Staff Details");
    print(staff.documents[0].data.toString());
    setState(() {
      staffs =
          staff.documents.map((doc) => UserFirebase.fromDocument(doc)).toList();
    });
    staff.documents.forEach((result) {
      setState(() {
        print(result.data['fullName']);
        String s=result.data['fullName'].toString()+'_'+result.documentID;
        docum.add(s);
      });
    });
    global.doc=docum;





    global.staff = staffs;
    List<UserFirebase> data =
        staffs.where((row) => (row.email.contains(global.email))).toList();
    curruser = data[0];
    if(widget.i==0){
      global.name = curruser.fullName;
    }

  }

   void getSecDetials() async {
    QuerySnapshot sec = await securityCollection.getDocuments();
    print(sec.documents[0].data.toString());
    setState(() {
      users =
          sec.documents.map((doc) => UserFirebase.fromDocument(doc)).toList();
    });
    QuerySnapshot staff = await staffCollection.getDocuments();
    print(staff.documents[0].data.toString());
    setState(() {
      staffs =
          staff.documents.map((doc) => UserFirebase.fromDocument(doc)).toList();
    });
    staff.documents.forEach((result) {
      setState(() {
        print(result.data['fullName']);
        String s=result.data['fullName'].toString()+'_'+result.documentID;
        print(s);
        docum.add(s);
      });
    });
    global.doc=docum;
    global.staff = staffs;
    List<UserFirebase> data =
        users.where((row) => (row.email.contains(global.email))).toList();
    curruser = data[0];
    if(widget.i==0){
      global.name = curruser.fullName;
    }
    log(global.staff.toString());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    global.role == "staff" ? getStaffdetials() : getSecDetials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (ctx) => Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            label: 'Notice Board',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Vistors',
          ),
        ],
        selectedItemColor: Color((0xff51a4da)),
        onTap: _onItemTapped,
        backgroundColor: Color(0xfff9faff),
        unselectedItemColor: Color(0xff9095A5),
      ),
    );
  }
}
