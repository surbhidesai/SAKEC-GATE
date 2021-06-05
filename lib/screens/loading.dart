import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [Color(0xff52caf4), Color(0xff3080ed)])),
      child: Center(
        child: SpinKitRing(
          color: Colors.white,
          size: 50.0,
        )
      ),
    );
  }
}