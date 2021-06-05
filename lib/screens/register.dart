import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'bottombar.dart';
import 'package:SAKEC_GATE/screens/loading.dart';
import 'package:SAKEC_GATE/widgets/Database.dart';
import 'package:SAKEC_GATE/widgets/User.dart';
import 'package:SAKEC_GATE/global.dart' as global;
import 'package:firebase_messaging/firebase_messaging.dart';
class Register extends StatefulWidget {
  final FirebaseUser user;
  final String Role;
  Register({this.user,this.Role});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool checked = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  User _userFromFirebaseUser(FirebaseUser user) {
    return (user != null) ? User(uid: user.uid) : null;
  }
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String Token='';
  Future<void> _register () async{
    await _firebaseMessaging.getToken().then((token) {print(token);
    setState(() {
      Token=token;
    });
    }
    );
  }
  Future registerWithEmailAndPassword(
      String fullName,
      String email,
      String password,
      String mobile,
      String Token) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      // Create a new document for the user with uid
      if(widget.Role=='staff'){
      await DatabaseService(uid: user.uid).updateData(
          fullName, email, password, mobile,Token);
      return _userFromFirebaseUser(user);}
      else{
        await DatabaseService(uid: user.uid).updateUserData(
            fullName, email, password, mobile);
        return _userFromFirebaseUser(user);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  String fullName = '';
  String email = '';
  String password = '';
  String error = '';
  String DOB = '';
  String MobileNumber = '';
  void _onRegister(String MobileNumber) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      await registerWithEmailAndPassword(fullName, email, password,
          MobileNumber,Token)
          .then((result) async {
        if (result != null) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => BottomBar(i:1)));
        } else {
          setState(() {
            error = 'Error while registering the user!';
            _isLoading = false;
          });
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading():Scaffold(
      body: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [Color(0xff52caf4), Color(0xff3080ed)])),
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Welcome to SAKEC GATE",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 30.0),
                    /* Text("Register",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 25.0)), */
                    SizedBox(height: 20.0),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      onChanged: (val){
                        setState(() {
                          fullName=val;
                          global.name = val;
                          print(global.name);
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "First Name",
                        contentPadding: EdgeInsets.all(8),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Last Name",
                        contentPadding: EdgeInsets.all(8),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      onChanged: (val){
                        setState(() {
                          email=val;
                        });
                      },
                      
                      decoration: InputDecoration(
                        labelText: "Email",
                        
                        contentPadding: EdgeInsets.all(8),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (val) {
                        return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val)
                            ? null
                            : "Please enter a valid email";
                      },
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      onChanged: (val){
                        setState(() {
                          password=val;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Password",
                        contentPadding: EdgeInsets.all(8),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (val) =>
                          val.length < 6 ? 'Password not strong enough' : null,
                      obscureText: true,
                    ),
                    SizedBox(height: 15.0),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        contentPadding: EdgeInsets.all(8),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (val) {
                      if (val.isEmpty) {
                        return "Please Re-Enter New Password";

                      } else if (val.length < 6) {
                        return "Password must be atleast 6 characters long";
                      } else if (val != password) {
                        return "Password must be same as above";
                      } else {
                        return null;
                      }

                    }, 
                      obscureText: true,
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: 20.0),
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
                            "Agree to T&C",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  'Terms and Conditions',
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('ok'),
                                    onPressed: () {
                                      int count = 1;
                                      Navigator.popUntil(context, (route) {
                                        return count++ == 2;
                                      });
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: RaisedButton(
                          elevation: 0.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Text('Register',
                              style: TextStyle(
                                  color: Colors.blue, fontSize: 16.0)),
                          onPressed: ()async {
                            await _register();
                            _onRegister(widget.user.phoneNumber);
                          }
                          // _onRegister(widget.user.phoneNumber);
                          ),
                    ),
                    SizedBox(height: 10.0),
                    /* Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline),
//                            recognizer: TapGestureRecognizer()..onTap = () {
//                              widget.toggleView();
//                            },
                          ),
                        ],
                      ),
                    ), */
                    SizedBox(height: 10.0),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
