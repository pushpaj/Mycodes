import 'dart:io';

import 'package:app4/pages/forgetpassword.dart';
import 'package:app4/pages/signup.dart';

import 'package:app4/widgets/progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  bool showError = false;
  bool hidePass = true;
  bool loginStart=false;
  String errorMessage;

  login() {
    if (_formkey.currentState.validate()) {
      setState(() {
        loginStart=true;
      });
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _email.text,
        password: _pass.text,
      )
          .then((user) {
            setState(() {
              loginStart=false;
            });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }).catchError((e) {
        setState(() {
          loginStart=false;
        });
        authProblems errorType;
        if (Platform.isAndroid) {
          switch (e.message) {
            case 'There is no user record corresponding to this identifier. The user may have been deleted.':
              errorType = authProblems.UserNotFound;
              break;
            case 'The password is invalid or the user does not have a password.':
              errorType = authProblems.PasswordNotValid;
              break;
            case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
              errorType = authProblems.NetworkError;
              break;
            default:
              errorType = authProblems.UnknownError;
            //print('Case ${e.message} is not yet implemented');
          }
        } else if (Platform.isIOS) {
          switch (e.code) {
            case 'Error 17011':
              errorType = authProblems.UserNotFound;
              break;
            case 'Error 17009':
              errorType = authProblems.PasswordNotValid;
              break;
            case 'Error 17020':
              errorType = authProblems.NetworkError;
              break;

            default:
            //print('Case ${e.message} is not yet implemented');
          }
        }
        setState(
          () {
            errorMessage = errorType.toString();
            showError = true;
          },
        );
      });
    }
  }

  Widget showErrorMessage() {
    if (showError) {
      return Container(
        child: Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginStart
            ? circularProgress()
            :Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.white, Colors.blueGrey]),
        ),
        alignment: Alignment.center,
        child: Form(
          key: _formkey,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 60, bottom: 30),
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
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: hidePass
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                hidePass = false;
                              });
                            },
                            icon: Icon(
                              Icons.visibility,
                              color: Colors.blue,
                            ),
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.visibility_off,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              setState(() {
                                hidePass = true;
                              });
                            },
                          ),
                  ),
                  keyboardType: TextInputType.multiline,
                  controller: _pass,
                  obscureText: hidePass,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "The password field cannot be empty";
                    } else if (value.length < 8) {
                      return "The password contain atleast 8 character";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                showErrorMessage(),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: RaisedButton(
                    child: Text("Login"),
                    color: Colors.blue,
                    onPressed: login,
                  ),
                ),
                Center(
                  child: FlatButton(
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgetPassword()));
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text("Dont't have a account?"),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: InkWell(
                    child: Text(
                      'SignUp',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
