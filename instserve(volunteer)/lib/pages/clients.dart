import 'package:app4/pages/document.dart';

import 'package:flutter/material.dart';

class Clients extends StatelessWidget {
  final snap;
  Clients({this.snap});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Clients'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        itemCount: snap.documents.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (context, i) {
          return Padding(
            padding: EdgeInsets.all(8),
            child: Single_Info(
                name: snap.documents[i].data['name'],
                dob: snap.documents[i].data['dob'],
                profilePic: snap.documents[i].data['profilePicUrl'],
                clientId: snap.documents[i].documentID),
          );
        },
      ),
    );
  }
}

class Single_Info extends StatelessWidget {
  final String name;
  final String dob;
  final profilePic;
  final String clientId;
  Single_Info({this.name, this.dob, this.profilePic, this.clientId});

  bool isUploaded = false;

  @override
  Widget build(BuildContext context) {
    if (profilePic != null) {
      isUploaded = true;
    }
    return Container(
      color: Colors.teal.shade500,
      child: ListTile(
        
        title: Text(name),
        subtitle: Text(dob),
        trailing: isUploaded
            ? Icon(Icons.done)
            : InkWell(
                child: Icon(Icons.add),
                onTap:()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>Document(client_Id:clientId ,))),
              ),
      ),
    );
  }
}
