import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:instserve/clientpages/profile.dart';
import 'package:instserve/clientpages/timeline.dart';
import 'package:instserve/widget/progress.dart';
import 'package:intl/intl.dart';
import 'history.dart';

class ClientHomePage extends StatefulWidget {
  @override
  _ClientHomePageState createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  TextEditingController _name = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _addressLine1 = TextEditingController();
  TextEditingController _addressLine2 = TextEditingController();
  TextEditingController _addressLine3 = TextEditingController();
  TextEditingController _pincode = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  String selectedProfession;
  bool locationstatus = false;
  Position currLoc;
  Position newCoordinates;
  final format = DateFormat.yMMMMd("en_US");
  final _formkey = GlobalKey<FormState>();
  String gender = 'Male';
  FirebaseUser client;

  PageController pageController;
  int pageIndex = 1;
  DocumentSnapshot data;
  Placemark address;

  bool adding=false;

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(microseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  valueChanged(e) {
    setState(() {
      gender = e;
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
      currLoc = newCoordinates;
    });
  }

  Future getClientData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var snap =
        await Firestore.instance.collection('client').document(user.uid).get();
    if (snap.exists) {
      List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
        snap.data['location'].latitude,
        snap.data['location'].longitude,
      );
      setState(() {
        address = placemark[0];
      });
    }
    setState(() {
      data = snap;
      client = user;
    });
  }

  addData() {
    if (_formkey.currentState.validate()) {
      setState(() {
        adding=true;
      });
      Firestore.instance.collection('client').document(client.uid).setData({
        'id': client.uid,
        'name': _name.text,
        'email': client.email,
        'contact': _contact.text,
        'gender': gender,
        'dob': _dob.text,
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
      }).then((val) {
        setState(() {
          adding=false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ClientHomePage()));
      });
    }
  }

  @override
  void initState() {
    getClientData();
    super.initState();
    pageController = PageController(initialPage: pageIndex);
  }

  @override
  void dispose() {
    getClientData();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Container(
        color: Colors.white,
        child: circularProgress(),
      );
    } else if (!data.exists) {
      return formPage(context);
    } else {
      return homePage(context);
    }
  }

  Scaffold formPage(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body:adding?circularProgress(): Stack(
        children: <Widget>[
          Center(
            child: Container(
              padding: EdgeInsets.all(25.0),
              child: Form(
                key: _formkey,
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 50),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 80.0),
                        child: Text(
                          'Basic details',
                          style: TextStyle(fontSize: 40, color: Colors.white),
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
                          textCapitalization: TextCapitalization.words,
                          textAlign: TextAlign.center,
                          style: TextStyle(height: 1, color: Colors.white),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Full Name',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            //               DUMMY
                            suffixIcon: Icon(
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
                            hintText: 'Contact Number',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            suffixIcon: Icon(
                              Icons.phone,
                              color: Colors.white,
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
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.4)),
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
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.4)),
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
                            hintText: 'Date of birth',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                          textAlign: TextAlign.center,
                          validator: (value) {
                            final difference =
                                DateTime.now().difference(value).inDays;
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
                          future: Firestore.instance
                              .collection("profession")
                              .getDocuments(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text('Loading...');
                            } else {
                              List<DropdownMenuItem> proffessionItem = [];
                              for (int i = 0;
                                  i < snapshot.data.documents.length;
                                  i++) {
                                DocumentSnapshot doc =
                                    snapshot.data.documents[i];
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
                                      items: proffessionItem,
                                      onChanged: (professionValue) {
                                        setState(() {
                                          selectedProfession = professionValue;
                                        });
                                      },
                                      iconEnabledColor: Colors.white,
                                      value: selectedProfession,
                                      isExpanded: true,
                                      underline: Divider(
                                        height: 0,
                                        color: Colors.black,
                                      ),
                                      hint: Center(
                                        child: Text(
                                          "Choose profession",
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.4),
                                          ),
                                        ),
                                      ),
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
                      child: Center(
                        child: Text(
                          'Address',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
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
                            hintText: "House No/Street No",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.4),
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
                            hintText: "Locality/Colony",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.4),
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
                            hintText: "Town/City",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.4),
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
                            hintText: "Pincode",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.4),
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
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: OutlineButton(
                        borderSide: BorderSide(color: Colors.white),
                        highlightColor: Colors.white,
                        child: Text(
                          'Done',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: addData,
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

  Scaffold homePage(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Profile(
            snap: data,
            address: address,
          ),
          Timeline(),
          History(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Colors.blueGrey,
        inactiveColor: Colors.teal,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person)),
          BottomNavigationBarItem(icon: Icon(Icons.timelapse)),
          BottomNavigationBarItem(icon: Icon(Icons.history)),
        ],
      ),
    );
  }
}
