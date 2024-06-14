import 'package:flutter/material.dart';

class PostBoxPainter extends CustomPainter {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  PostBoxPainter(this.text, {this.backgroundColor = Colors.yellow, this.textColor = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    final TextSpan span = TextSpan(
      style: TextStyle(color: textColor, fontSize: 20, fontFamily: 'RedHatText', fontWeight: FontWeight.w500),
      text: text,
    );

    final TextPainter tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    );

    tp.layout(
      maxWidth: size.width * 0.8, // You can adjust the max width based on your requirement
    );
    // Layer 1
    final Paint paintFill0 = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
    final double height = size.height;
    final double width = size.width;

    final Path path0 = Path();
    path0.moveTo(width * 0.0723400, height * 0.0195947);
    path0.quadraticBezierTo(width * 0.0008450, height * 0.0223105, width * 0.0003700, height * 0.0978000);
    path0.quadraticBezierTo(width * 0.0005300, height * 0.3021737, width * 0.0010250, height * 0.9152684);
    path0.quadraticBezierTo(width * -0.0015700, height * 0.9911053, width * 0.0695350, height * 0.9930789);
    path0.cubicTo(
      width * 0.2145150,
      height * 0.9929421,
      width * 0.5044800,
      height * 0.9926789,
      width * 0.6494650,
      height * 0.9925421,
    );
    path0.quadraticBezierTo(width * 0.7188100, height * 0.9898053, width * 0.7214450, height * 0.9146053);
    path0.quadraticBezierTo(width * 0.7212950, height * 0.7393789, width * 0.7212450, height * 0.6809632);
    path0.quadraticBezierTo(width * 0.7212950, height * 0.6029000, width * 0.7932250, height * 0.6030316);
    path0.quadraticBezierTo(width * 0.8985850, height * 0.6029368, width * 0.9337150, height * 0.6029105);
    path0.quadraticBezierTo(width * 1.0053950, height * 0.6054421, width * 1.0000000, height * 0.5288474);
    path0.quadraticBezierTo(width * 1.0081200, height * 0.2046789, width * 1.0000000, height * 0.0966263);
    path0.quadraticBezierTo(width * 1.0073550, height * 0.0189316, width * 0.9404350, height * 0.0188053);
    path0.lineTo(width * 0.0723400, height * 0.0195947);
    path0.close();
    canvas.clipPath(path0, doAntiAlias: false);

    canvas.drawPath(path0, paintFill0);

    final double dx = (size.width - tp.width) / 5;
    const double dy = 50;

    tp.paint(canvas, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
