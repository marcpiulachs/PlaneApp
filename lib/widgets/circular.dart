import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';

class CircularProgressBar extends StatelessWidget {
  final double progress;
  final IconData icon;
  final String text;
  final Color color;
  final double size;

  const CircularProgressBar({
    super.key,
    required this.progress,
    required this.icon,
    required this.text,
    this.size = 80.0,
    this.color = AppTheme.instrumentMark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5A5A62),
            AppTheme.instrumentBezel,
            Color(0xFF1C1C20),
          ],
        ),
        border: Border.all(color: Colors.black45, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.instrumentFace,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: SizedBox.expand(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, widget) =>
                      CircularProgressIndicator(
                    value: value,
                    strokeWidth: 3.5,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.white10,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30, color: AppTheme.instrumentMark),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}