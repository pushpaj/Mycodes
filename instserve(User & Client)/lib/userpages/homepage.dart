import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:instserve/components/categorylist.dart';
import 'package:instserve/components/recentlist.dart';
import 'package:instserve/login.dart';
import 'package:instserve/userpages/profilepage.dart';
import 'package:instserve/widget/progress.dart';
import 'package:intl/intl.dart';
import 'clientlist.dart';

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  TextEditingController _name = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _dob = TextEditingController();

  DocumentSnapshot data;
  FirebaseUser user;
  String gender = 'Male';
  String selectedprofession;
  final format = DateFormat.yMMMMd("en_US");
  final _formkey = GlobalKey<FormState>();
  bool adding = false;

  Future getUserData() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    //     TO GET DATA OF USER
    DocumentSnapshot _data =
        await Firestore.instance.collection('user').document(_user.uid).get();
    setState(() {
      data = _data;
      user = _user;
    });
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

  addData() {
    if (_formkey.currentState.validate()) {
      setState(() {
        adding = true;
      });
      Firestore.instance.collection('user').document(user.uid).setData({
        'id': user.uid,
        'name': _name.text,
        'email': user.email,
        'contact': _contact.text,
        'gender': gender,
        'dob': _dob.text,
        'doj': DateTime.now(),
        'profilePicUrl': null
      }).then((val) {
        setState(() {
          adding = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => UserHomePage()));
      });
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    getUserData();
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
      return formPage();
    } else {
      return homePage();
    }
  }

  Scaffold formPage() {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: adding
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
                          SizedBox(height: 50),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 80.0),
                              child: Text(
                                'Basic details',
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
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: TextFormField(
                                textCapitalization: TextCapitalization.words,
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(height: 1, color: Colors.white),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Full Name',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.4),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  suffixIcon: Icon(
                                    Icons.person,
                                    color: Colors.white,
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
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: 'Contact Number',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.4),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Colors.white,
                                  ),
                                  //               DUMMY
                                  suffixIcon: Icon(
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
                                right:
                                    BorderSide(color: Colors.white, width: 1.0),
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
                                            color:
                                                Colors.white.withOpacity(0.4)),
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
                                            color:
                                                Colors.white.withOpacity(0.4)),
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
                                top:
                                    BorderSide(color: Colors.white, width: 1.0),
                                left:
                                    BorderSide(color: Colors.white, width: 1.0),
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
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                },
                                controller: _dob,
                                decoration: InputDecoration(
                                  hintText: 'Date of birth',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.4),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
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
                          SizedBox(
                            height: 30,
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

  Scaffold homePage() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          'InstServe',
          style: TextStyle(fontFamily: 'audiowide'),
        ),
        centerTitle: true,
      ),
//         Drawer
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
//          Drawer header
            new UserAccountsDrawerHeader(
              accountName: Text(data.data['name']),
              accountEmail: Text(data.data['email']),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: ClipOval(
                    child: SizedBox(
                      height: 90,
                      width: 90,
                      child: displayDrawerPhoto(),
                    ),
                  ),
                ),
              ),
              decoration: new BoxDecoration(
                color: Colors.blueGrey,
              ),
            ),
