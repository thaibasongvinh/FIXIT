import 'package:flutter/material.dart';

class OnboardingItem {
  final String id;
  final String title;
  final String description;
  final String imagePath;
  final Color backgroundColor;
  final String buttonText;
  final int order;

  OnboardingItem({
    this.id = '',
    required this.title,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
    required this.buttonText,
    required this.order,
  });

  factory OnboardingItem.fromMap(Map<String, dynamic> map, [String? id]) {
    return OnboardingItem(
      id: id ?? map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imagePath: map['imagePath'] ?? '',
      backgroundColor: Color(int.parse(map['backgroundColor'] ?? '0xFFFFFFFF')),
      buttonText: map['buttonText'] ?? 'Tiếp theo',
      order: map['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'backgroundColor': '0x${backgroundColor.toARGB32().toRadixString(16).toUpperCase()}',
      'buttonText': buttonText,
      'order': order,
    };
  }
}
