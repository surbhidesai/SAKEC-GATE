import 'dart:developer';

import 'package:SAKEC_GATE/screens/bottombar.dart';
import 'package:SAKEC_GATE/widgets/Database.dart';
import 'package:SAKEC_GATE/widgets/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:SAKEC_GATE/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';
import 'login_option.dart';

class StartupScreen extends StatefulWidget {
  @override
  _StartupScreenState createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {

  bool _isloading = false;
  AuthService _auth = AuthService();
  String error = '';

  void _onSignIn( String email, String password, String role) async {

    global.email = email;
    setState(() {
      _isloading = true;
    });
    print(email);
    try {
      await _auth
          .signInWithEmailAndPassword(
              email, password) // for hashing just replace by pass
          .then((result) async {
        if (result != null) {
          try {
            QuerySnapshot userInfoSnapshot =
                await DatabaseService().getUserData(email, role);
            print('USER INF');
            print(userInfoSnapshot.documents);
            if (userInfoSnapshot.documents.length == 0) {
              Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginOption()),
            (Route<dynamic> route) => false);
            } else {
              setState(() {
                _isloading = false;
              });
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => BottomBar()),
                  (Route<dynamic> route) => false);
            }
          } catch (e) {
            Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginOption()),
            (Route<dynamic> route) => false);
          }
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginOption()),
            (Route<dynamic> route) => false);
        }
      });
    } catch (e) {
      print(e);
    }
  }
  void autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String login = prefs.getString('login');
    
    
    if (login == '1') {
      
      String email = prefs.getString('email');
      String password = prefs.getString('password');
      global.role = prefs.getString('role');
      
      _onSignIn(email,password, global.role) ;
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginOption()),
            (Route<dynamic> route) => false);
      });
    }
  }

  //MobileVerfication

  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    //startup screen to load user info and state

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Color(0xff52caf4), Color(0xff3080ed)])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/logo.png',
                height: 250,
                width: 250,
              ),
            ),
            Text("SAKEC GATE",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}
