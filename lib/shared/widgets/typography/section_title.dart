import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key, 
    required this.text,
    this.fontSize = 24,
    this.color = const Color(0xFF424242),
  });
  
  final String text;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
