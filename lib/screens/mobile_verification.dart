import 'package:SAKEC_GATE/screens/login.dart';
import 'package:SAKEC_GATE/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
final _phoneController = TextEditingController();
final _codeController = TextEditingController();
String Role;
Future registerUser(String mobile, BuildContext context) async {
  //code
  FirebaseAuth _auth = FirebaseAuth.instance;
  _auth.verifyPhoneNumber(
    phoneNumber: mobile,
    timeout: Duration(seconds: 60),
    verificationCompleted: (AuthCredential authCredential) {
//code for signing in
      _auth.signInWithCredential(authCredential).then((AuthResult result) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Register(
                user: result.user,Role: Role,
              ),
            ));
      }).catchError((String e) {
        print("error in sign in with cred");
        print(e);
      });
    },
    verificationFailed: (AuthException authException) {
      print(authException.message);
    },
    codeSent: (String verificationId, [int forceResendingToken]) {
      //show dialog to take input from the user
      showDialog<dynamic>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text("Enter SMS Code"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _codeController,
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Done"),
                textColor: Colors.white,
                color: Color(0xff51a4da),
                onPressed: () {
                  FirebaseAuth auth = FirebaseAuth.instance;

                  String smsCode = _codeController.text.trim();

                  AuthCredential _credential =
                  PhoneAuthProvider.getCredential(
                      verificationId: verificationId, smsCode: smsCode);
                  auth
                      .signInWithCredential(_credential)
                      .then((AuthResult result) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register(
                            user: result.user,
                            Role: Role,
                          ),
                        ));
                  }).catchError((String e) {
                    print("error in singin cred");
                    print(e);
                  });
                },
              )
            ],
          ));
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      verificationId = verificationId;
      print(verificationId);
      print("Timout");
    },
  );
}
class MobileVerfication extends StatefulWidget {
  final String role;
  MobileVerfication(this.role);
  @override
  _MobileVerficationState createState() => _MobileVerficationState();
}

class _MobileVerficationState extends State<MobileVerfication> {
  final _phoneController = TextEditingController();

  final _passController = TextEditingController();

  double screenHeight, screenWidth;


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          backgroundImage(context),
          logo(context),
          login(context)
        ],
      ),
    ));
  }

  Widget backgroundImage(BuildContext context) {
    return Container(
      width: screenWidth,
      child: Image.asset(
        'assets/start_page_background.png',
        height: screenHeight,
        width: screenWidth,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget logo(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 7),
      child: Center(
        child: Image.asset(
          'assets/logo.png',
          height: screenHeight / 2,
          width: screenWidth / 2,
        ),
      ),
    );
  }

  Widget login(context) {
    return Padding(
      padding:
          EdgeInsets.only(top: 3.8 * (MediaQuery.of(context).size.height) / 5),
      child: Center(
        child: Column(
          children: <Widget>[
            Form(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /* Text(
                        "Please Enter Your Mobile Number",
                        style: TextStyle(
                            color: Color(0xff51a4da),
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ), */
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 3),
                        height: 70,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xff51a4da)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              height: 90.0,
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 40.0,
                                      width: 50.0,
                                      child: Image.asset('assets/india.png'),
                                    ),
                                    VerticalDivider(
                                      color: Color(0xff51a4da),
                                      thickness: 1,
                                      endIndent: 4,
                                      indent: 4,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: Text("+91-",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.50,
                              child: TextField(
                                cursorColor: Colors.black,
                                controller: _phoneController,
                                maxLength: 10,
                                decoration: new InputDecoration(
                                  hintStyle: null,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                  ),
                                  hintText: "Mobile Number",
                                  counterText: "",
                                  focusColor: Colors.black,
                                  fillColor: Colors.black,
                                  contentPadding: EdgeInsets.all(1),
                                  hoverColor: Colors.black,
                                  labelStyle: TextStyle(color: Colors.black),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            //side: BorderSide(color: Colors.red)
                          ),
                          child: Text("Verify"),
                          textColor: Colors.white,
                          padding: EdgeInsets.all(16),
                          onPressed: () {
                            //code for sign in
                            String mobile = _phoneController.text.trim();
                            mobile = "+91" + mobile;
                            Role=widget.role;
                            print(mobile);
                            registerUser(mobile, context);
                          },
                          color: Color(0xff51a4da),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Already have an Account?"),
                          InkWell(
                            child: Text(
                              " Login!",
                              style: TextStyle(
                                  color: Color(0xff51a4da),
                                  fontWeight: FontWeight.w700),
                            ),
                            onTap: () {
                               Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen(Role:widget.role)),
                              );
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
