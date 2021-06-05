import 'dart:developer';

import 'package:SAKEC_GATE/models/visitor.dart';
import 'package:SAKEC_GATE/widgets/visitorcard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:SAKEC_GATE/global.dart' as global;

class StaffvisitorList extends StatefulWidget {
  @override
  _StaffvisitorListState createState() => _StaffvisitorListState();
}

class _StaffvisitorListState extends State<StaffvisitorList> {
  final CollectionReference visitorCollection =
      Firestore.instance.collection('visitors');
  List<Visitor> visitors = [];
  List<Visitor> test = [] ; 
  QuerySnapshot snapshot ; 
   void getVisitor() async {
     snapshot = await visitorCollection.orderBy("timestamp", descending: true).getDocuments();
    print(snapshot.documents[0].data.toString());
    setState(() {
      test =
          snapshot.documents.map((doc) => Visitor.fromDocument(doc)).toList();
    });
    visitors = test.where((row) => (row.staff.contains(global.name))).toList();
    print(visitors.toString());
    log(global.name);
  }

  @override
  void initState() {
    super.initState();
    print('In Staff Visit');
    getVisitor();
  }

  @override
  Widget build(BuildContext context) {
    return visitors.length > 0
        ? ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
            itemCount: visitors.length,
            itemBuilder: (context, index) {
              return VistorCard(
                name: visitors[index].name,
                staff: visitors[index].staff,
                mediaurl: visitors[index].mediaURL,
                purpose: visitors[index].purpose,
                id: visitors[index].id  ,
                status: visitors[index].status
              );
            })
        : Container();
  }
}
