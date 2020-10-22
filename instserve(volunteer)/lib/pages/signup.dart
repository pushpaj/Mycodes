import 'dart:async';

import 'package:app4/pages/authenticate.dart';
import 'package:app4/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _conpass = TextEditingController();
  TextEditingController _addressLine1 = TextEditingController();
  TextEditingController _addressLine2 = TextEditingController();
  TextEditingController _addressLine3 = TextEditingController();
  TextEditingController _pincode = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String gender = 'Male';
  bool locationstatus = false;
  Position currLoc;
  String id;
  bool showLocationError = false;
  bool showFieldError = false;
  bool hidePass = true;
  bool hideConPass = true;
  bool signUpStart=false;
  final format = DateFormat.yMMMMd("en_US");
  Completer<GoogleMapController> _controller = Completer();
  Position newCoordinates;

  Future signupAndAdd() async {
    if (_formKey.currentState.validate()) {
      if (locationstatus) {
        setState(() {
          signUpStart=true;
        });
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _email.text, password: _pass.text)
            .then((user) {
          Firestore.instance
              .collection('volunteer')
              .document(user.user.uid)
              .setData({
            'id': user.user.uid,
            'name': _name.text,
            'email': _email.text,
            'contact': _contact.text,
            'dob': _dob.text,
            'gender': gender,
            'address': _addressLine1.text +
                " " +
                _addressLine2.text +
                " " +
                _addressLine3.text,
            'pincode': _pincode.text,
            'location':
                new GeoPoint(newCoordinates.latitude, newCoordinates.longitude),
            'doj': DateTime.now(),
          });
          setState(() {
            signUpStart=false;
          });
          //  Shows success message....
          Fluttertoast.showToast(
              msg: 'Registered Successfully',
              textColor: Colors.green,
              backgroundColor: Colors.white);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Authenticate()));
        }).catchError((e) {
          setState(() {
            signUpStart=false;
          });
          Fluttertoast.showToast(
              msg: e.message.toString(),
              backgroundColor: Colors.white,
              textColor: Colors.red);
        });
      } else {
        setState(() {
          showLocationError = true;
        });
      }
    } else {
      setState(() {
        showFieldError = true;
      });
    }
  }

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

  _updateMarker(CameraPosition newPosition) {
    setState(() {
      newCoordinates = Position(
          latitude: newPosition.target.latitude,
          longitude: newPosition.target.longitude);
      currLoc=newCoordinates;    
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: signUpStart?circularProgress(): Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.white, Colors.blueGrey])),
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: Padding(
            padding:
                const EdgeInsets.only(right: 15, left: 15, top: 60, bottom: 30),
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
                    hintText: "Full Name",
                  ),
                  controller: _name,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "The name field cannot be empty";
                    } else if (_name.text.trim().length < 3) {
                      return "Enter a valid name";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Email",
                  ),
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
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
                    hintText: 'Contact number',
                  ),
                  keyboardType: TextInputType.phone,
                  controller: _contact,
                  maxLength: 10,
                  validator: (value) {
                    if (value.isEmpty)
                      return "The name field cannot be empty";
                    else if (value.length != 10)
                      return 'Phone number should be of 10 digit';
                    return null;
                  },
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: Text(
                          "Male",
                          textAlign: TextAlign.end,
                        ),
                        trailing: Radio(
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
                        ),
                        trailing: Radio(
                          value: "Female",
                          groupValue: gender,
                          onChanged: (e) => valueChanged(e),
                        ),
                      ),
                    )
                  ],
                ),
                DateTimeField(
                  format: format,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                  },
                  controller: _dob,
                  decoration: InputDecoration(labelText: 'Date of Birth'),
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
                Text(
                  'Address:',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "House No/Street No",
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
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Locality/Colony",
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
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Town/City",
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
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Pincode",
                  ),
                  controller: _pincode,
                  maxLength: 6,
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
                locationstatus
                    ? Center(
                        child: RaisedButton(
                          child: Text(
                            'Reset working location',
                          ),
                          color: Colors.white,
                          onPressed: () {
                            dialogTrigger(context);
                          },
                        ),
                      )
                    : Center(
                        child: RaisedButton(
                          child: Text(
                            'Choose working location',
                          ),
                          color: Colors.white,
                          onPressed: () {
                            getLocation();
                          },
                        ),
                      ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Password",
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
                  controller: _pass,
                  obscureText: hidePass,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "The password field cannot be empty";
                    } else if (value.length < 8) {
                      return "The password contain atleast 8 character";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    suffixIcon: hideConPass
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                hideConPass = false;
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
                                hideConPass = true;
                              });
                            },
                          ),
                  ),
                  controller: _conpass,
                  obscureText: hideConPass,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (_pass.text == _conpass.text) {
                      return null;
                    } else {
                      return 'Not matched';
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text("SignUp"),
                    onPressed: () {
                      setState(() {
                        showLocationError = false;
                        showFieldError = false;
                      });
                      signupAndAdd();
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                showLocationError
                    ? Center(
                        child: Text(
                          'Turn on the location',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Container(),
                showFieldError
                    ? Center(
                        child: Text(
                          'Check all mondatory field',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text('Already have an account?'),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: InkWell(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Authenticate()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
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
