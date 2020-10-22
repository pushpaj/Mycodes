import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        centerTitle: true,
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          settingButton('Change Wifi Credentials'),
        ],
      ), 
    );
  }

  Widget settingButton(String text) {
    return RaisedButton(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      onPressed: () async {
        await launch('https:192.168.4.1/', forceWebView: false);
      },
      child: Text(text),
      color: Colors.blueGrey[700],
    );
  }
}
