import 'dart:io';

import 'package:app4/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final data;
  final address;
  ProfilePage({this.data, this.address});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Placemark address;
  File image;
  bool uploadStartStatus = false;
  bool uploadedStatus = false;
  bool uploading = false;

  Future getImage() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = img;
      uploadStartStatus = true;
    });
  }

  Future uploadImage() async {
    setState(() {
      uploadStartStatus = false;
      uploading = true;
    });
    StorageReference storageReference = FirebaseStorage.instance.ref().child(
        'volunteerProfilePic/${widget.data.documentID}/${DateTime.now()}.jpg');
    StorageUploadTask storageUploadTask = storageReference.putFile(image);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    var dowurl = (await taskSnapshot.ref.getDownloadURL()).toString();
    Firestore.instance
        .collection('volunteer')
        .document(widget.data.documentID)
        .updateData({'profilePicUrl': dowurl});
    setState(() {
      uploading = false;
      uploadedStatus = true;
    });
  }

  Widget displayChild() {
    if (image != null) {
      return Image.file(
        image,
        fit: BoxFit.fill,
      );
    } else if (widget.data['profilePicUrl'] != null) {
      return Image.network(
        widget.data['profilePicUrl'],
        fit: BoxFit.fill,
      );
    } else {
      return Icon(
        Icons.person,
        size: 150,
      );
    }
  }

  Widget uploadTile() {
    if (uploadStartStatus) {
      return Container(
        child: Center(
            child: RaisedButton(
          child: Text('Upload'),
          color: Colors.blueGrey,
          onPressed: () {
            uploadImage();
          },
        )),
      );
    } else {
      return Container();
    }
  }

  Widget uploadingWidget() {
    if (uploading) {
      return circularProgress();
    } else {
      return Container();
    }
  }

  Widget uploadedContainer() {
    if (uploadedStatus) {
      return Container(
        child: Center(
          child: Text(
            'Uploaded',
            style: TextStyle(color: Colors.green),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.blueGrey,
                  child: ClipOval(
                    child: SizedBox(
                      height: 180,
                      width: 180,
                      child: displayChild(),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () {
                      getImage();
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          uploadTile(),
          uploadingWidget(),
          uploadedContainer(),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Username',
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.data['name'],
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Date of Birth',
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.data['dob'],
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Location',
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${widget.address.subLocality} , ${widget.address.locality}',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Email Address',
                style: TextStyle(color: Colors.blueGrey),
              ),
              Text(
                widget.data['email'],
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
