import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instserve/widget/progress.dart';
import 'package:intl/intl.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  final snap;
  ProfilePage({this.snap});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File image;
  bool uploadStartStatus = false;
  bool uploadedStatus = false;
  bool uploading = false;
  final format = DateFormat.yMMMMd("en_US");

  Widget displayChild() {
    if (image != null) {
      return Image.file(
        image,
        fit: BoxFit.fill,
      );
    } else if (widget.snap.data['profilePicUrl'] != null) {
      return Image.network(
        widget.snap.data['profilePicUrl'],
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Upload'),
              color: Colors.blueGrey,
              onPressed: () {
                uploadImage();
              },
            ),
            RaisedButton(
              child: Text('Crop'),
              color: Colors.blueGrey,
              onPressed: () {
                _cropImage();
              },
            ),
          ],
        ),
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

  Future _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: image.path,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.purple,
            toolbarWidgetColor: Colors.white,
            toolbarTitle: 'crop it',
            lockAspectRatio: false));
    setState(() {
      image = cropped ?? image;
    });
  }

  Future getImage() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = img;
      if (img != null) {
        uploadStartStatus = true;
      }
    });
  }

  Future uploadImage() async {
    setState(() {
      uploadStartStatus = false;
      uploading = true;
    });
    StorageReference storageReference = FirebaseStorage.instance.ref().child(
        'userProfilePic/${widget.snap.documentID}/${DateTime.now()}.jpg');
    StorageUploadTask storageUploadTask = storageReference.putFile(image);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    var dowurl = (await taskSnapshot.ref.getDownloadURL()).toString();
    Firestore.instance
        .collection('user')
        .document(widget.snap.documentID)
        .updateData({'profilePicUrl': dowurl});
    setState(() {
      uploading = false;
      uploadedStatus = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.snap == null) {
      return Scaffold(
        body: Center(
          child: circularProgress(),
        ),
      );
    } else {
      //String dob = doc.data['dob'].toString();
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
                          widget.snap.data['name'],
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
                          widget.snap.data['dob'],
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
                  widget.snap.data['email'],
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ],
        ),
      );
    }
  }
}
