import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instserve/clientpages/homepage.dart';
import 'package:instserve/forgetpassword.dart';
import 'package:instserve/signup.dart';
import 'package:instserve/userpages/homepage.dart';
import 'package:instserve/widget/progress.dart';
import 'dart:io';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  bool showError = false;
  String errorMessage;
  bool hidePass = true;
  bool loginStart = false;
  String personType = 'user';

  login() {
    if (_formkey.currentState.validate()) {
      setState(() {
        loginStart = true;
      });
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      )
          .then((user) {
        setState(() {
          loginStart = false;
        });
        if (personType == 'client') {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => ClientHomePage()));
        } else if (personType == 'user') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => UserHomePage()));
        }
      }).catchError(
        (e) {
          setState(() {
            loginStart = false;
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
        },
      );
    }
  }

  valueChanged(e) {
    setState(() {
      personType = e;
    });
  }

  Widget showErrorMessage() {
    if (showError) {
      return Container(
        padding: EdgeInsets.only(top: 15),
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
    return new Scaffold(
        backgroundColor: Colors.blueGrey,
        body: loginStart
            ? circularProgress()
            : Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                        padding: EdgeInsets.all(25.0),
                        child: Form(
                          key: _formkey,
                          child: ListView(
                            children: <Widget>[
                              SizedBox(height: 30),
                              Container(
                                height: 150,
                                width: 100,
                                child: Image.asset(
                                  'images/logowithtagline.png',
                                  
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        "User",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      trailing: Radio(
                                        activeColor: Colors.teal.shade100,
                                        value: "user",
                                        groupValue: personType,
                                        onChanged: (e) => valueChanged(e),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        "Client",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      trailing: Radio(
                                        activeColor: Colors.teal.shade100,
                                        value: "client",
                                        groupValue: personType,
                                        onChanged: (e) => valueChanged(e),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: Colors.white, width: 1.0),
                                    right: BorderSide(
                                        color: Colors.white, width: 1.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: TextFormField(
                                  
                                    // cursorColor: Colors.red,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        height: 1, color: Colors.white),
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.teal.shade100),
                                      ),
                                      hintText: 'Email',
                                      hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.4),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      suffixIcon: Icon(
                                        Icons.mail_outline,
                                        color: Colors.teal.shade100,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.access_alarm,
                                        color: Colors.transparent,
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
                              //    SizedBox(height: 15.0),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                        color: Colors.white, width: 1.0),
                                    //  bottom: BorderSide(color: Colors.white, width: 1.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    obscureText: hidePass,
                                    style: TextStyle(
                                        height: 1, color: Colors.white),
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.teal.shade100),
                                      ),
                                        hintText: 'Password',
                                        hintStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                        prefixIcon: hidePass
                                            ? IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    hidePass = false;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.visibility,
                                                  color: Colors.teal.shade100,
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
                                        suffixIcon: Icon(
                                          Icons.panorama_fish_eye,
                                          color: Colors.transparent,
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white))),
                                    controller: _password,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "The password field cannot be empty";
                                      } else if (value.length < 8) {
                                        return "The password contain atleast 8 character";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              showErrorMessage(),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: RaisedButton.icon(
                                  elevation: 8,
                                  color: Colors.blueGrey,
                                  highlightColor: Colors.white,
                                  label: Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.teal.shade100,
                                        fontSize: 20),
                                  ), //Text(
                                  icon: Icon(
                                    Icons.exit_to_app,
                                    color: Colors.teal.shade100,
                                    size: 20,
                                  ),
                                  onPressed: login,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.teal),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              Center(
                                child: FlatButton(
                                  child: Text(
                                    'Forgot Password?',
                                    style:
                                        TextStyle(color: Colors.teal.shade100),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgetPassword()));
                                  },
                                ),
                              ),

                              SizedBox(height: 4.0),
                              Center(
                                child: Text(
                                  'Don/t have an account?',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Center(
                                child: FlatButton(
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        color: Colors.teal.shade100,
                                        fontSize: 20),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignupPage()));
                                  },
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ));
  }
}
