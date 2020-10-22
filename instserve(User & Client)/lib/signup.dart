import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:instserve/login.dart';
import 'package:instserve/widget/progress.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _conPassword = TextEditingController();
  TextEditingController _addressLine1 = TextEditingController();
  TextEditingController _addressLine2 = TextEditingController();
  TextEditingController _addressLine3 = TextEditingController();
  TextEditingController _pincode = TextEditingController();

  String gender = 'Male';
  String personType = 'user';
  String selectedProfession;
  bool hidePass = true;
  bool hideConPass = true;
  bool signInStart = false;
  final format = DateFormat.yMMMMd("en_US");
  final _userFormKey = GlobalKey<FormState>();
  final _clientFormKey = GlobalKey<FormState>();
  //Position position;
  bool locationstatus = false;
  Position currLoc;
  Completer<GoogleMapController> _controller = Completer();
  Position newCoordinates;

  valueChanged(e) {
    setState(() {
      if (e == 'Male') {
        gender = e;
      } else if (e == 'Female') {
        gender = e;
      }
    });
  }

  getLocation() async {
    Position _loc = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currLoc = _loc;
    });
    dialogTrigger(context);
  }

  signupAndAdd() {
    if (personType == 'user') {
      if (_userFormKey.currentState.validate()) {
        setState(() {
          signInStart = true;
        });
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _email.text, password: _password.text)
            .then((user) {
          Firestore.instance
              .collection('user')
              .document(user.user.uid)
              .setData({
            'id': user.user.uid,
            'name': _name.text,
            'email': _email.text,
            'profilePicUrl': null,
            'contact': _contact.text,
            'dob': _dob.text,
            'gender': gender,
            'doj': DateTime.now(),
          });
          setState(() {
            signInStart = false;
          });
          //  Shows success message....
          Fluttertoast.showToast(
              msg: 'Registered Successfully',
              textColor: Colors.green,
              backgroundColor: Colors.white);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }).catchError((e) {
          setState(() {
            signInStart = false;
          });
          if (e is PlatformException) {
            if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
              exeptionDialogTrigger(context);
            }
          } else {
            Fluttertoast.showToast(
                msg: e.message.toString(),
                backgroundColor: Colors.white,
                textColor: Colors.red);
          }
        });
      }
    } else if (personType == 'client') {
      if (_clientFormKey.currentState.validate()) {
        if (locationstatus == true) {
          setState(() {
            signInStart = true;
          });
          FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _email.text, password: _password.text)
              .then((user) {
            Firestore.instance
                .collection('client')
                .document(user.user.uid)
                .setData({
              'id': user.user.uid,
              'name': _name.text,
              'email': _email.text,
              'contact': _contact.text,
              'dob': _dob.text, //format.parse(_dob.text),
              'gender': gender,
              'address': _addressLine1.text +
                  " " +
                  _addressLine2.text +
                  " " +
                  _addressLine3.text,
              'pincode': int.parse(_pincode.text),
              'location': GeoPoint(currLoc.latitude, currLoc.longitude),
              'doj': DateTime.now(),
              'profession': selectedProfession,
              'profilePicUrl': null
            });

            setState(() {
              signInStart = false;
            });
            //  Shows success message....
            Fluttertoast.showToast(
                msg: 'Registered Successfully',
                textColor: Colors.green,
                backgroundColor: Colors.white);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          }).catchError((e) {
            setState(() {
              signInStart = false;
            });
            if (e is PlatformException) {
              if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
                exeptionDialogTrigger(context);
              }
            } else {
              Fluttertoast.showToast(
                  msg: e.message.toString(),
                  backgroundColor: Colors.white,
                  textColor: Colors.red);
            }
          });
        }
      }
    }
  }

  _updateMarker(CameraPosition newPosition) {
    setState(() {
      newCoordinates = Position(
          latitude: newPosition.target.latitude,
          longitude: newPosition.target.longitude);
      currLoc = newCoordinates;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: signInStart
          ? circularProgress()
          : Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    padding: EdgeInsets.all(25.0),
                    child: ListView(
                      children: <Widget>[
                        SizedBox(height: 30),
                        SizedBox(
                          height: 150,
                          width: 100,
                          child: Image.asset('images/logowithtagline.png',),
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
                                    onChanged: (e) {
                                      setState(() {
                                        personType = e;
                                      });
                                    }),
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
                                  onChanged: (e) {
                                    setState(() {
                                      personType = e;
                                    });
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        personType == 'user' ? userPage() : clientPage(),
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: RaisedButton.icon(
                            elevation: 8,
                            color: Colors.blueGrey,
                            highlightColor: Colors.white,
                            label: Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: Colors.teal.shade100, fontSize: 20),
                            ), //Text(
                            icon: Icon(
                              Icons.person_add,
                              color: Colors.teal.shade100,
                              size: 20,
                            ),
                            onPressed: signupAndAdd,
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
                          height: 15,
                        ),
                        Center(
                          child: Text(
                            'Already have an account?',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Center(
                          child: FlatButton(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.teal.shade100, fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }

  exeptionDialogTrigger(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Email Already Registered',
            style: TextStyle(color: Colors.red),
          ),
          content: Container(
            height: 200,
            width: 200,
            child: Center(
              child: Text(
                'This emailId is already in use with InstServe,try to remember password and Login or try Forget Password',
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

  Widget userPage() {
    return Form(
      key: _userFormKey,
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white, width: 1.0),
                right: BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                textAlign: TextAlign.center,
                style: TextStyle(height: 1, color: Colors.white),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal.shade100),
                  ),
                  hintText: 'Full Name',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  suffixIcon: Icon(
                    Icons.person,
                    color: Colors.teal.shade100,
                  ),
                  //               DUMMY
                  prefixIcon: Icon(
                    Icons.access_alarm,
                    color: Colors.transparent,
                  ),
                ),
                controller: _name,
                validator: (value) {
                  if (value.isEmpty) {
                    return "The name field cannot be empty";
                  } else if (_name.text.trim().length < 3) {
                    return "Enter a valid name";
                  }
                  return null;
                },
              ),
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                //top: BorderSide(color: Colors.white, width: 1.0),
                left: BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                textAlign: TextAlign.center,
                style: TextStyle(height: 1, color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal.shade100),
                  ),
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  suffixIcon: Icon(
                    Icons.mail_outline,
                    color: Colors.transparent,
                  ),
                  //         DUMMY
                  prefixIcon: Icon(
                    Icons.mail_outline,
                    color: Colors.teal.shade100,
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
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                //top: BorderSide(color: Colors.white, width: 1.0),
                right: BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                textAlign: TextAlign.center,
                style: TextStyle(height: 1, color: Colors.white),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal.shade100),
                  ),
                  hintText: 'Contact Number',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  suffixIcon: Icon(
                    Icons.phone,
                    color: Colors.teal.shade100,
                  ),
                  //               DUMMY
                  prefixIcon: Icon(
                    Icons.access_alarm,
                    color: Colors.transparent,
                  ),
                ),
                controller: _contact,
                validator: (value) {
                  if (value.isEmpty)
                    return "The name field cannot be empty";
                  else if (value.length != 10)
                    return 'Phone number should be of 10 digit';
                  return null;
                },
              ),
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                //top: BorderSide(color: Colors.white, width: 1.0),
                left: BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: Text(
                        "Male",
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.white.withOpacity(0.4)),
                      ),
                      trailing: Radio(
                        activeColor: Colors.teal.shade100,
                        value: "Male",
                        groupValue: gender,
                        onChanged: (e) => valueChanged(e),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        "Female",
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.white.withOpacity(0.4)),
                      ),
                      trailing: Radio(
                        activeColor: Colors.teal.shade100,
                        value: "Female",
                        groupValue: gender,
                        onChanged: (e) => valueChanged(e),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white, width: 1.0),
                right: BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: DateTimeField(
                resetIcon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                style: TextStyle(color: Colors.white),
                format: format,
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                },
                controller: _dob,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal.shade100),
                  ),
                  hintText: 'Date of birth',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  suffixIcon: new Icon(
                    MdiIcons.calendar,
                    color: Colors.teal.shade100,
                  ),
                  prefixIcon: Icon(
                    Icons.access_alarm,
                    color: Colors.transparent,
                  ),
                ),
                textAlign: TextAlign.center,
                validator: (value) {
                  if (value == null)
                    return 'Please enter the date of birth';
                  else
                    return null;
                },
              ),
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                //top: BorderSide(color: Colors.white, width: 1.0),
                left: BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                textAlign: TextAlign.center,
                style: TextStyle(height: 1, color: Colors.white),
                keyboardType: TextInputType.multiline,
                obscureText: hidePass,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal.shade100),
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
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
                              color: Colors.teal.shade100,
                            ),
                            onPressed: () {
                              setState(() {
                                hidePass = true;
                              });
                            },
                          ),
                    //   DUMMY
                    suffixIcon: Icon(
                      Icons.access_alarm,
                      color: Colors.transparent,
                    )),
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
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                //top: BorderSide(color: Colors.white, width: 1.0),
                right: BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                textAlign: TextAlign.center,
                style: TextStyle(height: 1, color: Colors.white),
                keyboardType: TextInputType.multiline,
                obscureText: hideConPass,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal.shade100),
                  ),
                  hintText: 'Confirm Password',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  prefixIcon: Icon(
                    Icons.panorama_fish_eye,
                    color: Colors.transparent,
                  ),
                  //   DUMMY
                  suffixIcon: hideConPass
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              hideConPass = false;
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
                            color: Colors.teal.shade100,
                          ),
                          onPressed: () {
                            setState(() {
                              hideConPass = true;
                            });
                          },
                        ),
                ),
                controller: _conPassword,
                validator: (value) {
                  if (_password.text == _conPassword.text) {
                    return null;
                  } else {
                    return 'Not matched';
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget clientPage() {
    return Form(
      key: _clientFormKey,
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white, width: 1.0),
                right: BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(height: 1, color: Colors.white),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal.shade100),
                  ),
                  hintText: 'Full Name',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  suffixIcon: Icon(
                    Icons.person,
                    color: Colors.teal.shade100,
                  ),
                  //               DUMMY
                  prefixIcon: Icon(
                    Icons.access_alarm,
                    color: Colors.transparent,
                  ),
                ),
                controller: _name,
                validator: (value) {
                  if (value.isEmpty) {
                    return "The name field cannot be empty";
                  } else if (_name.text.trim().length < 3) {
                    return "Enter a valid name";
                  }
                  return null;
                },
              ),
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                //top: BorderSide(color: Colors.white, width: 1.0),
                left: BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                textAlign: TextAlign.center,
                style: TextStyle(height: 1, color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal.shade100),
                  ),
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  suffixIcon: Icon(
                    Icons.mail_outline,
                    color: Colors.transparent,
                  ),
                  //         DUMMY
                  prefixIcon: Icon(
                    Icons.mail_outline,
                    color: Colors.teal.shade100,
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
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                //top: BorderSide(color: Colors.white, width: 1.0),
                right: BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                textAlign: TextAlign.center,
                style: TextStyle(height: 1, color: Colors.white),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal.shade100),
                  ),
                  hintText: 'Contact Number',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  suffixIcon: Icon(
                    Icons.phone,
                    color: Colors.teal.shade100,
                  ),
                  //               DUMMY
                  prefixIcon: Icon(
                    Icons.access_alarm,
                    color: Colors.transparent,
                  ),
                ),
                controller: _contact,
                validator: (value) {
                  if (value.isEmpty)
                    return "The name field cannot be empty";
                  else if (value.length != 10)
                    return 'Phone number should be of 10 digit';
                  return null;
                },
              ),
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                //top: BorderSide(color: Colors.white, width: 1.0),
                left: BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: Text(
                        "Male",
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.white.withOpacity(0.4)),
                      ),
                      trailing: Radio(
                        activeColor: Colors.teal.shade100,
                        value: "Male",
                        groupValue: gender,
                        onChanged: (e) => valueChanged(e),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        "Female",
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.white.withOpacity(0.4)),
                      ),
                      trailing: Radio(
                        activeColor: Colors.teal.shade100,
                        value: "Female",
                        groupValue: gender,
                        onChanged: (e) => valueChanged(e),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white, width: 1.0),
                right: BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: DateTimeField(
                resetIcon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                style: TextStyle(color: Colors.white),
                format: format,
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                },
                controller: _dob,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal.shade100),
                  ),
                  hintText: 'Date of birth',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  suffixIcon: Icon(
                    MdiIcons.calendar,
                    color: Colors.teal.shade100,
                  ),
                  prefixIcon: Icon(
                    Icons.access_alarm,
                    color: Colors.transparent,
                  ),
                ),
                textAlign: TextAlign.center,
                validator: (value) {
                  final difference = DateTime.now().difference(value).inDays;
                  if (value == null)
                    return 'Please enter the date of birth';
                  else if (difference < 18 * 365)
                    return 'Must be above 18';
                  else if (difference > 60 * 365)
                    return 'Not eligible!';
                  else
                    return null;
                },
              ),
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white, width: 1.0),
                left: BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: FutureBuilder<QuerySnapshot>(
                future:
                    Firestore.instance.collection("profession").getDocuments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('Loading...');
                  } else {
                    List<DropdownMenuItem> proffessionItem = [];
                    for (int i = 0; i < snapshot.data.documents.length; i++) {
                      DocumentSnapshot doc = snapshot.data.documents[i];
                      proffessionItem.add(
                        DropdownMenuItem(
                          child: Center(
                            child: Text(
                              doc.documentID,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          value: "${doc.documentID}",
                        ),
                      );
                    }
                    return Container(
                      height: 60,
                      child: DropdownButtonHideUnderline(
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(canvasColor: Colors.teal),
                          child: DropdownButton(
                            icon: Icon(Icons.arrow_drop_down,color: Colors.teal.shade100,),
                            items: proffessionItem,
                            onChanged: (professionValue) {
                              setState(() {
                                selectedProfession = professionValue;
                              });
                            },
                            iconEnabledColor: Colors.white,
                            value: selectedProfession,
                            isExpanded: true,
                          /*  underline: Divider(
                              height: 0,
                              color: Colors.black,
                            ),*/
                            hint: Center(
                                child: Text(
                              "Choose profession",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                              ),
                            )),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              'Address',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white, width: 1.0),
                right: BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                textAlign: TextAlign.center,
                style: TextStyle(height: 1, color: Colors.white),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal.shade100),
                  ),
                  hintText: "House No/Street No",
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  suffixIcon: Icon(
                    MdiIcons.homeAccount,
                    color: Colors.teal.shade100,
                  ),
                  prefixIcon: Icon(
                    Icons.access_alarm,
                    color: Colors.transparent,
                  ),
                ),
                controller: _addressLine1,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Should not be empty";
                  }
                  return null;
                },
              ),
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white, width: 1.0),
                left: BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                textAlign: TextAlign.center,
                style: TextStyle(height: 1, color: Colors.white),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal.shade100),
                  ),
                  hintText: "Locality/Colony",
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  prefixIcon: Icon(
                    MdiIcons.roadVariant,
                    color: Colors.teal.shade100,
                  ),
                  suffixIcon: Icon(
                    Icons.access_alarm,
                    color: Colors.transparent,
                  ),
                ),
                controller: _addressLine2,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Should not be empty";
                  }
                  return null;
                },
              ),
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white, width: 1.0),
                right: BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                textAlign: TextAlign.center,
                style: TextStyle(height: 1, color: Colors.white),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal.shade100),
                  ),
                  hintText: "Town/City",
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  suffixIcon: Icon(
                    MdiIcons.cityVariant,
                    color: Colors.teal.shade100,
                  ),
                  prefixIcon: Icon(
                    Icons.access_alarm,
                    color: Colors.transparent,
                  ),
                ),
                controller: _addressLine3,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Should not be empty";
                  }
                  return null;
                },
              ),
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white, width: 1.0),
                left: BorderSide(color: Colors.white, width: 1.0),
                bottom: BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                textAlign: TextAlign.center,
                style: TextStyle(height: 1, color: Colors.white),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal.shade100),
                  ),
                  hintText: "Pincode",
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  prefixIcon: Icon(
                    MdiIcons.pin,
                    color: Colors.teal.shade100,
                  ),
                  suffixIcon: Icon(
                    Icons.access_alarm,
                    color: Colors.transparent,
                  ),
                ),
                controller: _pincode,
                //maxLength: 6,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Should not be empty";
                  } else if (value.trim().length != 6) {
                    return 'Not a valid Pincode';
                  }
                  return null;
                },
              ),
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white, width: 1.0),
                right: BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                textAlign: TextAlign.center,
                style: TextStyle(height: 1, color: Colors.white),
                keyboardType: TextInputType.multiline,
                obscureText: hidePass,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal.shade100),
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    suffixIcon: hidePass
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
                              color: Colors.teal.shade100,
                            ),
                            onPressed: () {
                              setState(() {
                                hidePass = true;
                              });
                            },
                          ),
                    //   DUMMY
                    prefixIcon: Icon(
                      Icons.access_alarm,
                      color: Colors.transparent,
                    )),
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
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white, width: 1.0),
                left: BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                textAlign: TextAlign.center,
                style: TextStyle(height: 1, color: Colors.white),
                keyboardType: TextInputType.multiline,
                obscureText: hideConPass,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal.shade100),
                  ),
                  hintText: 'Confirm Password',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  suffixIcon: Icon(
                    Icons.panorama_fish_eye,
                    color: Colors.transparent,
                  ),
                  //   DUMMY
                  prefixIcon: hideConPass
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              hideConPass = false;
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
                            color: Colors.teal.shade100,
                          ),
                          onPressed: () {
                            setState(() {
                              hideConPass = true;
                            });
                          },
                        ),
                ),
                controller: _conPassword,
                validator: (value) {
                  if (_password.text == _conPassword.text) {
                    return null;
                  } else {
                    return 'Not matched';
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          locationstatus
              ? Center(
                  child: RaisedButton(
                    child: Text(
                      'Reset working location',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      //side: BorderSide(color: Colors.red),
                    ),
                    onPressed: () {
                      dialogTrigger(context);
                    },
                  ),
                )
              : Center(
                  child: RaisedButton(
                    child: Text(
                      'Choose working location',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      //side: BorderSide(color: Colors.red),
                    ),
                    onPressed: () {
                      getLocation();
                    },
                  ),
                ),
        ],
      ),
    );
  }

  dialogTrigger(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Choose working Location',
            style: TextStyle(color: Colors.blue),
          ),
          content: currLoc == null
              ? circularProgress()
              : Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(currLoc.latitude, currLoc.longitude),
                            zoom: 15),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        onCameraMove: ((_position) => _updateMarker(_position)),
                      ),
                    ),
                    Center(
                        child: Icon(
                      Icons.location_searching,
                      color: Colors.blue,
                    )),
                  ],
                ),
          actions: <Widget>[
            FlatButton(
              child: Text('Done', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                setState(() {
                  locationstatus = true;
                });
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}

