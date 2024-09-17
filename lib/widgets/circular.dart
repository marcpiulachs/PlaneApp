import 'package:flutter/material.dart';

class CircularProgressBar extends StatelessWidget {
  final double progress;
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final double size;

  const CircularProgressBar({
    super.key,
    required this.progress,
    required this.icon,
    required this.text,
    this.size = 80.0,
    this.backgroundColor = const Color.fromARGB(0, 40, 29, 29),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Círculo gris de fondo
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
          ),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 500),
            builder: (context, value, widget) => CircularProgressIndicator(
              value: value,
              strokeWidth: 5,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ),
        ),
        // Contenido del círculo (icono y texto)
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: Colors.black),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
