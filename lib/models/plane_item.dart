// Define the PlaneItem class
import 'package:flutter/material.dart';

class PlaneItem {
  final String imageUrl;
  final String title;
  final String description;
  final double progress1;
  final double progress2;
  final double progress3;
  final IconData icon;

  PlaneItem({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.icon,
    required this.progress1,
    required this.progress2,
    required this.progress3,
  });
}
