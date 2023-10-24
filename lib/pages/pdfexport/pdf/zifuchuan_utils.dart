import 'package:flutter/material.dart';

double calculateStringWidth(String text, double fontSize) {
  TextPainter painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(fontSize: fontSize),
    ),
    textDirection: TextDirection.ltr,
  )..layout();

  return painter.width;
}
