import 'package:SAKEC_GATE/screens/bottombar.dart';
import 'package:SAKEC_GATE/screens/mobile_verification.dart';
import 'package:flutter/material.dart';
import 'package:SAKEC_GATE/global.dart' as global;

class LoginOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [Color(0xff52caf4), Color(0xff3080ed)])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 70.0,
                // maxRadius: 66.0,
                child: Center(
                  child: Image.asset(
                    'assets/staff.png',
                    height: 100,
                    width: 100,
                  ),
                ),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.white)),
                onPressed: () {
                  global.role = "staff";
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        //builder: (context) => BottomBar()
                        builder: (context) => MobileVerfication("staff"),
                      ));
                },
                color: Colors.transparent,
                textColor: Colors.white,
                child:
                    Text("Staff".toUpperCase(), style: TextStyle(fontSize: 30)),
              ),
              SizedBox(
                height: 20,
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 70.0,
                // maxRadius: 66.0,
                child: Center(
                  child: Image.asset(
                    'assets/sec1.png',
                    height: 100,
                    width: 100,
                  ),
                ),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.white)),
                onPressed: () {
                  global.role = "security";
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MobileVerfication("security"),
                        //builder: (context) => BottomBar()
                      ));
                },
                color: Colors.transparent,
                textColor: Colors.white,
                child: Text("Security".toUpperCase(),
                    style: TextStyle(fontSize: 30)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
