import 'package:autowares/homepage.dart';
import 'package:autowares/signuppage.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomPaint(
        painter: CustomBackground(),
        child: ListView(
          children: <Widget>[
            Container(
              //height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              child: Center(
                child: Image.asset('images/loginpic.png')
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 18),
              child: Text(
                'Welcome back!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 18),
              child: Text(
                'Please login to continue our app',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.withOpacity(0.4)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, left: 18, right: 18),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.313,
                child: Material(
                  color: Colors.transparent,
                  elevation: 10,
                  child: LayoutBuilder(
                    builder: (_, constraints) {
                      return Container(
                        width: constraints.widthConstraints().maxWidth,
                        height: constraints.widthConstraints().maxHeight,
                        child: CustomPaint(
                          painter: LoginDialog(),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 18, left: 15, right: 15),
                                child: TextField(
                                  decoration: new InputDecoration(
                                      prefixIcon: Icon(Icons.mail_outline),
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                      ),
                                      filled: true,
                                      hintStyle: new TextStyle(
                                          color: Colors.white.withOpacity(0.2)),
                                      hintText: "UserName or email",
                                      fillColor: Colors.blueGrey[700]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 18, left: 15, right: 15),
                                child: TextField(
                                  decoration: new InputDecoration(
                                      prefixIcon: Icon(Icons.lock_outline),
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                      ),
                                      filled: true,
                                      hintStyle: new TextStyle(
                                          color: Colors.white.withOpacity(0.2)),
                                      hintText: "Password",
                                      fillColor: Colors.blueGrey[700]),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Checkbox(value: false, onChanged: null),
                                        Text('Remember Me'),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Text('Forget Password?'),
                                  ),
                                ],
                              ),
                              FloatingActionButton.extended(
                                backgroundColor: Colors.teal[100],
                                onPressed: () {},
                                label: FlatButton(
                                  onPressed: (){
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: RaisedButton(
                color: Colors.blueGrey[700],
                child: Text('New to HomeAutoware? Sign Up',style: TextStyle(color: Colors.white.withOpacity(0.2)),),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();
    paint.color = Colors.blueGrey[900];
    Paint ovalPaint = Paint();
    ovalPaint.color = Colors.blueGrey[700];

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    canvas.drawPath(mainBackground, paint);

    Path ovalPath = Path();
    ovalPath.moveTo(0, height * 0.25);
    ovalPath.arcToPoint(Offset(width * 0.6, height * 0.19),
        radius: Radius.circular(400), clockwise: false);
    ovalPath.quadraticBezierTo(
        width * 1.12, height * 0.02, width * 1.1, height * 0.25);
    ovalPath.arcToPoint(Offset(0, height * 0.4), radius: Radius.circular(600));
    ovalPath.close();
    canvas.drawPath(ovalPath, ovalPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class LoginDialog extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();
    paint.color = Colors.blueGrey[900];

    Path boxPath = Path();
    List<Offset> points = [
      Offset(0, 0),
      Offset(width, 0),
      Offset(width, height * 0.9),
      Offset(width * 0.65, height),
      Offset(width * 0.35, height),
      Offset(0, height * 0.9),
    ];
    boxPath.addPolygon(points, true);
    canvas.drawPath(boxPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate != this;
  }
}
