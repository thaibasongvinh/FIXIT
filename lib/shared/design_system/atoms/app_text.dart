import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const AppText(this.text, {super.key, this.style, this.textAlign, this.overflow, this.maxLines});

  factory AppText.heading1(String text, {Color? color}) => AppText(
    text,
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
  );

  factory AppText.body(String text, {Color? color}) => AppText(
    text,
    style: TextStyle(fontSize: 16, color: color),
  );

  factory AppText.caption(String text, {Color? color}) => AppText(
    text,
    style: TextStyle(fontSize: 12, color: color?.withOpacity(0.7) ?? Colors.grey),
  );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
