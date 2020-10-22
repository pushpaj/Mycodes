import 'package:flutter/material.dart';

class WaterLevel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
        child: LayoutBuilder(
          builder: (_, constraints) {
            return Container(
              width: constraints.widthConstraints().maxWidth,
              height: constraints.widthConstraints().maxHeight,
              color: Colors.white,
              child: CustomPaint(
                //painter: FaceOutlinePainter(),
                painter: CustomBackground(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class FaceOutlinePainter extends CustomPainter {
  int x=4;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.indigo;
    final redPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red;
 
    final redFadedPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red.withOpacity(0.6);

    final waterPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.lightBlue;

    final greenFadedPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.green[400];  

//=====================SMILY FACE==============================
   /* canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(20, 40, 100, 100), Radius.circular(20)),
      paint,
    );
    canvas.drawOval(
      Rect.fromLTWH(size.width - 120, 40, 100, 100),
      paint,
    );

    final mouth = Path();
    mouth.moveTo(size.width * 0.2, size.height * 0.6);
    mouth.arcToPoint(
      Offset(size.width * 0.8, size.height * 0.6),
      radius: Radius.circular(150),
      clockwise: false
    );
    mouth.arcToPoint(
      Offset(size.width * 0.2, size.height * 0.6),
      radius: Radius.circular(200),
      //clockwise: false
    );

    canvas.drawPath(mouth, paint);*/

   //==============WATER TANL LEVEL===============

   /*canvas.drawRect(Rect.fromLTWH(size.width*0.2, size.height*0.8, size.width*0.6, size.height*0.1), paint);
   canvas.drawRect(Rect.fromLTWH(size.width*0.2, size.height*0.7, size.width*0.6, size.height*0.1), paint);
   canvas.drawRect(Rect.fromLTWH(size.width*0.2, size.height*0.6, size.width*0.6, size.height*0.1), paint);
   canvas.drawRect(Rect.fromLTWH(size.width*0.2, size.height*0.5, size.width*0.6, size.height*0.1), paint);
   canvas.drawRect(Rect.fromLTWH(size.width*0.2, size.height*0.4, size.width*0.6, size.height*0.1), paint);
   canvas.drawRect(Rect.fromLTWH(size.width*0.2, size.height*0.3, size.width*0.6, size.height*0.1), paint);
   canvas.drawRect(Rect.fromLTWH(size.width*0.2, size.height*0.2, size.width*0.6, size.height*0.1), paint);

   canvas.drawRect(Rect.fromLTWH(size.width*0.2+2, size.height*0.8+2, size.width*0.6-4, size.height*0.1-4), redPaint);
   canvas.drawRect(Rect.fromLTWH(size.width*0.2+2, size.height*0.7+2, size.width*0.6-4, size.height*0.1-4), redFadedPaint);
   canvas.drawRect(Rect.fromLTWH(size.width*0.2, size.height*0.6, size.width*0.6, size.height*0.1), paint);
   canvas.drawRect(Rect.fromLTWH(size.width*0.2, size.height*0.5, size.width*0.6, size.height*0.1), paint);
   canvas.drawRect(Rect.fromLTWH(size.width*0.2, size.height*0.4, size.width*0.6, size.height*0.1), paint);
   canvas.drawRect(Rect.fromLTWH(size.width*0.2, size.height*0.3, size.width*0.6, size.height*0.1), greenFadedPaint);
   canvas.drawRect(Rect.fromLTWH(size.width*0.2, size.height*0.2, size.width*0.6, size.height*0.1), greenPaint);*/

   final opening = Path();
   canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(size.width*0.1,size.height*0.3, size.width*0.8, size.height*0.6), Radius.circular(15)), paint);
   opening.moveTo(size.width*0.3, size.height*0.3);
   opening.arcToPoint(Offset(size.width*0.7, size.height*0.3),radius: Radius.circular(100));
   canvas.drawPath(opening, paint);

   canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(size.width*0.1+2,size.height*(0.3+(7-x)*0.0857)+2, size.width*0.8-4, size.height*0.0857*x-4), Radius.circular(13)), waterPaint);
  }

  @override
  bool shouldRepaint(FaceOutlinePainter oldDelegate) => false;
}

class CustomBackground extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint=Paint();
    Paint ovalPaint = Paint();
    ovalPaint.color=Colors.blueGrey;

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color =Colors.blue.shade700;
    canvas.drawPath(mainBackground, paint);

    Path ovalPath = Path();
    ovalPath.moveTo(0, height*0.2);
    ovalPath.quadraticBezierTo(width*0.8, height*0.005, width*0.62, height*0.5);
    canvas.drawPath(ovalPath, ovalPaint);

    ovalPath.quadraticBezierTo(width*0.6, height*0.62, 0, height*0.9);
    canvas.drawPath(ovalPath, ovalPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate !=this;
  }
  
}
