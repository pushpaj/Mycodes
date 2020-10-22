import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instserve/widget/progress.dart';

class RecentList extends StatefulWidget {
  @override
  _RecentListState createState() => _RecentListState();
}

class _RecentListState extends State<RecentList> {
  QuerySnapshot list;
  bool toggle = false;

  Future getRecentList() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot snapshot = await Firestore.instance
        .collection('recentClientList')
        .document(user.uid)
        .collection('clients')
        .getDocuments();
    setState(() {
      list = snapshot;
      toggle = true;
    });
  }

  @override
  void initState() {
    getRecentList();
    super.initState();
  }

  @override
  void dispose() {
    getRecentList();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (toggle) {
      if (list.documents.isNotEmpty) {
        return Container(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Text('a'),
              Text('b')
            ],
          ),
        );
      } else {
        return Center(
          child: Text("You have not contacted anyone yet!"),
        );
      }
    }else{
      return circularProgress();
    }
  }
}
