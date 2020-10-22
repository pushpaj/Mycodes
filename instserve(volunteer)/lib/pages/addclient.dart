import 'dart:async';

import 'package:app4/pages/document.dart';
import 'package:app4/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class AddClient extends StatefulWidget {
  final volunteerId;
  AddClient({this.volunteerId});
  @override
  _AddClientState createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  TextEditingController clientName = TextEditingController();
  TextEditingController clientEmail = TextEditingController();
  TextEditingController clientContact = TextEditingController();
  TextEditingController clientDOB = TextEditingController();
  TextEditingController _addressLine1 = TextEditingController();
  TextEditingController _addressLine2 = TextEditingController();
  TextEditingController _addressLine3 = TextEditingController();
  TextEditingController _pincode = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String selectedProfession;
  String gender = 'Male';
  Position position;
  bool locationstatus = false;
  final format = DateFormat.yMMMMd("en_US");
  Completer<GoogleMapController> _controller = Completer();
  Position newCoordinates;

  String volunteername;

  String clientId;
  Position currLoc;
  bool isAdding = false;
  bool showError = false;

  _updateMarker(CameraPosition newPosition) {
    setState(() {
      newCoordinates = Position(
          latitude: newPosition.target.latitude,
          longitude: newPosition.target.longitude);
      currLoc = newCoordinates;
    });
  }

  getLocation() async {
    Position _loc = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currLoc = _loc;
    });
    mapdialogTrigger(context);
  }

  Future addIntoFirebase() async {
    if (_formKey.currentState.validate() &&
        selectedProfession != null &&
        locationstatus) {
      setState(() {
        isAdding = true;
      });
      Firestore.instance.collection('client').add({
        'name': clientName.text,
        'email': clientEmail.text,
        'contact': clientContact.text,
        'dob': clientDOB.text,
        'gender': gender,
        'profession': selectedProfession,
        'address': _addressLine1.text +
            " " +
            _addressLine2.text +
            " " +
            _addressLine3.text,
        'pincode': _pincode.text,
        'location':  GeoPoint(currLoc.latitude, currLoc.longitude),
        'volunteer': widget.volunteerId,
        'doj': DateTime.now(),
      }).then((result) async {
        DocumentSnapshot snap = await result.get();
        setState(() {
          clientId = snap.documentID;
          clientName.clear();
          clientEmail.clear();
          clientDOB.clear();
          clientContact.clear();
          selectedProfession = null;
          _addressLine1.clear();
          _addressLine2.clear();
          _addressLine3.clear();
          _pincode.clear();
          locationstatus = false;
          isAdding = false;
        });
        dialogTrigger(context);
      }).catchError((e) {});
    } else {
      setState(() {
        showError = true;
      });
    }
  }

  dialogTrigger(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Job Done'),
          content: Container(
            height: 200,
            width: 200,
            child: Center(
              child: InkWell(
                child: Text(
                  'Add Document',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Document(client_Id: clientId)));
                },
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Later', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Add Client Data'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          isAdding
              ? Container(
                  color: Colors.blueGrey.withOpacity(0.6),
                  child: Center(
                    child: circularProgress(),
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Client Full Name',
                    ),
                    keyboardType: TextInputType.text,
                    controller: clientName,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "The name field cannot be empty";
                      } else if (value.length <= 3) {
                        return "Enter a valid name";
                      } else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Client Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: clientEmail,
                    validator: (value) {
                      Pattern pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regex = new RegExp(pattern);
                      if (value.isEmpty) {
                        return null;
                      } else if (!regex.hasMatch(value)) {
                        return 'Enter Valid Email!';
                      } else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //     PROFESSION.............................
                  FutureBuilder<QuerySnapshot>(
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
                          DocumentSnapshot doc = snapshot.data.documents[i];
                          proffessionItem.add(
                            DropdownMenuItem(
                              child: Text(
                                doc.documentID,
                                style: TextStyle(color: Colors.black),
                              ),
                              value: "${doc.documentID}",
                            ),
                          );
                        }
                        return DropdownButton(
                          items: proffessionItem,
                          onChanged: (professionValue) {
                            setState(() {
                              selectedProfession = professionValue;
                            });
                          },
                          value: selectedProfession,
                          isExpanded: true,
                          hint: Text("Choose profession"),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Client contact number',
                    ),
                    keyboardType: TextInputType.phone,
                    controller: clientContact,
                    maxLength: 10,
                    validator: (value) {
                      if (value.isEmpty)
                        return "The name field cannot be empty";
                      else if (value.length != 10)
                        return 'Phone number should be of 10 digit';
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text(
                            "M",
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
                            "F",
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
                  SizedBox(
                    height: 10,
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
                    controller: clientDOB,
                    decoration: InputDecoration(labelText: 'Date of Birth'),
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
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Address:',
                    style: TextStyle(
                      fontSize: 20,
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
                              mapdialogTrigger(context);
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
                  showError
                      ? Center(
                          child: Text(
                            'Error.Check all the fields and turn on location',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : Container(),
                  Center(
                    child: RaisedButton(
                      child: Text('Add'),
                      color: Colors.blueGrey,
                      onPressed: () {
                        setState(() {
                          showError = false;
                        });
                        addIntoFirebase();
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

  mapdialogTrigger(BuildContext context) {
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
