// authors: Vincent
// Draws a custom widget showing date and time of an event
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:dyadapp/src/utils/theme_model.dart';

import '../pages/profile.dart';
import '../utils/api_provider.dart';
import '../utils/data/group.dart';

final Map<int, String> months_abbrev = {
  1: "JAN",
  2: "FEB",
  3: "MAR",
  4: "APR",
  5: "MAY",
  6: "JUN",
  7: "JUL",
  8: "AUG",
  9: "SEP",
  10: "OCT",
  11: "NOV",
  12: "DEC"
};

class Calendar extends CustomPainter {
  DateTime time = DateTime.now();

  Calendar(this.time);

  // Draw out a date time with the day of the month and the month's initials
  @override
  paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;

    // background
    RRect base = RRect.fromLTRBAndCorners(0, 0, size.width, size.height,
        topLeft: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
        topRight: Radius.circular(10));
    var bgPainter = Paint()..color = Color(0xFFB8BEC9);

    RRect monthBG = RRect.fromLTRBAndCorners(0, 0, size.width, 20,
        topLeft: Radius.circular(10), topRight: Radius.circular(10));
    var monthBGPainter = Paint()..color = Color(0xFF81A1C1);

    // month text
    final monthTextSpan = TextSpan(
        text: months_abbrev[time.month],
        style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w500,
            fontSize: 18));

    final monthTextPainter =
        TextPainter(text: monthTextSpan, textDirection: TextDirection.ltr)
          ..layout(minWidth: 0, maxWidth: size.width);

    // day text
    final dayTextSpan = TextSpan(
        text: time.day.toString(),
        style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
            fontSize: 40));

    final dayTextPainter =
        TextPainter(text: dayTextSpan, textDirection: TextDirection.ltr)
          ..layout(minWidth: 0, maxWidth: size.width);

    canvas.drawRRect(base, bgPainter);
    canvas.drawRRect(monthBG, monthBGPainter);
    dayTextPainter.paint(
        canvas, Offset(centerX - dayTextPainter.width / 2, 20));
    monthTextPainter.paint(
        canvas, Offset(centerX - monthTextPainter.width / 2, 0));
  }

  // If the old date is different than the new date we have to repaint the widget
  @override
  shouldRepaint(Calendar oldDelegate) {
    if (oldDelegate.time != time) {
      return true;
    }
    return false;
  }
}

class Schedule extends StatelessWidget {
  const Schedule(
    this.time, {
    Key? key,
  }) : super(key: key);

  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFD8DEE9),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            child: CustomPaint(painter: Calendar(time)),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
                intl.DateFormat("jm").format(time),
                style: TextStyle(
                    color: Color(0xFF5E81AC), fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}
