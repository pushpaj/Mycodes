import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instserve/login.dart';
import 'package:instserve/widget/progress.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  bool sendingStart = false;

  Future sendPasswordResetEmail(String email) async {
    if (_formkey.currentState.validate()) {
      setState(() {
        sendingStart = true;
      });
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((v) {
        setState(() {
          sendingStart = false;
        });
        triggerDialog(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: sendingStart
          ? circularProgress()
          : Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    padding: EdgeInsets.all(25),
                    child: Form(
                      key: _formkey,
                      child: ListView(
                        children: <Widget>[
                          SizedBox(height: 50),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 80.0),
                              child: Text(
                                'Reset Password',
                                style: TextStyle(
                                    fontSize: 40, color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border(
                                top:
                                    BorderSide(color: Colors.white, width: 1.0),
                                right:
                                    BorderSide(color: Colors.white, width: 1.0),
                                left:
                                    BorderSide(color: Colors.white, width: 1.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(height: 1, color: Colors.white),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.4),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  suffixIcon: Icon(
                                    Icons.mail_outline,
                                    color: Colors.transparent,
                                  ),
                                  //         DUMMY
                                  prefixIcon: Icon(
                                    Icons.mail_outline,
                                    color: Colors.white,
                                  ),
                                ),
                                controller: _email,
                                validator: (value) {
                                  Pattern pattern =
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                  RegExp regex = new RegExp(pattern);
                                  if (value.isEmpty) {
                                    return "The email field cannot be empty";
                                  } else if (!regex.hasMatch(value)) {
                                    return 'Enter Valid Email!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: OutlineButton(
                              borderSide: BorderSide(color: Colors.white),
                              highlightColor: Colors.white,
                              child: Text(
                                'Send',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                sendPasswordResetEmail(_email.text);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }

  triggerDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Email Sent',
            style: TextStyle(color: Colors.green),
          ),
          content: Container(
            height: 200,
            width: 200,
            child: Center(
              child: Text(
                'An email has been sent to your emailId. Please check your inbox',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            )
          ],
        );
      },
    );
  }
}
