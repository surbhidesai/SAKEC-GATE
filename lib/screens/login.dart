import 'dart:developer';

import 'package:SAKEC_GATE/models/user.dart';
import 'package:SAKEC_GATE/screens/bottombar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:SAKEC_GATE/screens/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SAKEC_GATE/widgets/auth_service.dart';
import 'package:SAKEC_GATE/global.dart' as global;
import 'package:SAKEC_GATE/widgets/Database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  String Role;
  LoginScreen({this.Role});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  double screenHeight;
  double screenWidth;
  bool _isloading = false;
  AuthService _auth = AuthService();
  String error = '';

  Crypt hashing(String pass) {
    final c1 = Crypt.sha256(pass);
    return c1;
  }

  void _onSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email.text);
    prefs.setString('password', password.text);
    prefs.setString('login', '1');
    prefs.setString('role', global.role);

    global.email = email.text;
    setState(() {
      _isloading = true;
    });
    print(email);
    Crypt pass = hashing(password.text);
    try {
      print(pass);
      await _auth
          .signInWithEmailAndPassword(
              email.text, password.text) // for hashing just replace by pass
          .then((result) async {
        if (result != null) {
          print(widget.Role);
          try {
            QuerySnapshot userInfoSnapshot =
                await DatabaseService().getUserData(email.text, widget.Role);
            print('USER INF');
            print(userInfoSnapshot.documents);
            if (userInfoSnapshot.documents.length == 0) {
              setState(() {
                error = 'Error signing in!';
                _isloading = false;
              });
            } else {
              setState(() {
                _isloading = false;
              });
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => BottomBar()),
                  (Route<dynamic> route) => false);
            }
          } catch (e) {
            setState(() {
              error = 'Error signing in!';
              _isloading = false;
            });
          }
        } else {
          setState(() {
            error = 'Error signing in!';
            _isloading = false;
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return _isloading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomPadding: true,
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    backgroundImage(context),
                    SizedBox(height: 10),
                    Text("Welcome Back,",
                        style: TextStyle(
                            color: Color(0xff51a4da),
                            fontSize: 25,
                            fontWeight: FontWeight.w300)),
                    SizedBox(height: 10),
                    Text("Log In!",
                        style: TextStyle(
                            color: Color(0xff51a4da),
                            fontSize: 35,
                            fontWeight: FontWeight.w600)),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: new InputDecoration(
                          labelText: "Email-ID",
                          contentPadding: EdgeInsets.all(8),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          focusColor: Colors.black,
                          labelStyle: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: new InputDecoration(
                          labelText: "Password",
                          contentPadding: EdgeInsets.all(8),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          focusColor: Colors.black,
                          labelStyle: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        InkWell(
                          onTap: () {},
                          child: Text(
                            "Forgot Password ? Click Here!",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        RawMaterialButton(
                          onPressed: () {
                            _onSignIn();
                          },
                          elevation: 2.0,
                          fillColor: Color(0xff51a4da),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 25.0,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    _divider(),
                    SizedBox(height: 10),
                    /* Container(
                height: 50,
                width: 250,
                child: RaisedButton(
                  onPressed: () {},
                  color: const Color(0xff51a4da),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.asset(
                        "assets/images/google.webp",
                        height: 20,
                        width: 20,
                      ),
                      Text("Continue with Google",
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
              ), */
                    Text(error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0)),
                  ],
                ),
              ),
            ),
          );
  }

  Widget backgroundImage(BuildContext context) {
    return Container(
      width: screenWidth,
      child: Image.asset(
        'assets/login_page_background.png',
        //height: 500,
        width: screenWidth,
        //fit: BoxFit.fill,
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          // Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
