import 'package:autowares/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:autowares/homepage.dart';
import 'package:web_socket_channel/io.dart';
import 'cameras.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: "Xiaomi Cam App Clone",
      home: LoginPage(),
      /*home: CCTVCameras(
        channel: IOWebSocketChannel.connect('ws://34.94.119.249:65080'),
      ),*/
    );
  }
}


