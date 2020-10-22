import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:app4/pages/addclient.dart';
import 'package:app4/pages/authenticate.dart';
import 'package:app4/pages/clients.dart';
import 'package:app4/pages/profilepage.dart';
import 'package:app4/widgets/progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DocumentSnapshot data;
  Placemark address;
  QuerySnapshot _query;

  Future getVolunteerData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    //     TO GET DATA OF VOLUNTEER
    DocumentSnapshot _data = await Firestore.instance
        .collection('volunteer')
        .document(user.uid)
        .get();
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
      _data.data['location'].latitude,
      _data.data['location'].longitude,
    );
    setState(() {
      data = _data;
      address = placemark[0];
    });
    //    TO KNOW THE NUMBER OF CLIENT ADDED
    QuerySnapshot query = await Firestore.instance
        .collection('client')
        .where('volunteer', isEqualTo: data.documentID)
        .getDocuments();
    setState(() {
      _query = query;
    });
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

  @override
  void initState() {
    getVolunteerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null || _query == null) {
      return Scaffold(
        body: Center(
          child: circularProgress(),
        ),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            title: Text('Add User'),
            centerTitle: true,
          ),
//       Drawer
          drawer: new Drawer(
              child: ListView(
            children: <Widget>[
//         Drawer header
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
//         Body

              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Clients(snap: _query)));
                },
                child: ListTile(
                  title: Text('Total Client'),
                  leading: Icon(
                    Icons.people,
                    color: Colors.blueGrey,
                  ),
                  subtitle: Text('${_query.documents.length}'),
                ),
              ),

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
                            builder: (context) =>
                                ProfilePage(data: data, address: address)));
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Authenticate()));
                  },
                ),
              )
            ],
          )),
//   BODY STARTS FROM HERE......

          body: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage('images/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 600.0, sigmaY: 1000.0),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: RaisedButton(
                  color: Colors.blueGrey,
                  child: Text(
                    'Add New Client',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddClient(
                          volunteerId: data.documentID,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ));
    }
  }
}
