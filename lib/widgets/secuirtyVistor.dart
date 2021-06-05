import 'package:SAKEC_GATE/models/visitor.dart';
import 'package:SAKEC_GATE/widgets/visitorcard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SecurityList extends StatefulWidget {
  @override
  _SecurityListState createState() => _SecurityListState();
}

class _SecurityListState extends State<SecurityList> {
  final CollectionReference visitorCollection = Firestore.instance.collection('visitors');
   List<Visitor> visitors = []; 
   QuerySnapshot snapshot;
   getVisitor() async {
     snapshot = await visitorCollection.orderBy("timestamp", descending: true).getDocuments();
    print(snapshot.documents[0].data.toString());
    setState(() {
      visitors =
          snapshot.documents.map((doc) => Visitor.fromDocument(doc)).toList();
    });
    print(visitors.toString());
  }

  @override
  void initState() {
    super.initState();
    getVisitor();
  }
  @override
  Widget build(BuildContext context) {
    return visitors.length > 0 ?  ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
          itemCount: visitors.length,
          itemBuilder: (context, index) {
            return VistorCard(
              name: visitors[index].name, 
              staff: visitors[index].staff,
              mediaurl: visitors[index].mediaURL,
              purpose: visitors[index].purpose,
              staffMobile: visitors[index].staffMobile,
              id: visitors[index].id ,
              status : visitors[index].status
            );
          }):
          Container();
  }
}
