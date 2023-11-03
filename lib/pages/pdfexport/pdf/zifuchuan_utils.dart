import 'package:flutter/material.dart';

//计算字符串像素宽度
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
