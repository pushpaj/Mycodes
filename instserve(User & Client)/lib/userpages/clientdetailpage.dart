import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class ClientDetailPage extends StatefulWidget {
  final profile_name;
  final profile_age;
  final profile_image;
  final profile_contact;
  final profile_gender;
  final profile_exp;
  final profile_status;
  final profile_desc;

  ClientDetailPage({
    this.profile_name,
    this.profile_age,
    this.profile_image,
    this.profile_contact,
    this.profile_gender,
    this.profile_exp,
    this.profile_status,
    this.profile_desc,
  });
  @override
  _ClientDetailPageState createState() => _ClientDetailPageState();
}

class _ClientDetailPageState extends State<ClientDetailPage> {
  int number;
  final format = DateFormat.yMMMMd("en_US");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(right: 20, left: 20),
        child: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                border: Border.all(color: Colors.blue),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 1.5,
              child: widget.profile_image != null
                  ? Image.network(
                      widget.profile_image,
                      fit: BoxFit.fill,
                    )
                  : Icon(
                      Icons.person_add,
                      size: 200,
                    ),
            ),
            SizedBox(
              height: 5,
            ),
            widget.profile_name == null
                ? Text(
                    'Unknown',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
                : Text(
                    widget.profile_name,
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 20,
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Text("DOB:"),
                widget.profile_age == null
                    ? Text('Not Mentioned',
                        style: TextStyle(color: Colors.teal))
                    : Text(widget.profile_age,
                        style: TextStyle(color: Colors.teal)),
              ],
            ),
            Row(
              children: <Widget>[
                Text("Gender:"),
                widget.profile_gender == null
                    ? Text('Not Mentioned',
                        style: TextStyle(color: Colors.teal))
                    : Text(widget.profile_gender,
                        style: TextStyle(color: Colors.teal)),
              ],
            ),
            Row(
              children: <Widget>[
                Text("Experience:"),
                Text(widget.profile_exp != null ? widget.profile_exp : "N/A",
                    style: TextStyle(color: Colors.teal))
              ],
            ),
            Row(
              children: <Widget>[
                Text("Contact:"),
                (widget.profile_contact == null)
                    ? Text('Not Mentioned',
                        style: TextStyle(color: Colors.green))
                    : Text(widget.profile_contact.toString(),
                        style: TextStyle(color: Colors.teal)),
                SizedBox(
                  width: 70,
                ),
                OutlineButton(
                  child: Text("Call"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.green),
                  ),
                  splashColor: Colors.orange,
                  textColor: Colors.teal,
                  borderSide: BorderSide(color: Colors.teal),
                  color: Colors.green,
                  onPressed: () async {
                    int number = int.parse(widget.profile_contact);
                    var url = 'tel:$number';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text("Status:"),
                Text(
                  widget.profile_status == null
                      ? 'Available'
                      : widget.profile_status,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            Divider(),
            Center(
              child: Text(
                "About",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              child: widget.profile_desc != null
                  ? Text(
                      widget.profile_desc,
                    )
                  : Container(
                    padding: EdgeInsets.all(15),
                      child: Center(
                        child: Text(
                          'No description is available!',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget _contact() {}
}