//          Drawer Body
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Profile'),
                leading: Icon(
                  Icons.person,
                  color: Colors.blueGrey,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(snap: data)));
                },
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('History'),
                leading: Icon(
                  Icons.history,
                  color: Colors.blueGrey,
                ),
                onTap: () {},
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => UserHomePage()));
              },
              child: ListTile(
                title: Text('Refresh'),
                leading: Icon(
                  Icons.refresh,
                ),
              ),
            ),

            Divider(
              color: Colors.blueGrey,
            ),

            InkWell(
              onTap: () async {
                await launch('https://www.instserve.in/faq/');
              },
              child: ListTile(
                title: Text('FAQ'),
                leading: Icon(
                  Icons.live_help,
                  color: Colors.green,
                ),
              ),
            ),

            InkWell(
              onTap: () async {
                await launch('https://www.instserve.in/privacy-policy/');
              },
              child: ListTile(
                title: Text('Privacy Policy'),
                leading: Icon(
                  Icons.lock,
                  color: Colors.red.shade700,
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await launch('https://www.instserve.in/terms/');
              },
              child: ListTile(
                title: Text('Terms & Conditions'),
                leading: Icon(
                  Icons.library_books,
                  color: Colors.yellow,
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await launch('https://www.instserve.in/about/');
              },
              child: ListTile(
                title: Text('About'),
                leading: Icon(
                  Icons.help,
                  color: Colors.teal,
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Log Out'),
                leading: Icon(
                  Icons.transit_enterexit,
                  color: Colors.red,
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            )
          ],
        ),
      ),
//   BODY STARTS FROM HERE......

      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        children: <Widget>[
          image_carousel,
          SizedBox(
            height: 20.0,
          ),
          Center(
              child: Text("Find the service you want",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0))),
          SizedBox(
            height: 20.0,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection("profession").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("Loading....");
              } else {
                List<DropdownMenuItem> professionItem = [];
                for (int i = 0; i < snapshot.data.documents.length; i++) {
                  DocumentSnapshot snap = snapshot.data.documents[i];
                  professionItem.add(DropdownMenuItem(
                    child: Center(
                      child: Text(
                        snap.documentID,
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                    value: "${snap.documentID}",
                  ));
                }
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blueGrey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Theme(
                      data: ThemeData(
                          //canvasColor: Colors.blueGrey
                          ),
                      child: DropdownButton(
                        iconEnabledColor: Colors.blueGrey,
                        items: professionItem,
                        onChanged: (professionValue) {
                          setState(() {
                            selectedprofession = professionValue;
                          });
                        },
                        value: selectedprofession,
                        isExpanded: true,
                        hint: Center(
                          child: Text(
                            "Choose profession",
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          Container(
            width: 10.0,
            child: Center(
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.teal, width: 2),
                ),
                elevation: 8,
                icon: Icon(
                  Icons.person_outline,
                  color: Colors.teal.shade100,
                ),
                label: Text("Find",
                    style:
                        TextStyle(color: Colors.teal.shade100, fontSize: 20)),
                color: Colors.blueGrey,
                onPressed: () {
                  if (selectedprofession != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ClientList(selectedprof: selectedprofession),
                      ),
                    );
                  }else{
                    
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              'Popular Categories',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Categories(),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              'Frequently contacted',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          RecentList(),
          SizedBox(
            height: 60,
          )
        ],
      ),
    );
  }

  Widget displayDrawerPhoto() {
    if (data.data['profilePicUrl'] != null) {
      return Image.network(
        data.data['profilePicUrl'],
        fit: BoxFit.fill,
      );
    } else {
      return Icon(
        Icons.person,
        color: Colors.white,
        size: 50,
      );
    }
  }
}

Widget image_carousel = new Container(
  height: 200.0,
  width: double.infinity,
  child: Carousel(
    dotSize: 6.0,
    indicatorBgPadding: 4.0,
    dotBgColor: Colors.transparent,
    boxFit: BoxFit.fill,
    images: [
      AssetImage('images/ServiceProvider/real/homepainter.jpg'),
      AssetImage('images/ServiceProvider/real/Electrician.jpg'),
      AssetImage('images/ServiceProvider/real/Plumber.jpg'),
      AssetImage('images/ServiceProvider/real/Cook.jpg'),
      AssetImage('images/ServiceProvider/real/Home Tutor.jpg'),
      AssetImage('images/ServiceProvider/real/Maintenance.jpg'),
      AssetImage('images/ServiceProvider/real/Mason.jpg'),
      AssetImage('images/ServiceProvider/real/Carpenter.jpg'),
    ],
    autoplay: true,
    animationCurve: Curves.fastOutSlowIn,
    animationDuration: Duration(milliseconds: 3000),
  ),
);
