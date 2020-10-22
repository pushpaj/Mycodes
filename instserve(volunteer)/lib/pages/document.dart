import 'dart:io';

import 'package:app4/pages/homepage.dart';
import 'package:app4/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Document extends StatefulWidget {
  final client_Id;
  Document({this.client_Id});

  @override
  _DocumentState createState() => _DocumentState();
}

class _DocumentState extends State<Document> {
  File _image1;
  File _image2;
  String profilePicUrl;
  String addressProofUrl;

  bool profileSelected = false;
  bool addProofSelected = false;
  bool start1 = false;
  bool start2 = false;
  bool profilePicUploadedStatus = false;
  bool addressProofUploadedStatus = false;

  Future getImage(int x) async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (x == 1) {
        _image1 = img;
        profileSelected = true;
      } else if (x == 2) {
        _image2 = img;
        addProofSelected = true;
      }
    });
  }

  uploadDataToFirebase() {
    Firestore.instance
        .collection('client')
        .document(widget.client_Id)
        .updateData({
      'profilePicUrl': profilePicUrl,
      'addressProofUrl': addressProofUrl
    }).then((result) {
      //Navigator.pop(context);
    }).catchError((e) {
      //print(e);
    });
  }

  Future uploadProfilePic() async {
    StorageReference reference = FirebaseStorage.instance
        .ref()
        .child('ClientProfilePic/${widget.client_Id}/${DateTime.now()}.jpg');
    StorageUploadTask storageUploadTask = reference.putFile(_image1);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    var dowurl = await storageTaskSnapshot.ref.getDownloadURL();
    setState(() {
      profilePicUrl = dowurl.toString();

      start1 = false;
      profilePicUploadedStatus = true;
    });
  }

  Future uploadAddressProof() async {
    StorageReference reference = FirebaseStorage.instance
        .ref()
        .child('ClientAddressProof/${widget.client_Id}/${DateTime.now()}.jpg');
    StorageUploadTask storageUploadTask = reference.putFile(_image2);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    var dowurl = await storageTaskSnapshot.ref.getDownloadURL();
    setState(() {
      addressProofUrl = dowurl.toString();

      start2 = false;
      addressProofUploadedStatus = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Documents'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 200,
                      child: GridTile(
                        child: Card(
                          elevation: 10,
                          child: InkWell(
                            onTap: () {
                              getImage(1);
                            },
                            child: _displayChild1(),
                          ),
                        ),
                        footer: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Profile Picture',
                            style: TextStyle(color: Colors.blue),
                          ),
                        )),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        profileSelected
                            ? showProfileUploadAndCropButton()
                            : Container(),
                        start1
                            ? Center(
                                child: circularProgress(),
                              )
                            : Container(),
                        profilePicUploadedStatus
                            ? Center(
                                child: Text(
                                  'Uploaded',
                                  style: TextStyle(color: Colors.green),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 200,
                      child: GridTile(
                        child: Card(
                          elevation: 10,
                          child: InkWell(
                            onTap: () {
                              getImage(2);
                            },
                            child: _displayChild2(),
                          ),
                        ),
                        footer: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Address Proof',
                            style: TextStyle(color: Colors.blue),
                          ),
                        )),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        addProofSelected
                            ? showAddProofUploadAndCropButton()
                            : Container(),
                        start2
                            ? Center(
                                child: circularProgress(),
                              )
                            : Container(),
                        addressProofUploadedStatus
                            ? Center(
                                child: Text(
                                  'Uploaded',
                                  style: TextStyle(color: Colors.green),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FloatingActionButton(
        child: Text('Done'),
        elevation: 15,
        onPressed: () {
          uploadDataToFirebase();
          triggerDoneDialog(context);
        },
      ),
    );
  }

  triggerDoneDialog(BuildContext context) {
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
                  'Ok',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 25,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _displayChild1() {
    if (_image1 != null) {
      return Image.file(_image1, fit: BoxFit.fill);
    } else {
      return Icon(
        Icons.add_a_photo,
        size: 100,
        color: Colors.blueGrey,
      );
    }
  }

  Widget _displayChild2() {
    if (_image2 != null) {
      return Image.file(_image2, fit: BoxFit.fill);
    } else {
      return Icon(
        Icons.add_a_photo,
        size: 100,
        color: Colors.blueGrey,
      );
    }
  }

  Widget showProfileUploadAndCropButton() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.file_upload,
            size: 30,
          ),
          title: Text(
            'Upload',
            style: TextStyle(color: Colors.blue),
          ),
          onTap: () {
            setState(() {
              profileSelected = false;
              start1 = true;
            });
            uploadProfilePic();
          },
        ),
        SizedBox(
          height: 10,
        ),
        FlatButton(
          child: Text(
            'Crop',
            style: TextStyle(color: Colors.blue),
          ),
          onPressed: () {},
        )
      ],
    );
  }

  Widget showAddProofUploadAndCropButton() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.file_upload,
            size: 30,
          ),
          title: Text(
            'Upload',
            style: TextStyle(color: Colors.blue),
          ),
          onTap: () {
            setState(() {
              addProofSelected = false;
              start2 = true;
            });
            uploadAddressProof();
          },
        ),
        SizedBox(
          height: 10,
        ),
        FlatButton(
          child: Text(
            'Crop',
            style: TextStyle(color: Colors.blue),
          ),
          onPressed: () {},
        )
      ],
    );
  }
}
