import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instserve/widget/progress.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  DocumentSnapshot snap;
  bool toggle = false;
  Future getTimeLine() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot _snap = await Firestore.instance
        .collection('timeline')
        .document(user.uid)
        .get();
    setState(() {
      snap = _snap;
      toggle = true;
    });
  }

  @override
  void initState() {
    getTimeLine();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    getTimeLine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('TimeLine'),
        centerTitle: true,
      ),
      body: !toggle
          ? circularProgress()
          : ((!snap.exists)
              ? Center(
                  child: Text(
                    'Nothing to show!',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.4), fontSize: 18),
                  ),
                )
              : ListView(
                  children: <Widget>[],
                )),
    );
  }
}
