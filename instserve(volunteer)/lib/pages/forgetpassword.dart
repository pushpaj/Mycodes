import 'package:app4/pages/authenticate.dart';

import 'package:app4/widgets/progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      body: sendingStart
          ? circularProgress()
          : Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 60, bottom: 30),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.white, Colors.blueGrey]),
                  ),
                  child: Form(
                    key: _formkey,
                    child: ListView(
                      children: <Widget>[
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.asset('images/logo.png'),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Email",
                          ),
                          keyboardType: TextInputType.emailAddress,
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
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: RaisedButton(
                            color: Colors.blue,
                            child: Text(
                              'Send',
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
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
            )
          ],
        );
      },
    );
  }
}
