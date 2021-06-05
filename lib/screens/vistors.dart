import 'package:SAKEC_GATE/screens/addVisitor.dart';
import 'package:SAKEC_GATE/widgets/drawer.dart';
import 'package:SAKEC_GATE/widgets/secuirtyVistor.dart';
import 'package:SAKEC_GATE/widgets/staffVisitors.dart';

import 'package:flutter/material.dart';
import 'package:SAKEC_GATE/global.dart' as global;


class Vistors extends StatefulWidget {
  @override
  _VistorsState createState() => _VistorsState();
}

class _VistorsState extends State<Vistors> {
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: global.role == "security"
          ? FloatingActionButton(
              child: new Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddVisitor()),
                );
              })
          : SizedBox(),
      appBar: AppBar(
        title: Text("Vistors"),
      ),
      drawer: CustomDrawer(),
      body: global.role =="staff"? StaffvisitorList() : SecurityList()
    );
  }
}

