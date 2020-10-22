import 'package:app4/pages/authenticate.dart';
import 'package:app4/pages/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: Authenticate(),
      //home: HomePage(),
    );
  }
}
