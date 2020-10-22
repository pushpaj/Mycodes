import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instserve/widget/progress.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  DocumentSnapshot snap;
  bool toggle = false;

  Future getHiistory() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot _snap =
        await Firestore.instance.collection('history').document(user.uid).get();
    setState(() {
      snap = _snap;
      toggle = true;
    });
  }

  @override
  void initState() {
    getHiistory();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    getHiistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
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
